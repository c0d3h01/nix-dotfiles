{
  config,
  userConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = userConfig.machineConfig;
  nixGLConfig = config.nixGL;
  
  # Auto-detect wrapper based on GPU type
  autoDetectWrapper =
    if cfg ? gpuType then
      if cfg.gpuType == "nvidia" then "nvidia"
      else if cfg.gpuType == "intel" then "intel"
      else if cfg.gpuType == "amd" then "mesa"
      else "mesa"
    else
      "mesa";
in
{
  # Define nixGL options for home-manager
  options.nixGL = {
    enable = mkOption {
      type = types.bool;
      default = cfg.glApps;
      description = "Enable nixGL wrapper for OpenGL applications";
    };

    packages = mkOption {
      type = types.package;
      default = pkgs.nixgl.auto.nixGLDefault;
      description = "The nixGL package to use for wrapping";
    };

    defaultWrapper = mkOption {
      type = types.str;
      default = autoDetectWrapper;
      description = "Default wrapper type (mesa, nvidia, intel). Auto-detected from gpuType if not specified.";
    };

    installScripts = mkOption {
      type = types.listOf types.str;
      default = [ "mesa" ];
      description = "Which nixGL scripts to install (reserved for future use)";
    };
  };

  config = mkIf nixGLConfig.enable {
    # Provide the wrap function in config.lib.nixGL
    lib.nixGL.wrap = pkg:
      let
        wrapperName = "nixGL${
          if nixGLConfig.defaultWrapper == "mesa" then
            "Mesa"
          else if nixGLConfig.defaultWrapper == "intel" then
            "Intel"
          else if nixGLConfig.defaultWrapper == "nvidia" then
            "Nvidia"
          else
            "Mesa"
        }";
      in
      pkgs.runCommand "${pkg.name}-nixgl-wrapper"
        {
          buildInputs = [ pkgs.makeWrapper ];
        }
        ''
          mkdir -p $out/bin
          
          # Wrap each binary with nixGL
          for bin in ${pkg}/bin/*; do
            if [ -f "$bin" ] && [ -x "$bin" ]; then
              binname=$(basename "$bin")
              makeWrapper \
                ${nixGLConfig.packages}/bin/${wrapperName} \
                $out/bin/$binname \
                --add-flags "$bin"
            fi
          done
          
          # Link other directories from the original package
          for dir in ${pkg}/*; do
            if [ -d "$dir" ] && [ "$(basename $dir)" != "bin" ]; then
              ln -s "$dir" $out/$(basename $dir)
            fi
          done
        '';

    # Install the nixGL packages
    home.packages = [ nixGLConfig.packages ];
  };
}
