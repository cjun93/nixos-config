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
  boot.kernelParams = [ "i915.force_probe=9841" ];

  boot.blacklistedKernelModules = [ "ufshcd_pci" "ufshcd_core" ];

  swapDevices = [{ device = "/swap/swapfile"; }];
  environment.systemPackages = with pkgs; [
    xpad
  ];
  
  networking.hostName = "lakebook";

  system.stateVersion = "26.05";
}
