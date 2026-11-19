{ config, pkgs, ... }:

{
  home.username = "khaomi";
  home.homeDirectory = "/Users/khaomi";

  programs.zsh.enable = true;
  programs.zsh.initContent = ''
    eval "$(direnv hook zsh)"

    export SSH_AUTH_SOCK=/Users/${config.home.username}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
  '';

  programs.vscode.enable = true;
  programs.discord.enable = true;
  programs.thunderbird.enable = true;
  programs.fastfetch.enable = true;

  # Programming Langguage & Runtimes
  programs.bun.enable = true;

  home.file.".ssh/allowed_signers".text = ''
    git@khaomi.dev namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqPkrDHU06IGRF+Rs0LGGh0O360x3fz/bfAEwZ8Os63
  '';

  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Khaomi";
        email = "git@khaomi.dev";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBqPkrDHU06IGRF+Rs0LGGh0O360x3fz/bfAEwZ8Os63";
      };
      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
      gpg = {
        format = "ssh";
      };
      commit = {
        gpgsign = true;
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.fd.enable = true;
  programs.eza.enable = true;
  programs.ripgrep.enable = true;
  programs.jq.enable = true;
  programs.btop.enable = true;

  home.packages = with pkgs; [
    # GUI

    # CLI (no programs.<name> module in Home Manager)
    git-credential-manager
    sops
    yq-go
    bind
    mtr
    socat
    netcat
    iperf3
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BAT_THEME = "Catppuccin Mocha";
  };

  programs.zsh.shellAliases = {
    ls = "eza --icons";
    ll = "eza -la --icons --git";
    cat = "bat";
    grep = "rg";
    find = "fd";
    rebuild = "sudo darwin-rebuild switch --flake /etc/nix-darwin/";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
