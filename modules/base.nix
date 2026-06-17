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
    libreoffice
  ];

  programs.nano.enable = false;
}
