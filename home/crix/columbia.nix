# columbia home-manager: 공통 + KDE
{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    pavucontrol
  ];
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      mkhl.direnv];
  };
  programs.bash.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
