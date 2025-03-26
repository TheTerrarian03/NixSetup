{ config, lib, pkgs, ... }:

{
  /* ----- IMPORTANT FIRST-TIME STUFF ----- */
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # networking
  networking.hostName = "NixMac";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixUser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];  # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      git
    ];
  };

  # system version
  system.stateVersion = "24.11"; # Did you read the comment?

  /* ----- AFTER-INSTALL STUFF TO ADD ------ */
  nix.settings.experimental-features = [ "nix-command" ];
  nixpkgs.config.allowUnfree = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Desktop/Window manager
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
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # keyring
  services.gnome.gnome-keyring.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # basic system stuff
    networkmanagerapplet
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
}
