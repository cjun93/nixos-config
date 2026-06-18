# integrity (home pc) - NVIDIA + DE 미확정(잠정 Hyprland)
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
    ../../modules/nvidia.nix
    ./desktop.nix 
  ];

  networking.hostName = "integrity";

  system.stateVersion = "26.05";
}
