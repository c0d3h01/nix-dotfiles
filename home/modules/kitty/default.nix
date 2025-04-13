{
  lib,
  ...
}:
{
  programs.kitty = lib.mkForce {
    enable = true;

    # Modern, minimal, soft dark theme configuration
    themeFile = "Catppuccin-Mocha";
    settings = {
      # Font configuration
      font_size = "13.0";
      adjust_line_height = "110%";

      # Window appearance
      window_padding_width = "10";
      hide_window_decorations = "yes";
      background_opacity = "0.9";

      # Terminal behavior
      scrollback_lines = "10000";
      enable_audio_bell = "no";
      confirm_os_window_close = "0";

      # Cursor settings
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      # Mouse behavior
      copy_on_select = "clipboard";
      mouse_hide_wait = "3.0";

      # Performance
      repaint_delay = "10";
      input_delay = "3";
      sync_to_monitor = "yes";

      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_font_style = "bold";
    };

    # Key mappings for common operations
    keybindings = {
      # Window management
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";

      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";

      # Font size
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
