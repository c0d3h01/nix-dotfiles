_:
let
  ss = symbol: style: {
    inherit symbol;
    inherit style;
    format = "[$symbol ](${style})";
  };
  ssv = symbol: style: {
    inherit symbol;
    inherit style;
    format = "via [$symbol](${style})";
  };
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      # Explicit order instead of $all
      format = "[╭╴](238)$os$username$directory$git_branch$git_status$python$nodejs$rust$golang$java$lua$nix_shell$docker_context$container\n[╰─󰁔](237)";

      character.disabled = true;

      username = {
        style_user = "white";
        style_root = "black";
        format = "[$user]($style) ";
        show_always = true;
      };

      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = "󰋞 ";
        read_only_style = "197";
        read_only = "  ";
        format = "at [$path]($style)[$read_only]($read_only_style) ";
        substitutions = {
          "󰋞 /Documents" = "󰈙 ";
          "󰋞 /Downloads" = " ";
          "󰋞 /media/music" = " ";
          "󰋞 /media/pictures" = " ";
          "󰋞 /media/videos" = " ";
          "󰋞 /Music" = " ";
          "󰋞 /Pictures" = " ";
          "󰋞 /Videos" = " ";
          "󰋞 /dev" = "󱌢 ";
          "󰋞 /skl" = "󰑴 ";
          "󰋞 /.config" = " ";
        };
      };

      os = {
        style = "bold white";
        format = "[$symbol]($style)";
        symbols = {
          NixOS = "";
          Arch = "";
          Artix = "";
          Fedora = "";
          Debian = "";
          Ubuntu = "";
          Gentoo = "";
          Mint = "";
          Alpine = "";
          Manjaro = "";
          CentOS = "";
          openSUSE = "";
          SUSE = "";
          Raspbian = "";
          Macos = "󰀵";
          Linux = "";
          Windows = "";
        };
      };

      container = ss " 󰏖" "yellow dimmed";
      python = ss "" "yellow";
      nodejs = ss "" "yellow";
      lua = ss "󰢱" "blue";
      rust = ss "" "red";
      java = ss "" "red";
      c = ss "" "blue";
      golang = ss "" "blue";
      docker_context = ss "" "blue";
      nix_shell = ssv "" "blue";

      git_branch = {
        symbol = "󰊢 ";
        format = "on [$symbol$branch]($style) ";
        truncation_length = 4;
        truncation_symbol = "…/";
        style = "bold green";
      };

      git_status = {
        format = "[\\($all_status$ahead_behind\\)]($style) ";
        style = "bold green";
        conflicted = "🏳";
        up_to_date = " ";
        untracked = " ";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        stashed = "󰏗 ";
        modified = " ";
        staged = "[++\\($count\\)](green)";
        renamed = "󰖷 ";
        deleted = " ";
      };

      battery.disabled = true;
    };
  };
}
