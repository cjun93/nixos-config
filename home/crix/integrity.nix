# integrity home-manager 골격: 공통만. DE 확정 후 DE 설정 추가
{ ... }: {
  imports = [
    ./common.nix
    # ./waybar.nix   # Hyprland 확정 시 활성화
  ];
  # TODO: integrity DE 설정 (모니터 배치 등)
}
