# Help
# man configuration.nix
# nixos-help

{ config, pkgs, ... }:
{
  imports =
    [ 
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];

  # Turn on flag for proprietary software
  nix = {
    nixPath = [
        "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
        "nixos-config=/home/emile/.dotfiles/nixos/configuration.nix" 
        "/home/emile/.dotfiles/nixos"
	    "/nix/var/nix/profiles/per-user/root/channels"
	];
   };

  # Warning unstable features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-42ee82c6-8005-42e9-98ab-4a4c45723dab".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable Copy past for boxes vm
  services.spice-vdagentd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emile = {
    isNormalUser = true;
    description = "Emile";
    extraGroups = [ "networkmanager" "wheel" ];

    shell = pkgs.zsh;
    packages = with pkgs; [
      bat
      btop
      clang
      cmake
      exa
      fd
      firefox
      fzf
      gcc
      gh
      git
      gnumake
      go
      kitty
      lazygit
      lua
      luajitPackages.luarocks
      micro
      neofetch
      neovim 
      nnn
      nodejs_20
      oh-my-zsh
      php
      python3
      ripgrep
      rustup
      starship # zsh
      stow
      tmux
      unzip
      zplug
      zsh
      # nix-zsh-completions
      # zsh-autosuggestions
      # zsh-autocomplete
      # zsh-autopair
      # zsh-completions
      # zsh-forgit
      # zsh-syntax-highlighting
      # zsh-system-clipboard
      # zsh-vi-mode
      # zsh-you-should-use
      # zsh-z
      zulu # java
    #  thunderbird
    ];
  };

    home-manager.users.emile = { pkgs, ... }: {

        home.packages = [ pkgs.zplug ];
        programs.zsh = {
            enable = true;
            zplug = {
                enable = true;
                plugins = [
                    {name="wfxr/forgit";}
                ];
            };
        };

        # The state version is required and should stay at the version you
        # originally installed.
        home.stateVersion = "23.05";
    };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  programs.zsh.enable = true;
  programs.fzf.fuzzyCompletion = true;
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # man configuration.nix or on https://nixos.org/nixos/options.html.
  system.stateVersion = "23.05";

}

