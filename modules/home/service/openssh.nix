{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      compression = true;
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      addKeysToAgent = "yes";
    };
  };
}
