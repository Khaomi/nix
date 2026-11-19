{
  description = "My nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      configuration = { pkgs, ... }: {
        nix.package = pkgs.lix;
        nixpkgs.config.allowUnfree = true;

        # These are all the packages that I can't find on Nixpkgs or Home Manager's options, or it exists and doesn't work.
        homebrew.enable = true;
        homebrew.user = "khaomi";
        homebrew.enableZshIntegration = true;

        homebrew.brews = [
          "direnv"
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
        ];

        homebrew.vscode = [
          "bbenoist.Nix"
        ];

        # Sadly, also have to install this globally, which is fine tbh
        programs.mas.user = "khaomi";
        programs.mas.packages = {
          "Bitwarden" = 1137397744;
        };

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
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

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
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
        # What is different between this and NSGlobalDomain?
        system.defaults.finder.AppleShowAllExtensions = true;
        system.defaults.finder.AppleShowAllFiles = true;
        system.defaults.hitoolbox.AppleFnUsageType = "Change Input Source";

        system.defaults = {
          CustomUserPreferences = {
            # Reopen apps on Restart / Shutdown
            "com.apple.loginwindow" = {
              TALLogoutSavesState = false;
              LoginwindowLaunchesRelaunchApps = false;
            };
          };
        };

        networking.hostName = "LixBook-Air";
        networking.computerName = "LixBook Air";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#LixBook-Air
      darwinConfigurations."LixBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.khaomi = ./home.nix;
            };
          }
        ];
      };
    };
}
