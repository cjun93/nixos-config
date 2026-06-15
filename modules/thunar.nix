{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin   # 우클릭 압축/해제 (프런트엔드)
      thunar-volman           # 이동식 미디어 자동 처리
    ];
  };

  # 아카이브 플러그인 백엔드 (GUI 아카이버). 경량 환경에 적합
  environment.systemPackages = with pkgs; [ xarchiver ];

  services.gvfs.enable = true;     # 휴지통, 마운트, 네트워크 위치
  services.tumbler.enable = true;  # 썸네일 생성
}
