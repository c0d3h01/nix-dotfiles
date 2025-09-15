{ pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  # Fastfetch configuration
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",

      "logo": {
        "type": "none"
      },

      "display": {
        "separator": " -->  "
      },

      "modules": [
        "title",
        "break",
        {
          "type": "os",
          "key": " DISTRO",
          "keyColor": "red"
        },
        {
          "type": "kernel",
          "key": " ├  ",
          "keyColor": "red"
        },
        {
          "type": "packages",
          "key": " ├ 󰏖 ",
          "keyColor": "red"
        },
        {
          "type": "shell",
          "key": " └  ",
          "keyColor": "red"
        },
        "break",
        {
          "type": "wm",
          "key": " DE/WM",
          "keyColor": "green"
        },
        {
          "type": "wmtheme",
          "key": " ├ 󰉼 ",
          "keyColor": "green"
        },
        {
          "type": "icons",
          "key": " ├ 󰀻 ",
          "keyColor": "green"
        },
        {
          "type": "cursor",
          "key": " ├  ",
          "keyColor": "green"
        },
        {
          "type": "terminal",
          "key": " ├  ",
          "keyColor": "green"
        },
        {
          "type": "terminalfont",
          "key": " └  ",
          "keyColor": "green"
        },
        "break",
        {
          "type": "host",
          "format": "{2}",
          "key": "󰌢 SYSTEM",
          "keyColor": "yellow"
        },
        {
          "type": "cpu",
          "format": "{1} ({3}) @ {7} GHz",
          "key": " ├  ",
          "keyColor": "yellow"
        },
        {
          "type": "gpu",
          "format": "{2}",
          "key": " ├ 󰢮 ",
          "keyColor": "yellow"
        },
        {
          "type": "memory",
          "key": " ├  ",
          "keyColor": "yellow"
        },
        {
          "type": "swap",
          "key": " ├ 󰓡 ",
          "keyColor": "yellow"
        },
        {
          "type": "disk",
          "key": " ├ 󰋊 ",
          "keyColor": "yellow"
        },
        {
          "type": "display",
          "key": " └  ",
          "compactType": "original-with-refresh-rate",
          "keyColor": "yellow"
        },
        "break",
        {
          "type": "battery",
          "key": " BATTERY",
          "keyColor": "blue"
        }
      ]
    }
  '';
}
