{
  programs.ripgrep = {
    enable = true;
    arguments = ["--hidden" "--follow" "--glob" "!.git/*"];
  };
}
