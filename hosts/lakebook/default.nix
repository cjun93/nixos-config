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
    ./desktop.nix   
  ];

  environment.systemPackages = with pkgs; [
    xpad
  ];
  
  networking.hostName = "lakebook";

  system.stateVersion = "26.05";
}
