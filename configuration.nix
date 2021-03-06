# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # Garbage colloction
  nix.gc.dates = "weekly";

  # do nothing on pressing power button
  services.logind.extraConfig = ''HandlePowerKey=ignore'' ;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };

  # Font
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Mononoki" ]; })
  ];


  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Configure keymap in X11
    layout = "dvorak";
    xkbOptions = "caps:escape";

    #desktopManager = {
      #gnome.enable = true;
      #xterm.enable = false;
    #};
   
    displayManager = {
      #gdm.enable = true;
      startx.enable = true;
      #defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        # i3lock #default i3 screen locker
        # i3blocks #if you are planning on using i3blocks over i3status
      ];
    };

    videoDrivers = [ "intel" ];                                                                                                              deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };
  # services.compton.enable = true;
  


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xayon = {
    isNormalUser = true;
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Text editors
    vim 
    emacs

    # consol commands
    bintools
    git
    zsh
    exa
    starship
    htop
    light # for screen brightness

    # terminal emulators
    kitty

    # web
    wget
    firefox
    google-chrome

    # Libraries
    ## OpenCL
    ocl-icd

    # Programming Languages
    ## C/C++
    gcc
    clang
    ## Rust
    rustc
    rls
    cargo
    ## Haskell
    stack
    haskellPackages.haskell-language-server
  ];

  security.sudo.wheelNeedsPassword = false; 

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

