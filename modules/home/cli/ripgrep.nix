# Purpose: ripgrep — recursive grep with smart defaults
{
  programs.ripgrep = {
    enable = true;
    arguments = ["--hidden" "--follow" "--glob" "!.git/*"];
  };
}
