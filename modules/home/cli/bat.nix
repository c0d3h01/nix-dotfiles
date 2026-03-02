# Purpose: bat — cat clone with syntax highlighting
{
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "Nord";
    };
  };
}
