# Hyprland

[![Linux](https://img.shields.io/badge/Linux-cad3f5?style=for-the-badge&logo=linux&logoColor=black)](https://github.com/khaneliman/dotfiles/blob/main/dots/linux/)
[![Arch](https://img.shields.io/badge/Arch%20Linux-24273a?logo=arch-linux&logoColor=0F94D2&style=for-the-badge)](https://github.com/khaneliman/dotfiles/blob/main/dots/linux/)

## Install Steps

- Create system links from ~/.local files to their /usr/local paths

  ```bash
  sudo ln -s ~/.local/bin/xdg-desktop-portal.sh /usr/local/bin/
  sudo ln -s ~/.local/bin/hyprland_setup_dual_monitors.sh /usr/local/bin
  sudo ln -s ~/.local/bin/hyprland_cleanup_after_startup.s /usr/local/bin
  sudo ln -s ~/.local/bin/hyprland_handle_monitor_connect.sh /usr/local/bin
  ```

## Arch

```bash
# core
yay -Sy --needed hyprland-nvidia-git waybar-hyprland-git xdg-desktop-portal-hyprland-git swaync-git wlogout rofi-lbonn-wayland-git swayidle swaylock-effects-git hyprpaper-git blueman network-manager-applet polkit-kde-agent gnome-keyring
# theme
yay -Sy --needed kvantum qt5ct qt6ct
# convenience
yay -Sy --needed find-the-command cliphist firefox-developer-edition
# media
yay -Sy --needed thunar spotify playerctl wireplumber swayimg hyprpicker-git wf-recorder grim
```
