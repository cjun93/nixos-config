# 공통 로케일 + 한글 입력기(fcitx5-hangul) + 폰트
{ pkgs, ... }:
{
  time.timeZone = "Asia/Seoul";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ko_KR.UTF-8";
    LC_IDENTIFICATION = "ko_KR.UTF-8";
    LC_MEASUREMENT    = "ko_KR.UTF-8";
    LC_MONETARY       = "ko_KR.UTF-8";
    LC_NAME           = "ko_KR.UTF-8";
    LC_NUMERIC        = "ko_KR.UTF-8";
    LC_PAPER          = "ko_KR.UTF-8";
    LC_TELEPHONE      = "ko_KR.UTF-8";
    LC_TIME           = "ko_KR.UTF-8";
  };

  # X11 키맵
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # 한글 입력기 (시스템 계층, NixOS i18n.inputMethod)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-hangul
        fcitx5-gtk
      ];
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nanum
  ];
}
