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
      gh-cal
      gh-copilot
      gh-eco
      gh-dash
      gh-notify
    ];

    # gh config settings.yaml equivalent
    settings = {
      version = "1";

      # Enforce SSH for git operations (pull/clone)
      git_protocol = "ssh";

      # Use absolute path to avoid PATH ambiguity in non-login shells
      editor = "${pkgs.neovim}/bin/nvim";

      # Unix socket domain proxy
      # http_unix_socket = "";

      # Keep prompts interactive by default
      prompt = "enabled";
      prefer_editor_prompt = "enabled";

      # Pager: bat for readability; can override per-invocation with GH_PAGER
      pager = "${pkgs.bat}/bin/bat";

      browser = "firefox";

      color_labels = "enabled";
      accessible_colors = "enabled";
      accessible_prompter = "enabled";
      spinner = "enabled";

      # Host-specific clarity
      hosts = {
        "github.com" = {
          user = "c0d3h01";
          git_protocol = "ssh";
        };
      };

      aliases = {
        # Existing
        co = "pr checkout";
        pv = "pr view --web";
        rv = "repo view --web";
        myi = "issue list --assignee=@me";
        myp = "pr list --assignee=@me";

        # Improved / descriptive variants
        issue-me = "issue list --assignee=@me --state=open";
        pr-me = "pr list --assignee=@me --state=open";

        # Common workflows
        prw = "pr view --web";
        prc = "pr create --fill"; # fill from commit messages & metadata
        prco = "pr create --fill --web"; # open in browser for fine edits
        prr = "pr ready"; # mark draft -> ready

        # Quick checkout by number: gh prc 123
        prx = "!f(){ gh pr checkout \"$1\"; }; f";

        # Fork sync (assumes upstream remote defined)
        gsync = "!git fetch upstream -v && git checkout main && git merge --ff-only upstream/main && git push origin main";

        # Issue creation
        ic = "issue create --web";

        # Repo view (force web)
        rvw = "repo view --web";

        # Clone + enter directory (simple wrapper)
        cl = "!f(){ gh repo clone \"$1\" && cd \"$(basename \"$1\" .git)\"; }; f";

        # Copilot chat (if gh-copilot installed)
        cchat = "copilot chat";

        # Raw output / script-friendly (disable pager & prompts)
        raw = "!GH_PAGER=cat GH_PROMPT_DISABLED=1 gh";
        nopr = "!GH_PROMPT_DISABLED=1 gh";

        # Open current repo PR list in browser
        prs = "pr list --web";

        # View release page
        rel = "release view --web";
      };
    };
  };
}
