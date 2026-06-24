{ pkgs, lib, ... }: {
  imports = [
    ./common.nix
  ];
  programs.emacs.package = lib.mkForce pkgs.emacs-gtk;
  xfconf.settings = {
    xsettings = {
      "Xft/DPI" = 125;
    };
  };
}
