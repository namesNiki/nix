# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }: {

  #Genral nix configs
  imports =
    [ ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #Boot menu and systemd
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  #Systemd
  systemd.services.seatd = {
    enable = true;
  };

  #Localization
  time.timeZone = "Europe/Warsaw";

  #Hyprland & Graphics
  programs.hyprland.enable = true;
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.hypr.enable = true;
  };
  
  #Networking
  networking.hostName = "nya";

  #Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
  	#Utils
  	wget
    neofetch
    git

  	#Programming utilities
  	helix #Editors
  	vim

    #Programming languages
    rustup #Rust

  	#Web
  	firefox

    #Fun
    spotify
    steam

  	#System
  	kitty
  	hyprpaper
    waybar
    wofi
    fzf
    libsForQt5.qtwayland
    libsForQt5.qt5ct
    libva
  ];

  #Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
  ];

  #User
  users.users.niki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  #Zsh
  programs.zsh.enable = true;
  programs.zsh.syntaxHighlighting = {
	enable = true;
  	highlighters = ["main" "brackets" "pattern" "cursor" "regexp" "root" "line"];
  };
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  users.users.niki.shell = pkgs.zsh;

  #Home manager
  home-manager.users.niki= {pkgs, ...}: {

    #Zsh
  	programs.zsh = {
  		enable = true;
  		enableAutosuggestions = true;
  		enableCompletion = true;
  		defaultKeymap = "vicmd";
  		initExtra = ''
  			clear
  			neofetch
  			alias vimnix="sudo vim /etc/nixos/configuration.nix"
  			alias hxnix="sudo hx /etc/nixos/configuration.nix"
  			alias game="bash /home/niki/game.sh"
  			alias 1=".."
  			alias 2="..."
  			alias 3="...."
  			alias 4="....."
  		'';	
  		oh-my-zsh = {
  			enable = true;
  			theme = "half-life";
  			plugins =["zsh-interactive-cd" "autojump" "colored-man-pages" "jump" "history-substring-search"];
  		};
    };

    programs.git = {
      enable = true;
      userName = "Names Niki";
      userEmail = "franczyslaw09@gmail.com";
    };
    
    home.stateVersion = "23.05";
  };
  system.stateVersion = "23.05"; 

}

