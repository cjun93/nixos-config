{ pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono   # 아이콘용
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 28;
      output = [ "DP-1" "DP-2" ];
      modules-left  = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "tray" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "1"; "2" = "2"; "3" = "3"; "4" = "4"; "5" = "5";
          "6" = "6"; "7" = "7"; "8" = "8"; "9" = "9"; "10" = "10";
        };
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 60;
      };

      clock = {
        format = "{:%Y-%m-%d (%a) %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "pavucontrol";
      };

      network = {
        format-wifi = "  {essid} ({signalStrength}%)";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰖪 disconnected";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      tray = { spacing = 8; };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 12px;
        min-height: 0;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.92);
        color: #cdd6f4;
      }
      #workspaces button {
        padding: 0 6px;
        background: transparent;
        color: #cdd6f4;
      }
      #workspaces button.active {
        background: #585b70;
        color: #f5e0dc;
      }
      #clock, #pulseaudio, #network, #battery, #tray, #window {
        padding: 0 10px;
      }
      #battery.warning  { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
    '';
  };
}
