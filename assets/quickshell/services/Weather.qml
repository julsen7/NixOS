pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property string city: "Aachen"
    property string loc: "50.7753,6.0839"
    property bool useFahrenheit: false

    property string description: "Wetter lädt..."
    property string icon: "󰖐"
    property string temp: "--°C"
    property string feelsLike: "--°C"
    property string tempHigh: "--°C"
    property string tempLow: "--°C"
    property string sunrise: "--:--"
    property string sunset: "--:--"
    property int humidity: 0
    property real windSpeed: 0.0

    property var hourlyForecast: []

    property Timer refreshTimer: Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: root.reload()
    }

    Component.onCompleted: reload()

    function reload() {
        if (!loc || loc === "") {
            fetchLocationFromIP();
        } else {
            fetchWeatherData();
        }
    }

    function fetchLocationFromIP() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://ip-api.com/json?fields=status,city,lat,lon");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var res = JSON.parse(xhr.responseText);
                    if (res.status === "success") {
                        root.city = res.city || "Aachen";
                        root.loc = res.lat + "," + res.lon;
                        fetchWeatherData();
                    }
                } catch (e) {
                    console.log("Fehler beim IP-Location-Parsing:", e);
                }
            }
        };
        xhr.send();
    }

    function fetchWeatherData() {
        if (!loc || loc.indexOf(",") === -1) return;

        var parts = loc.split(",");
        var lat = parts[0].trim();
        var lon = parts[1].trim();

        var url = "https://api.open-meteo.com/v1/forecast?" +
            "latitude=" + lat +
            "&longitude=" + lon +
            "&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m" +
            "&hourly=weather_code,temperature_2m,precipitation_probability" +
            "&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset" +
            "&timezone=auto&forecast_days=2";

        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var json = JSON.parse(xhr.responseText);
                    parseWeatherData(json);
                } catch (e) {
                    console.log("Fehler beim Wetter-JSON Parsing:", e);
                }
            }
        };
        xhr.send();
    }

    function parseWeatherData(json) {
        if (!json.current || !json.hourly || !json.daily) return;

        var currentCode = json.current.weather_code;
        var curInfo = getWeatherInfo(currentCode, json.current.is_day === 1);

        root.description = curInfo.text;
        root.icon = curInfo.icon;
        root.temp = formatTemp(json.current.temperature_2m);
        root.feelsLike = formatTemp(json.current.apparent_temperature);
        root.humidity = Math.round(json.current.relative_humidity_2m);
        root.windSpeed = json.current.wind_speed_10m;

        if (json.daily.temperature_2m_max.length > 0) {
            root.tempHigh = formatTemp(json.daily.temperature_2m_max[0]);
            root.tempLow = formatTemp(json.daily.temperature_2m_min[0]);
        }

        if (json.daily.sunrise.length > 0) {
            root.sunrise = formatTimeStr(json.daily.sunrise[0]);
            root.sunset = formatTimeStr(json.daily.sunset[0]);
        }

        var hourlyList = [];
        var now = Date.now();

        for (var i = 0; i < json.hourly.time.length; i++) {
            var timeStr = json.hourly.time[i].replace("T", " ");
            var time = new Date(timeStr);

            if ((now - time) > 3000000) continue;

            var hourNum = time.getHours();
            var hourLabel = (hourlyList.length === 0) ? "Now" : (hourNum < 10 ? "0" + hourNum + ":00" : hourNum + ":00");
            var weather = getWeatherInfo(json.hourly.weather_code[i], true);

            hourlyList.push({
                "timestamp": json.hourly.time[i],
                "hour": hourLabel,
                "tempC": Math.round(json.hourly.temperature_2m[i]),
                "precipChance": json.hourly.precipitation_probability[i] || 0,
                "icon": weather.icon,
                "description": weather.text
            });

            if (hourlyList.length >= 8) break;
        }

        root.hourlyForecast = hourlyList;
    }

    function formatTemp(value) {
        if (value === undefined || value === null) return "--°C";
        if (root.useFahrenheit) {
            return Math.round(value * 9 / 5 + 32) + "°F";
        }
        return Math.round(value) + "°C";
    }

    function formatTimeStr(isoStr) {
        if (!isoStr) return "--:--";
        var parts = isoStr.split("T");
        return parts.length > 1 ? parts[1].substring(0, 5) : "--:--";
    }

    function getWeatherInfo(code, isDay) {
        var c = String(code);
        switch(c) {
            case "0": return { icon: isDay ? "󰖙" : "󰖔", text: "Klar" };
            case "1": return { icon: isDay ? "󰖕" : "󰼱", text: "Überwiegend klar" };
            case "2": return { icon: "󰖐", text: "Teilweise bewölkt" };
            case "3": return { icon: "󰅟", text: "Bedeckt" };
            case "45":
            case "48": return { icon: "󰖑", text: "Nebel" };
            case "51":
            case "53":
            case "55": return { icon: "󰖗", text: "Sprühregen" };
            case "56":
            case "57": return { icon: "󰙿", text: "Gefrierender Sprühregen" };
            case "61": return { icon: "󰖖", text: "Leichter Regen" };
            case "63": return { icon: "󰖖", text: "Regen" };
            case "65": return { icon: "󰖖", text: "Starker Regen" };
            case "66":
            case "67": return { icon: "󰙿", text: "Gefrierender Regen" };
            case "71": return { icon: "󰼶", text: "Leichter Schneefall" };
            case "73": return { icon: "󰼶", text: "Schneefall" };
            case "75": return { icon: "󰼶", text: "Starker Schneefall" };
            case "77": return { icon: "󰼶", text: "Schneegriesel" };
            case "80":
            case "81":
            case "82": return { icon: "󰖖", text: "Regenschauer" };
            case "85":
            case "86": return { icon: "󰼶", text: "Schneeschauer" };
            case "95": return { icon: "󰙾", text: "Gewitter" };
            case "96":
            case "99": return { icon: "󰙾", text: "Gewitter mit Hagel" };
            default:   return { icon: "󰖐", text: "Unbekannt" };
        }
    }

    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: root.reload()
    }
}