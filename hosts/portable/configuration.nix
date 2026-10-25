{ config, lib, pkgs, options, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  system.stateVersion = "26.05";

  # USER
  users.users.julsen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$n8yEDLyG5/IORRV5SPJ5I.$KEdyBgQbDYMSWWxeZYgW/NpdKltwuBk7RZU7ydNzb5.";
  };

  # BINARIES
  programs.nix-ld = {
    enable = true;
    libraries = options.programs.nix-ld.libraries.default;
  };

  # ZSH
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # LOCALIZATION
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.options = "eurosign:e";
  console.useXkbConfig = true;

  # BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NETWORKING
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  # HARDWARE
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings.General = {
    Experimental = true;
    Privacy = "device";
    JustWorksRepairing = "always";
    Class = "0x000100";
    FastConnectable = true;
  };
  hardware.xpadneo.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # HARDWARE & GRAPHICS
  zramSwap.enable = true;
  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.prime.offload.enable = true;
  hardware.nvidia.prime.offload.enableOffloadCmd = true;
  hardware.nvidia.prime.amdgpuBusId = "PCI:5@0:0:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1@0:0:0";

  # VIRTUALISATION
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  programs.virt-manager.enable = true;

  # SERVICES & SECURITY
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland-uwsm";
    autoLogin.enable = true;
    autoLogin.user = "julsen";
  };

  # PROGRAMS
  nixpkgs.config.allowUnfree = true;
  programs.dconf.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # FONTS
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # NIXOS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 7d";
}
