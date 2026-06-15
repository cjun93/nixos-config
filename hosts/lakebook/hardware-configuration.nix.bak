# PLACEHOLDER - lakebook 실기에서 `nixos-generate-config` 결과로 교체할 것
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # TODO: 실제 하드웨어 스캔 결과로 교체
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
