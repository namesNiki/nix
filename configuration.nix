# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }: {

  #Genral nix configs
  imports =
    [ ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nixpkgs.config = { 
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-24.8.6"
    ];
  };
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

  #Localization
  time.timeZone = "Europe/Warsaw";

  #Dwm & Graphics
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.dwm.enable = true;
  };

  #Dwm & Dmenu overlays
  nixpkgs.overlays = [
	(final: prev: {
	  dwm = prev.dwm.overrideAttrs (old: { src = /etc/nixos/assets/dwm-6.4 ;});
	})
	(final: prev: {
	  dmenu = prev.dmenu.overrideAttrs (old: { src = /etc/nixos/assets/dmenu_test ;});
	})
  ];
  
  #Networking
  networking.hostName = "nya";

  #Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
  	#Utils
  	wget
    neofetch
    git
    ktorrent
    vlc
    drawpile
    CuboCore.coreshot

  	#Programming utilities
  	helix #Editors
  	vim
    jetbrains.idea-community
    
    raylib # Libraries
    mesa
    xorg.libX11
    xorg.libX11.dev

    gnumake # Make
    cmake

    docker # Other

    #Programming languages
    rustup #Rust

    zig # Zig
    zls

    gcc # C
    ccls

    jdk # Java

    opam # Ocaml
    ocamlPackages.utop
    dune-release
    ocamlPackages.ocaml-lsp
    ocamlPackages.odoc
    ocamlPackages.ocamlformat_0_26_0

  	#Web
  	firefox

    #Fun
    spotify
    steam
    obsidian
    discord
    prismlauncher
    blockbench-electron
    sl

  	#System
    kitty
    alsa-oss
    fzf
    nitrogen
    picom
    dmenu
  ];

  #Fonts
  fonts.packages = with pkgs; [
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

