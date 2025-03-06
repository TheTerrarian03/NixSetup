# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NixMac"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Desktop/Window manager
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.openbox.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = { default = [ "gtk" ]; };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lsm03 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
  };

  # keyring
  services.gnome.gnome-keyring.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # basic system stuff
    networkmanagerapplet
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    gh
    flatpak
    blueman
    xorg.xev
    pulseaudio
    bc

    # window manager & desktop
    openbox
    obconf
    lxappearance
    tint2
    feh
    dmenu
    yazi

    # programming/dev
    vscode
    # docker
    python3
    rustup
    gcc

    # terminal/cli
    wezterm
    fastfetch
    htop
    ark
    gnumake

    # other programs
    firefox
    discord
    libreoffice
  ];

  # program setup/enable-ing
  programs.firefox.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.bash.shellAliases = {
    open="wezterm -e yazi $PWD & disown";
    vst-down="vst down \"$PWD\"";
    vst-up="vst up \"$PWD\"";
  };
  programs.bash.shellInit = ''
    vst() {
      python3 ~/Desktop/Programming2/Projects/VisualStudioTools/main.py "$@"
    }
  '';
  programs.bash.promptInit = ''
    git_branch() {
      # Check if we're in a Git repo
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [ -n "$branch" ]; then
        echo -e "─[\e[1;33m$branch\e[0m]"  # Yellow for branch name
      fi
    }

    PS1='[\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;35m\]\h\[\e[0m\]]─[\[\e[1;34m\]\W\[\e[0m\]]$(git_branch)=> '
  '';
  
  # services setup/enable-ing
  services.flatpak.enable = true;
  services.tlp.enable = true;

  # docker setup
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

