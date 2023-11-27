# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, fetchgit, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nya"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  #  keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
 # services.xserver.windowManager.dwm = {
 # 	enable = true;
 #	package = pkgs.dwm.overrideAttrs {
 #		src = "/home/niki/stuffs/dwm-6.4";
 #	};
 # };
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.startx.enable = true;

  nixpkgs.overlays = [
	(final: prev: {
	  dwm = prev.dwm.overrideAttrs (old: { src = /etc/nixos/assets/dwm-6.4 ;});
	})
	(final: prev: {
	  dmenu = prev.dmenu.overrideAttrs (old: { src = /etc/nixos/assets/dmenu_test ;});
	})
  ];

  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
#  hardware.pulseaudio.enable = true;
#  nixpkgs.config.pulseaudio = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  jack.enable = true;
};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.niki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	wget
	firefox
	pamixer
	git
	picom
	alacritty
	nitrogen
	dmenu
	neofetch
	steam
	rustup
	gcc
	nodejs
	helix
	vscode
	spotify
	prismlauncher-unwrapped
	rust-analyzer
	alsa-oss
	jdk17
	fzf
	discord
	gnumake
	gzdoom
	unzip
	cinnamon.nemo
  ];

  fonts.fonts = with pkgs; [
	jetbrains-mono
	nerdfonts

  ];

  

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  programs.zsh.enable = true;
  programs.zsh.syntaxHighlighting = {
	enable = true;
	highlighters = ["main" "brackets" "pattern" "cursor" "regexp" "root" "line"];
  };


  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  users.users.niki.shell = pkgs.zsh;


  home-manager.users.niki = { pkgs, ... }: {
	
	home.stateVersion = "23.05";

	programs.alacritty = {
	  enable = true;
	  settings = {
	  	window.opacity = 0.75;
	  };
	};

	programs.helix.languages = {
		
		language = [{
		name = "rust";
		scope = "source.rs";
		file-types = ["rs"];
		comment-token = "//";
		language-servers = [ "rust-analyzer" ];
		}];

		language-server.rust-analyzer = {
		command = "rust-analyzer";
		config.check.command = "clippy";
		};

	};
	programs.helix.settings = { 
		theme = "everblush"; 
	};
	
	programs.zsh = {
		enable = true;
		enableAutosuggestions = true;
		enableCompletion = true;
		defaultKeymap = "vicmd";
		initExtra = ''
			clear
			neofetch
			alias vimnix="sudo vim /etc/nixos/configuration.nix"
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
		#syntaxHighlighting.enable = true;

	};
	programs.bash.enable = false;
	programs.bash.initExtra = ''
	neofetch
	PS1='\[\e[38;5;129m\][\[\e[38;5;27m\]$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2)\[\e[38;5;163m\]>\[\e[38;5;46m\]\u\[\e[38;5;202m\]@\[\e[38;5;196m\]\h\[\e[38;5;163m\]:\[\e[38;5;44m\]\W\[\e[38;5;129m\]]\[\e[38;5;148;5m\]\\$ \[\e[0m\]'
	'';

#	programs.vscode = {
#		enable = true;
#		package = pkgs.vscodium;
#		extensions = with pkgs.vscode-extensions; [
#			rust-lang.rust-analyzer
#			vscodevim.vim
#		];
#	};


  };

}

