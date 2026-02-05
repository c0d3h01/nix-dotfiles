{
  programs.gemini-cli = {
    enable = true;
    # defaultModel = "gemini-3-pro";
    # context = {
    #   GEMINI = '''';
    #   AGENTS = ./agents.md;
    # };
    settings = {
      "theme" = "Default";
      "vimMode" = true;
      "preferredEditor" = "nvim";
      "autoAccept" = true;
    };
  };
}
