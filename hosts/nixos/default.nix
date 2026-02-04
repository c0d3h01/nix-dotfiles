let
  # List all entries in the current directory
  entries = builtins.attrNames (builtins.readDir ./.);

  # Keep only those entries whose type is "directory"
  dirs = builtins.filter (name: (builtins.readDir ./.)."${name}" == "directory") entries;
in {
  # Import each directory under ./ as a Nix file
  imports = builtins.map (name: ././${name}) dirs;
}
