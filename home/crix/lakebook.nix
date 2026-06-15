# lakebook home-manager 골격: 공통만. XFCE 확정 후 설정 추가
{ pkgs, lib, ... }: {
  imports = [
    ./common.nix
  ];
  programs.emacs.package = lib.mkForce pkgs.emacs-gtk;
}
