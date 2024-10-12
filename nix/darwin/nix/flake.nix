{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.obsidian
        ];

      homebrew = {
        enable = true;
        # onActivation.cleanup = "zap";
        casks = [
          "cursor"
          "finalshell"
          "font-jetbrains-mono-nerd-font"
          "iina"
          "itsycal"
          "jordanbaird-ice"
          "logi-options+"
          "monitorcontrol"
          "orbstack"
          "raycast"
          "snipaste"
          "visual-studio-code"
          "wezterm"
          "the-unarchiver"
          "arc"
          "neteasemusic"
        ];
        brews = [
          "bat"
          "eza"
          "fd"
          "fnm"
          "fzf"
          "git"
          "git-delta"
          "neofetch"
          "neovim"
          "starship"
          "thefuck"
          "tlrc"
          "zoxide"
          "zsh"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
          "oven-sh/bun/bun"
          "mas"
        ];
        masApps = {
          "DingTalk" = 1435447041;
        };
        # vscode = [
        #   "antfu.iconify"
        #   "antfu.icons-carbon"
        #   "antfu.theme-vitesse"
        #   "antfu.unocss"
        #   "catppuccin.catppuccin-vsc"
        #   "catppuccin.catppuccin-vsc-icons"
        #   "christian-kohler.path-intellisense"
        #   "dbaeumer.vscode-eslint"
        #   "eamodio.gitlens"
        #   "esbenp.prettier-vscode"
        #   "johnsoncodehk.vscode-tsconfig-helper"
        #   "lewxdev.vscode-glyph"
        #   "naumovs.color-highlight"
        #   "nichabosh.minimalist-dark"
        #   "streetsidesoftware.code-spell-checker"
        #   "usernamehw.errorlens"
        #   "vue.volar"
        #   "whtouche.vscode-js-console-utils"
        # ];
      };
      
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#artsmp
    darwinConfigurations."artsmp" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "artsmp";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."artsmp".pkgs;
  };
}
