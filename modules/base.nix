# 공통 기본 (nix 설정, 시스템 패키지, 펌웨어 등)
{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "emacs -nw";

  environment.systemPackages = with pkgs; [
    # 기본 유틸리티
    wget git tree

    # 압축/해제 (CLI). Thunar archive plugin 의 백엔드 포맷 처리도 겸함
    zip unzip p7zip gzip bzip2 xz zstd
    unrar              # rar 해제 (unfree). 불필요 시 제거
  ];

  programs.nano.enable = false;
}
