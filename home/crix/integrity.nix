{ inputs, ... }: {
  imports = [
    ./common.nix
    inputs.plasma-manager.homeModules.plasma-manager
  ];
  
  programs.plasma = {
    enable = true;

    configFile."kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
    configFile."kwinrc"."Wayland"."InputMethod" =
      "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
  };  
}
