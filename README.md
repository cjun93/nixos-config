# nixos-config

NixOS + home-manager flake 구성. 여러 호스트의 설정을 단일 git 리포로 공유한다.

## 호스트

| 호스트 | 용도 | GPU | DE | 상태 |
|---|---|---|---|---|
| columbia | office pc | NVIDIA | Hyprland (Wayland) | 완성 |
| integrity | home pc | NVIDIA | KDE Plasma 6 (Wayland) | 완성 |
| lakebook | laptop | 없음 | XFCE (X11) | 완성 |

사용자는 `crix` 단일.

## 구조

```
.
├── flake.nix              # nixosConfigurations (columbia/integrity/lakebook)
├── flake.lock
├── modules/               # 공통 모듈
│   ├── base.nix           # nix flakes, allowUnfree, system packages (archive tools, etc.)
│   ├── boot.nix           # bootloader, kernel
│   ├── services.nix       # networkmanager, openssh, pipewire, polkit, XFCE (lightdm)
│   ├── i18n.nix           # locale + fcitx5-hangul (system input method) + fonts
│   ├── users.nix          # crix account
│   ├── nvidia.nix         # NVIDIA (imported by integrity/columbia only)
│   └── thunar.nix         # Thunar file manager + archive/volume plugins
├── hosts/
│   ├── columbia/          # default.nix + desktop.nix + hardware-configuration.nix
│   ├── integrity/         # default.nix + desktop.nix (KDE+NVIDIA) + hardware-configuration.nix
│   └── lakebook/          # default.nix + desktop.nix + hardware-configuration.nix
└── home/crix/
    ├── common.nix         # 공통 home-manager (kitty, emacs, firefox, chromium)
    ├── columbia.nix       # Hyprland + waybar
    ├── waybar.nix
    ├── integrity.nix      # KDE Plasma 6 (plasma-manager: KWin VirtualKeyboard for fcitx5)
    └── lakebook.nix       # XFCE (emacs X11 빌드 override)
```

단순 패키지는 `modules/base.nix`에서 관리한다. NixOS 옵션·서비스가 얽힌 기능(thunar, nvidia 등)만 별도 모듈로 둔다.

## flake inputs

- `nixpkgs`: `github:NixOS/nixpkgs/nixos-26.05`
- `home-manager`: `github:nix-community/home-manager/release-26.05`
- `plasma-manager`: `github:nix-community/plasma-manager` (KDE Plasma 6 설정 선언적 관리, integrity에서만 import)

home-manager는 NixOS 모듈 통합 방식이다 (`home-manager.nixosModules.home-manager`). `nixos-rebuild switch` 한 번으로 시스템과 사용자 환경이 함께 적용된다.

## 호스트별 메모

### integrity (home pc, KDE Plasma 6 Wayland, NVIDIA)

- DE: KDE Plasma 6 + SDDM(Wayland). `hosts/integrity/desktop.nix`에서 활성화.
  ```nix
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  ```
- GPU: NVIDIA. `modules/nvidia.nix` import + `hosts/integrity/desktop.nix`에서 추가 옵션 (`hardware.nvidia.modesetting.enable`, `hardware.nvidia.open` 등) 지정.
  - `hardware.nvidia.open = true`는 Turing(RTX 20xx) 이상에서만 안정. 이전 GPU 사용 시 `false`로 변경.
- 한글 입력기 (fcitx5-hangul): 시스템 계층의 `modules/i18n.nix`가 fcitx5와 hangul addon을 설치하고, integrity 사용자 계층(`home/crix/integrity.nix`)이 **plasma-manager**로 KWin Virtual Keyboard를 활성화하여 KWin이 fcitx5를 invoke하도록 한다. 자세한 내용은 아래 트러블슈팅 섹션 참고.

### columbia (office pc, Hyprland Wayland, NVIDIA)

- DE: Hyprland. `hosts/columbia/desktop.nix` + `home/crix/columbia.nix` + `home/crix/waybar.nix`.
- GPU: NVIDIA.

### lakebook (laptop, XFCE)

- DE: XFCE. `modules/services.nix`에서 `services.xserver`(lightdm + desktopManager.xfce)로 활성화한다. X11 세션이다.
- `hosts/lakebook/desktop.nix`: lakebook 전용 데스크톱 설정.
- `home/crix/lakebook.nix`: 공통(`common.nix`)을 상속하고, emacs 패키지를 X11용으로 override한다.
  - `common.nix`는 `emacs-pgtk`(pure-GTK, Wayland용)를 기본으로 둔다. lakebook은 X11이라 pgtk를 그대로 쓰면 "pure-GTK under X11 is unsupported" 경고와 키보드 입력/크래시 문제가 발생한다.
  - 따라서 lakebook home에서 `programs.emacs.package = lib.mkForce pkgs.emacs-gtk;`로 X11 빌드를 강제한다. (`common.nix`와 우선순위 충돌을 피하기 위해 `mkForce` 필요)
- GPU 없음. `nvidia.nix`는 import하지 않는다.

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

리포의 `hosts/<host>/hardware-configuration.nix`는 기존 머신용이거나 placeholder일 수 있다. 새 머신에서는 반드시 실제 하드웨어 스캔 결과로 교체해야 빌드된다.

```bash
# Generate actual hardware config
sudo nixos-generate-config --show-hardware-config \
  > ~/nixos-config/hosts/<host>/hardware-configuration.nix
```

### 3. DE / 호스트별 설정 확정

새 호스트를 추가하는 경우 다음을 작성·활성화한다.

- `hosts/<host>/desktop.nix` 신규 작성 (columbia/integrity/lakebook의 desktop.nix 참고)
- `hosts/<host>/default.nix`의 `imports`에 `./desktop.nix` 추가
- `home/crix/<host>.nix`에 DE별 home-manager 설정 추가

DE에 따라 참고 예시를 고른다.

| DE | 세션 | 참고 호스트 |
|---|---|---|
| KDE Plasma 6 | Wayland | integrity |
| Hyprland | Wayland | columbia |
| XFCE | X11 | lakebook |

> 주의: 새로 만든 파일은 git에 추적되어야 flake가 인식한다. `desktop.nix` 등을 추가한 뒤 `git add`를 하지 않으면 "Path ... is not tracked by Git" 오류가 난다.

### 4. 빌드 적용

```bash
git add .
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
# Edit files
git add .
git commit -m "<change description>"
git push
sudo nixos-rebuild switch --flake ~/nixos-config#<host>
```

> git push 시 인증 실패(`Authentication failed`)가 나면, HTTPS 리모트는 비밀번호 인증이 폐지되었으므로 SSH 키 등록 또는 Personal Access Token이 필요하다. SSH 전환:
> ```bash
> git remote set-url origin git@github.com:cjun93/nixos-config.git
> ```

## 트러블슈팅

### KDE Plasma 6 Wayland에서 fcitx5 한글 입력 (integrity)

증상: Chromium 등 일부 앱에서만 한글 입력이 동작하지 않음 (konsole, firefox는 정상).

원인: KDE Plasma 6 Wayland에서 fcitx5는 **KWin에 의해 invoke되어야** 클라이언트(특히 Wayland text-input 프로토콜만 사용하는 Chromium/Electron 계열)에게 text-input 인터페이스가 advertise된다. KWin이 fcitx5를 invoke하려면 다음 두 조건이 모두 충족되어야 한다.

```ini
# ~/.config/kwinrc
[Wayland]
VirtualKeyboardEnabled=true
InputMethod=/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop
```

해결: 이 두 값을 plasma-manager로 선언적 관리한다. `home/crix/integrity.nix`에서:

```nix
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
```

적용 후 재로그인 또는 재부팅 필요 (KWin은 시작 시점에 `kwinrc`를 읽음).

검증:

```bash
# fcitx5의 부모 프로세스가 kwin_wayland인지 확인
ps -ef | grep -E '[f]citx5'
ps -p <fcitx5 PPID> -o comm
# Should output: kwin_wayland (or .kwin_wayland-w)
```

참고:

- NixOS 26.05의 i18n.inputMethod 모듈은 `waylandFrontend = true`일 때 `GTK_IM_MODULE`/`QT_IM_MODULE`을 의도적으로 설정하지 않는다. fcitx 공식 위키도 KDE Plasma Wayland에서 이 변수들을 설정하지 말 것을 권고한다 (일부 Wayland 네이티브 앱의 IME 시작 실패 원인이 될 수 있음).
- NixOS 26.05에서 `i18n.inputMethod.fcitx5.plasma6Support` 옵션은 제거됨 (qt6가 fcitx5-configtool의 기본). 추가하면 빌드 에러.

## 참고 사항

- 입력기(fcitx5-hangul)는 시스템 계층(`modules/i18n.nix`, NixOS `i18n.inputMethod`)에서 관리한다. integrity(KDE)는 추가로 home 계층에서 plasma-manager로 KWin Virtual Keyboard를 활성화한다.
- Firefox는 home-manager 공통(`home/crix/common.nix`)에 둔다.
- emacs는 공통이 `emacs-pgtk`(Wayland)다. integrity(KDE Wayland), columbia(Hyprland Wayland)는 그대로 사용 가능. X11 DE(XFCE 등) 호스트는 home에서 `emacs-gtk`로 override한다 (lakebook 참고).
- `modules/base.nix`의 `unrar`는 unfree 패키지다. 불필요하면 제거한다.
- 원격 flake 직접 빌드도 가능하나, hardware-configuration.nix가 리포에 실제 내용으로 들어 있어야 한다.

  ```bash
  sudo nixos-rebuild switch --flake github:cjun93/nixos-config#<host>
  ```
