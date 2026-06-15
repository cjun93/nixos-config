# 공통 서비스 설정
{ ... }:
{
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  # 오디오 (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
}
