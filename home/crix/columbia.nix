# columbia home-manager: 공통 + Hyprland + waybar
{ pkgs, ... }: {
  imports = [
    ./common.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    wofi hyprpolkitagent pavucontrol
  ];

  xdg.configFile."hypr/hyprland.conf".text = ''
  exec-once = fcitx5 -d --replace
  exec-once = waybar
  exec-once = systemctl --user start hyprpolkitagent.service

  # 모니터 명시 (자동 인식 결과를 고정)
  monitor=DP-1, 1920x1080@60, 0x0, 1
  monitor=DP-2, 1920x1080@60, 1920x0, 1

  # 워크스페이스 → 모니터 고정 바인딩
  # 1~5: DP-1 (좌), 6~9: DP-2 (우)
  workspace=1, monitor:DP-1, default:true
  workspace=2, monitor:DP-1
  workspace=3, monitor:DP-1
  workspace=4, monitor:DP-1
  workspace=5, monitor:DP-1
  workspace=6, monitor:DP-2, default:true
  workspace=7, monitor:DP-2
  workspace=8, monitor:DP-2
  workspace=9, monitor:DP-2


  $mod = SUPER
  $terminal = kitty
  $editor = emacs

    # 키바인딩
  bind = $mod, Return, exec, $terminal
  bind = $mod, E, exec, $editor
  bind = $mod, M, exit
  bind = $mod SHIFT, Q, killactive
  bind = $mod, V, togglefloating

    # 포커스 이동
  bind = $mod, left,  movefocus, l
  bind = $mod, right, movefocus, r
  bind = $mod, up,    movefocus, u
  bind = $mod, down,  movefocus, d

    # 워크스페이스 전환/이동
  bind = $mod, 1, workspace, 1
  bind = $mod, 2, workspace, 2
  bind = $mod, 3, workspace, 3
  bind = $mod, 4, workspace, 4
  bind = $mod SHIFT, 1, movetoworkspace, 1
  bind = $mod SHIFT, 2, movetoworkspace, 2
  bind = $mod SHIFT, 3, movetoworkspace, 3
  bind = $mod SHIFT, 4, movetoworkspace, 4

    # App
  bind = $mod, D, exec, wofi --show drun


    # 마우스 윈도우 조작
  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow
  '';
}
