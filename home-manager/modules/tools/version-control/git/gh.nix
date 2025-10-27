{
  pkgs,
  ...
}:
{
  programs.gh = {
    enable = true;

    gitCredentialHelper.enable = true;

    # Extensions
    extensions = with pkgs; [
      gh-copilot
      gh-eco
    ];

    # gh config settings.yaml equivalent
    settings = {
      # Enforce SSH for git operations (pull/clone)
      git_protocol = "ssh";

      # Use absolute path to avoid PATH ambiguity in non-login shells
      editor = "${pkgs.neovim}/bin/nvim";

      # Unix socket domain proxy
      # http_unix_socket = "";

      # Keep prompts interactive by default
      prompt = "enabled";
      prefer_editor_prompt = "enabled";
    };
  };
}


