# 공통 사용자 계정 (crix)
{ pkgs, ... }:
{
  users.users."crix" = {
    isNormalUser = true;
    description = "crix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  security.sudo.wheelNeedsPassword = false;
  security.sudo.extraConfig = ''
    Defaults env_editor
  '';
}
