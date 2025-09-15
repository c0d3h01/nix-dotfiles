{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--pretty"
      "--max-columns=200"
      "--max-columns-preview"
      "--hidden"
      "--follow"
    ];
  };
}
