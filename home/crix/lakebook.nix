{ pkgs, lib, ... }: {
  imports = [
    ./common.nix
  ];
  programs.emacs.package = lib.mkForce pkgs.emacs-gtk;
}
