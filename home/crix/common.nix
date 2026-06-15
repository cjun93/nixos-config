# 공통 home-manager (모든 호스트 공유): 셸/에디터/브라우저
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
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "chromium-browser.desktop";
      "x-scheme-handler/https" = "chromium-browser.desktop";
      "x-scheme-handler/about" = "chromium-browser.desktop";
      "x-scheme-handler/unknown" = "chromium-browser.desktop";
    };
  };  
}
