{
  pkgs,
  inputs,
  ...
}:
{
  imports = [./remote-build.nix];

  nix.package = pkgs.lix;
  nixpkgs.config.allowUnfree = true;

  # These are all the packages that I can't find on Nixpkgs or Home Manager's options, or it exists and doesn't work.
  homebrew.enable = true;
  homebrew.user = "khaomi";
  homebrew.enableZshIntegration = true;

  homebrew.brews = [
    "direnv"
    "uv"
  ];

  homebrew.casks = [
    "firefox"
    "telegram"
    "termius"
    "syncthing-app"
    "steam"
    "docker-desktop"
    "sable"
    "batfi"
    "tailscale-app"
    "pangolin"
  ];

  # homebrew.vscode = [
  #   "bbenoist.Nix"
  # ];

  # Sadly, also have to install this globally, which is fine tbh
  programs.mas.user = "khaomi";
  programs.mas.packages = {
    "Bitwarden" = 1137397744;
  };

  environment.systemPackages = with pkgs; [
    nixfmt
    vim
    git
    wget
    curl
  ];

  home-manager.backupFileExtension = "backup";

  users.users.khaomi = {
    name = "khaomi";
    home = "/Users/khaomi";
    createHome = true;
  };

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # MY OWN OPTIONS YIPPE
  system.primaryUser = "khaomi";
  system.startup.chime = false;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.dock.show-recents = false;
  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.hitoolbox.AppleFnUsageType = "Change Input Source";

  # Use dotted path so it merges instead of replacing other system.defaults.* keys
  system.defaults.CustomUserPreferences = {
    "com.apple.loginwindow" = {
      TALLogoutSavesState = false;
      LoginwindowLaunchesRelaunchApps = false;
    };
  };

  networking.hostName = "LixBook-Air";
  networking.computerName = "LixBook Air";

  # My Nix STUFF!
  nix.gc.automatic = true;
  nix.gc.interval = { Hour = 3; Minute = 0; };
  nix.gc.options = "--delete-older-than 7d";
  nix.optimise.automatic = true;

  # Wire Home Manager directly inside the host module (or in darwinConfigurations)
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.khaomi = ./home.nix;
  };
}
