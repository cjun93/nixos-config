# nixos-config

NixOS + home-manager flake 구성. 여러 호스트의 설정을 단일 git 리포로 공유한다.

## 호스트

| 호스트 | 용도 | GPU | DE | 상태 |
|---|---|---|---|---|
| columbia | office pc | NVIDIA | Hyprland | 완성 |
| integrity | home pc | NVIDIA | 미확정 | 골격 |
| lakebook | laptop | 없음 | XFCE(잠정) | 골격 |

사용자는 `crix` 단일.

## 구조

```
.
├── flake.nix              # nixosConfigurations (columbia/integrity/lakebook)
├── flake.lock
├── modules/               # 공통 모듈
│   ├── base.nix           # nix flakes, allowUnfree, 시스템 패키지(압축 도구 등)
│   ├── boot.nix           # 부트로더, 커널
│   ├── services.nix       # networkmanager, openssh, pipewire, polkit
│   ├── i18n.nix           # 로케일 + fcitx5-hangul(시스템 입력기) + 폰트
│   ├── users.nix          # crix 계정
│   ├── nvidia.nix         # NVIDIA (integrity/columbia 만 import)
│   └── thunar.nix         # Thunar 파일 매니저 + 아카이브/볼륨 플러그인
├── hosts/
│   ├── columbia/          # default.nix + desktop.nix + hardware-configuration.nix
│   ├── integrity/         # 골격 (hardware-configuration.nix = placeholder)
│   └── lakebook/          # 골격 (hardware-configuration.nix = placeholder)
└── home/crix/
    ├── common.nix         # 공통 home-manager (kitty, emacs, firefox, chromium)
    ├── columbia.nix       # Hyprland + waybar
    ├── waybar.nix
    ├── integrity.nix      # 골격
    └── lakebook.nix       # 골격
```

단순 패키지는 `modules/base.nix`에서 관리한다. NixOS 옵션·서비스가 얽힌 기능(thunar, nvidia 등)만 별도 모듈로 둔다.

## 새 PC에서 처음 적용하는 방법

대상 머신에 NixOS가 이미 설치되어 있고, 사용자 `crix`가 존재한다고 가정한다.

### 1. 리포 클론

flake는 `/etc/nixos`가 아니라 사용자 홈에 둔다. `/etc/nixos`를 root 소유로 두지 않으므로 일상적인 git 작업에 sudo가 필요 없다.

```bash
nix-shell -p git --run \
  'git clone git@github.com:cjun93/nixos-config.git ~/nixos-config'
cd ~/nixos-config
```

SSH 키가 등록되어 있지 않으면 HTTPS로 클론한다.

```bash
git clone https://github.com/cjun93/nixos-config.git ~/nixos-config
```

### 2. 해당 호스트의 hardware-configuration.nix 교체 (필수)

리포의 `hosts/<host>/hardware-configuration.nix`는 columbia만 실제 파일이고, integrity/lakebook은 placeholder다. 새 머신에서 반드시 실제 하드웨어 스캔 결과로 교체해야 빌드된다.

```bash
# 실제 하드웨어 설정 생성
sudo nixos-generate-config --show-hardware-config \
  > ~/nixos-config/hosts/<host>/hardware-configuration.nix
```

`<host>`는 integrity 또는 lakebook.

### 3. DE / 호스트별 설정 확정

골격 호스트는 데스크톱 환경이 미정 상태다. 다음을 작성·활성화해야 한다.

- `hosts/<host>/default.nix`의 `imports`에서 `./desktop.nix` 주석 해제 (DE 설정 파일을 만든 뒤)
- `hosts/<host>/desktop.nix` 신규 작성 (columbia/desktop.nix 참고)
- `home/crix/<host>.nix`에 DE별 home-manager 설정 추가 (모니터 배치 등)

columbia(Hyprland)를 참고 예시로 사용한다. lakebook은 XFCE이므로 Hyprland 관련 설정 대신 XFCE 설정을 사용한다.

### 4. 빌드 적용

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#<host>
```

`<host>`는 columbia / integrity / lakebook 중 해당 머신.

### 5. (선택) /etc/nixos 정리

flake 경로를 명시하므로 `/etc/nixos`는 더 이상 참조되지 않는다. 관행상 경로를 유지하려면 심볼릭 링크로 대체한다.

```bash
sudo rm -rf /etc/nixos
sudo ln -s /home/crix/nixos-config /etc/nixos
```

## 일상 변경 워크플로

```bash
cd ~/nixos-config
# 파일 편집
git add .
git commit -m "<변경 내용>"
git push
sudo nixos-rebuild switch --flake ~/nixos-config#<host>
```

## 참고 사항

- 입력기(fcitx5-hangul)는 시스템 계층(`modules/i18n.nix`, NixOS `i18n.inputMethod`)에서 관리한다.
- Firefox는 home-manager 공통(`home/crix/common.nix`)에 둔다.
- `modules/base.nix`의 `unrar`는 unfree 패키지다. 불필요하면 제거한다.
- 원격 flake 직접 빌드도 가능하나, hardware-configuration.nix가 리포에 실제 내용으로 들어 있어야 한다.

  ```bash
  sudo nixos-rebuild switch --flake github:cjun93/nixos-config#<host>
  ```
