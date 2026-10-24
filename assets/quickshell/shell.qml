//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
//@ pragma DefaultEnv QS_ICON_THEME=Adwaita
//@ pragma IconTheme Adwaita
//@ pragma UseQApplication
//@ pragma DefaultEnv QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import QtQuick
import Quickshell

import "modules"
import "services"

ShellRoot {
  id: root

  // NotificationService { id: notificationService }

  // --- Core ---
  Background { }

  // --- Panels & UI ---
  TopBar { }
  BottomMenu { }
  SettingsApp { }
  LockScreen { }
}