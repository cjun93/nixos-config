# lakebook (laptop) - NVIDIA 없음, DE 잠정 XFCE
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/boot.nix
    ../../modules/services.nix
    ../../modules/i18n.nix
    ../../modules/users.nix
    ../../modules/thunar.nix
    ./desktop.nix   # XFCE 확정 후 작성하여 활성화
  ];

  networking.hostName = "lakebook";

  system.stateVersion = "26.05";
}
