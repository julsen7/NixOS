pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property bool isConnected: Networking.connected
    readonly property int connectivity: Networking.connectivity
    readonly property bool wifiEnabled: Networking.wifiEnabled

    function toggleWifi() {
        Networking.wifiEnabled = !Networking.wifiEnabled
    }

    function toggleLan() {
        if (!lanDevice) return;
        
        // Versucht das aktive Netzwerk-Profil zu trennen oder zu aktivieren
        if (lanDevice.network) {
            if (lanDevice.connected) {
                lanDevice.network.disconnect()
            } else {
                lanDevice.network.connect()
            }
        }
    }

    // --- GERÄTE-FILTERING MIT STRING-VERGLEICH ---
    readonly property WiredDevice lanDevice: {
        for (var i = 0; i < Networking.devices.length; i++) {
            var dev = Networking.devices[i];
            if (DeviceType.toString(dev.type) === "Wired") {
                return dev;
            }
        }
        return null;
    }

    readonly property WifiDevice wifiDevice: {
        for (var i = 0; i < Networking.devices.length; i++) {
            var dev = Networking.devices[i];
            if (DeviceType.toString(dev.type) === "Wifi") {
                return dev;
            }
        }
        return null;
    }

    // --- DYNAMISCHE EIGENSCHAFTEN ---
    readonly property string lanDeviceName: lanDevice ? lanDevice.name : "Kein LAN-Gerät"
    readonly property bool ethernetConnected: lanDevice ? lanDevice.connected : false
    readonly property bool lanCablePlugged: lanDevice ? lanDevice.hasLink : false

    // Holt alle sichtbaren WLAN-Netzwerke
    readonly property list<Network> wifiNetworks: wifiDevice ? wifiDevice.networks : []
}