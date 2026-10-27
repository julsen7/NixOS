{ config, pkgs, lib, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  home.stateVersion = "26.05";

  # THEME & CURSOR
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    theme.package = pkgs.gnome-themes-extra;
    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.adwaita-icon-theme;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  # SYSTEM
  xdg.enable = true;
  xdg.configFile = {
    "quickshell".source = ./assets/quickshell;
    # "obs-studio/basic".source = ./assets/obs-studio/basic;
  };
  xdg.desktopEntries."com.obsproject.Studio" = {
    name = "OBS Studio (Nvidia Offload)";
    exec = "nvidia-offload obs";
    icon = "com.obsproject.Studio";
    comment = "Free and open source software for video recording and live streaming";
    categories = [ "AudioVideo" "Recorder" ];
    terminal = false;
  };
  home.file = {
    "wallpaper".source = ./wallpaper;
  };
  services.hyprpolkitagent.enable = true;

  # PACKAGES
  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    extraConfig = ''
      -- Monitors
      hl.monitor({
        output   = "HDMI-A-1",
        mode     = "2560x1440@144",
        position = "1920x-500",
        scale    = 1,
      })

      hl.monitor({
        output   = "eDP-1",
        mode     = "1920x1080@144",
        position = "0x0",
        scale    = 1,
      })

      hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = 1,
      })

      -- Workspaces
      for i = 1, 3 do
        hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", persistent = true })
      end

      for i = 4, 6 do
        hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", persistent = true })
      end

      -- Startup 
      hl.on("hyprland.start", function()
        hl.exec_cmd("uwsm app -- quickshell -p /home/julsen/.config/quickshell")

        hl.exec_cmd("uwsm app -- discord --start-minimized")
        hl.exec_cmd("uwsm app -- spotify", { workspace = "6 silent" })

        hl.dispatch(hl.dsp.focus({ workspace = "1" }))
        hl.exec_cmd("xrandr --output HDMI-A-1 --primary")
      end)

      -- General
      hl.config({
        general = {
          border_size = 0,
          gaps_in = 5,
          gaps_out = 10,
          resize_on_border = true,
        },
        decoration = {
          rounding = 20,
          shadow = {
            enabled = true,
            range = 10,
            color = "rgba(000000ee)",
          },
        },
        input = {
          kb_layout = "de",
        },
      })

      -- Keybinds
      hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
      hl.bind("ALT + F4", hl.dsp.window.close())
      hl.bind("F11", hl.dsp.window.fullscreen())
      hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + T", hl.dsp.layout("togglesplit"))

      hl.bind("SUPER + up", hl.dsp.window.move({ direction = "up" }))
      hl.bind("SUPER + down", hl.dsp.window.move({ direction = "down" }))
      hl.bind("SUPER + right", hl.dsp.window.move({ direction = "right" }))
      hl.bind("SUPER + left", hl.dsp.window.move({ direction = "left" }))
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind("SUPER + A", hl.dsp.exec_cmd("uwsm app -- kitty --title=wiremix -e wiremix"))
      hl.bind("SUPER + X", hl.dsp.exec_cmd("uwsm app -- kitty --title=wiremix -e bluetui"))
      hl.bind("SUPER + S", hl.dsp.exec_cmd("uwsm app -- hyprshot -m region --clipboard-only"))
      hl.bind("SUPER + P", hl.dsp.exec_cmd("uwsm app -- hyprpicker -a"))

      hl.bind("SUPER + Q", hl.dsp.exec_cmd("uwsm app -- kitty"))
      hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm app -- thunar"))
      hl.bind("SUPER + B", hl.dsp.exec_cmd("uwsm app -- zen"))
      hl.bind("SUPER + M", hl.dsp.exec_cmd("uwsm app -- spotify"))
      hl.bind("SUPER + D", hl.dsp.exec_cmd("uwsm app -- discord"))
      hl.bind("SUPER + C", hl.dsp.exec_cmd("uwsm app -- code"))

      for i = 1, 6 do
        hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      -- Laptop
      hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

      -- Animations
      hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })
      hl.curve("rubber", { type = "spring", mass = 1, stiffness = 40, dampening = 10 })

      hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slide" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 2, spring = "rubber", style = "slide" })
    '';
  };

  services.udiskie = {
    enable = true;
    settings.program_options = {
      file_manager = "${pkgs.thunar}/bin/thunar";
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      ignoreAllDups = true;
      saveNoDups = true;
    };
    completionInit = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.cache/zsh/
    '';
    initContent = ''
      bindkey '^[[3~' delete-char
      fastfetch
    '';
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [ "--group-directories-first" ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.kitty = {
    enable = true;
    # font = {
    #   name = "JetBrainsMono Nerd Font";
    #   size = 12;
    # };
    settings = {
      # blue
      # color0 = "#100a19";
      # color1 = "#4E6468";
      # color2 = "#458A78";
      # color3 = "#4F7985";
      # color4 = "#33908F";
      # color5 = "#3DA19C";
      # color6 = "#51A192";
      # color7 = "#c3c1c5";

      # green
      color0 = "#343434";
      color1 = "#23b65a";
      color2 = "#43ff88";
      color3 = "#7cfcab";
      color4 = "#78c19f";
      color5 = "#7ae9a7";
      color6 = "#80deb2";
      color7 = "#ccdcd6";

      window_margin_width = "10 15";
      window_resize_step_cells = 5;
      window_resize_step_lines = 2;
      confirm_os_window_close = 0;
      remember_window_size = "no";
      startup_mode = "normal";
      background_opacity = "0.9";
      background_blur = 0;
      disable_ligatures = "never";
      cursor_stop_blinking_after = 0;
      cursor_trail = 10;
      mouse_hide_wait = "3.0";
      enable_audio_bell = false;
      force_ltr = false;
      detect_urls = true;
      window_padding_width = 30;
    };
    extraConfig = ''
      include current-theme.conf
    '';
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
      };
      display = {
        separator = " ";
      };
      modules = [
        "title"
        {
          type = "os";
          key = "os    ";
          keyColor = "33";
        }
        {
          type = "host";
          format = "{5} {1}";
          key = "host  ";
          keyColor = "33";
        }
        {
          type = "packages";
          format = "{}";
          key = "pkgs  ";
          nix = "all";
          keyColor = "33";
        }
        {
          type = "uptime";
          format = "{2}h {3}m";
          key = "uptime";
          keyColor = "33";
        }
        {
          type = "memory";
          key = "memory";
          keyColor = "33";
        }
        "break"
        {
          type = "colors";
          block = {
            range = [ 0 7 ];
          };
          keyColor = "33";
        }
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    presets = [ "no-runtime-versions" ];
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$os"
        "$directory"
        "$git_branch"
        "$git_status"
        "$fill"
        "$all"
        "$time"
        "$line_break"
        "$character"
      ];
      os = {
        format = "[$symbol]($style) ";
        disabled = false;
        symbols = {
          NixOS = "";
        };
      };
      directory = {
        format = "[󰉋 $path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = false;
        substitutions = {
          "Documents" = "󰈙 Documents";
          "Downloads" = " Downloads";
          "Pictures" = "󰋩 Pictures";
          "Repos" = "󱑢 Repos";
          "Server" = " Server";
        };
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      fill = {
        symbol = "·";
        style = "white";
      };
      maven = {
        format = " [$symbol ($version)]($style) ";
        symbol = "";
        style = "#c31e3d";
      };
      gradle = {
        format = " [$symbol ($version)]($style) ";
        symbol = "";
        style = "#02303a";
      };
      java = {
        format = " [$symbol ($version)]($style) ";
        symbol = "󰬷";
        style = "#ed8b00";
      };
      c = {
        format = " [$symbol ($version)]($style) ";
        symbol = "󰙱";
        style = "#3848a9";
      };
      cpp = {
        format = " [$symbol ($version)]($style) ";
        symbol = "󰙲";
        style = "#00599c";
      };
      haskell = {
        format = " [$symbol ($version)]($style) ";
        symbol = "󰲒";
        style = "#5e5086";
      };
      kotlin = {
        format = " [$symbol ($version)]($style) ";
        symbol = "󱈙";
      };
      python = {
        format = " [$symbol ($version)]($style) ";
        symbol = "󰌠";
        style = "#ffd43b";
      };
      time = {
        disabled = false;
        format = "  [$time]($style) ";
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name  = "julsen7";
      user.email = "263753131+julsen7@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "chat.tips.enabled" = false;
        "editor.fontFamily" = "JetBrainsMono Nerd Font Propo";
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmPasteNative" = false;
        "files.autoSave" = "afterDelay";
        "files.exclude" = {
          "**/.git" = false;
        };
        "files.simpleDialog.enable" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "workbench.colorTheme" = "GitHub Dark Default";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
        "workbench.startupEditor" = "none";
      };
      extensions = with pkgs.vscode-extensions; [
        davidanson.vscode-markdownlint
        eamodio.gitlens
        github.github-vscode-theme
        jnoortheen.nix-ide
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-python.vscode-python-envs
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        pkief.material-icon-theme
        redhat.java
        rust-lang.rust-analyzer
        tomoki1207.pdf
        vscjava.vscode-gradle
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
        vscjava.vscode-java-pack
        vscjava.vscode-java-test
        vscjava.vscode-maven
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "cpp-devtools";
          publisher = "ms-vscode";
          version = "0.6.18";
          sha256 = "sha256-5eq0m1jOyYzN8JCJWHWQFdkt1OzvBcO9P7cQ5dY7DoA=";
        }
        {
          name = "cpptools-themes";
          publisher = "ms-vscode";
          version = "2.0.0";
          sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
        }
       ];
    };
  };

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    theme = spicePkgs.themes.sleek;
    colorScheme = "UltraBlack";
  };

  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    thunar
    discord
    pinta
    krita
    davinci-resolve
    easyeffects
    prismlauncher
    heroic
    libreoffice-stable
    audacity
    lmms
    # jetbrains.idea
    # jetbrains.clion
    # jetbrains.pycharm

    btop
    wiremix
    bluetui
    _7zz
    openconnect
    hyprshot
    hyprpicker
    brightnessctl
    playerctl
    libnotify
    # hyprflow
    # cliphist
    # wl-clipboard
    # nvtopPackages.full
    
    # jdk
    # stdenv
    # cmake
    # ninja
    # cargo
    # rustc
    # python3
  ];
}
