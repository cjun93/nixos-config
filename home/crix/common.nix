{ pkgs, ... }: {
  home.username = "crix";
  home.homeDirectory = "/home/crix";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "emacs -nw";
    VISUAL = "emacs -nw";
  };

  programs.home-manager.enable = true;
  programs.kitty.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraConfig = ''
      (setq make-backup-files nil)
    '';
    extraPackages = epkgs: with epkgs; [
      nix-mode
    ];
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      settings = {
        "ui.key.menuAccessKeyFocuses" = false;
      };
    };
  };

  programs.chromium.enable = true;
}
