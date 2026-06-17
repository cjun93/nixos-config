# 공통 기본 (nix 설정, 시스템 패키지, 펌웨어 등)
{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "emacs -nw";

  environment.systemPackages = with pkgs; [
    wget git tree
    zip unzip p7zip gzip bzip2 xz zstd
    unrar usbutils
  ];

  programs.nano.enable = false;
}
