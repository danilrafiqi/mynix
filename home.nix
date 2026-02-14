{ config, pkgs, lib, isWSL, username, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  # username is now passed via arguments
  
  # Logika: Install GUI apps jika di Mac ATAU (Linux murni dan BUKAN WSL)
  shouldInstallGUI = isDarwin || (isLinux && !isWSL);
in
{
  home.username = username;
  
  # Tetapkan home directory secara otomatis berdasarkan OS
  home.homeDirectory = if isDarwin 
    then "/Users/${username}" 
    else "/home/${username}";

  home.stateVersion = "25.11"; 

  # --- 1. Izin Unfree ---
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "google-chrome"
    "antigravity"
    "cursor"
    "zoom"
    "postman"
  ];

  # --- 2. Packages ---
  home.packages = [
    # A. Universal CLI Tools (Akan diinstall di mana saja)
    pkgs.htop
    pkgs.eza
    pkgs.bat
    pkgs.ripgrep
    pkgs.fd
    pkgs.jq
    pkgs.lazygit
    pkgs.tldr
    pkgs.zip
    pkgs.unzip

    # --- Script Backup SSH (Encrypted) ---
    (pkgs.writeShellScriptBin "backup-ssh" (builtins.readFile ./scripts/backup-ssh.sh))

    # --- Script Restore SSH (Decrypted) ---
    (pkgs.writeShellScriptBin "restore-ssh" (builtins.readFile ./scripts/restore-ssh.sh))
  ] 
  ++ (if shouldInstallGUI then [
    # B. GUI Apps (Mac & Native Linux)
    pkgs.zoom-us
    pkgs.postman
    pkgs.google-chrome
    pkgs.brave
    pkgs.vscode
    pkgs.code-cursor
    pkgs.antigravity
  ] else [
    # C. WSL Specific (CLI only)
  ])
  ++ (if isDarwin then [
    pkgs.iterm2 # Cuma ada di Mac
  ] else []);

  programs.git = {
    enable = true;
    # settings replaces userName, userEmail, aliases, and extraConfig
    settings = {
      user = {
        name = "M Danil Rafiqi";
        email = "danil.rafiqi@gmail.com";
      };
      alias = {
        s = "status";
        co = "checkout";
        br = "branch";
        cm = "commit";
        lg = "log --graph --oneline --all";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.ssh = {
    enable = true;
    # Disable deprecated default config merging
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
      };
    };
  };

  # --- 4. Konfigurasi ZSH ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      # Plugin 'macos' hanya diaktifkan jika di Mac
      plugins = [ "git" "docker" "npm" ] ++ (if isDarwin then [ "macos" ] else []);
      theme = "robbyrussell"; 
    };

    initContent = ''
      # Nix initialization
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';

    shellAliases = {
      ll = "ls -l";
      ls = "eza --icons";
      cat = "bat";
      hm = "home-manager switch";
    };
  };

  programs.home-manager.enable = true;
}