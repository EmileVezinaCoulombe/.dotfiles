# Help
# man configuration.nix
# nixos-help

{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Turn on flag for proprietary software
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/emile/.dotfiles/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "/home/emile/.dotfiles/nixos/"
    ];
  };

  # Enable Copy past for boxes vm
  # services.spice-vdagentd.enable = true;

  # Warning unstable features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.hostName = "emile-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "fr";
    xkbVariant = "us";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.emile = {
    isNormalUser = true;
    description = "emile";
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
      php
      python3
      ripgrep
      rustup
      spice
      spice-vdagent
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  # NVIDIA GPU
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # man configuration.nix or on https://nixos.org/nixos/options.html.
  system.stateVersion = "23.05";

}
