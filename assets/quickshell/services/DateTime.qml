pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property string time: Qt.formatDateTime(clock.date, "hh:mm")

  readonly property var yesterdayDate: {
    let d = new Date(clock.date)
    d.setDate(d.getDate() - 1)
    return d
  }

  readonly property var tomorrowDate: {
    let d = new Date(clock.date)
    d.setDate(d.getDate() + 1)
    return d
  }

  readonly property string yesterdayDayName: Qt.formatDateTime(yesterdayDate, "ddd")
  readonly property string yesterdayDayNumber: Qt.formatDateTime(yesterdayDate, "d")

  readonly property string weekDayName: Qt.formatDateTime(clock.date, "ddd")
  readonly property string dayDateNumber: Qt.formatDateTime(clock.date, "d")

  readonly property string tomorrowDayName: Qt.formatDateTime(tomorrowDate, "ddd")
  readonly property string tomorrowDayNumber: Qt.formatDateTime(tomorrowDate, "d")

  property SystemClock clock: SystemClock {
    precision: SystemClock.Minutes
  }
}