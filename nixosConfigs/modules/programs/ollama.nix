{
  userConfig,
  lib,
  pkgs,
  ...
}:

let
  inherit (userConfig.machine) gpuType;

  # GPU configuration definitions
  gpuConfigs = {
    nvidia = {
      acceleration = "cuda";
      envVars = {
        OLLAMA_GPU_OVERHEAD = "0";
        OLLAMA_FLASH_ATTENTION = "1";
        CUDA_VISIBLE_DEVICES = "0";
        OLLAMA_NUM_PARALLEL = "4";
      };
    };
    amd = {
      acceleration = "rocm";
      envVars = {
        OLLAMA_GPU_OVERHEAD = "0";
        ROC_ENABLE_PRE_VEGA = "1";
        HIP_VISIBLE_DEVICES = "0";
        OLLAMA_NUM_PARALLEL = "2";
      };
    };
  };

  # Get current GPU config
  currentGpuConfig = gpuConfigs.${gpuType};

  # Common environment variables
  commonEnvVars = {
    OLLAMA_KEEP_ALIVE = "5m";
    OLLAMA_MAX_LOADED_MODELS = "3";
    OLLAMA_ORIGINS = "http://localhost:*,http://127.0.0.1:*";
    OLLAMA_DEBUG = "false";
  };

  # Build final environment variables
  environmentVariables = lib.mkMerge [
    commonEnvVars
    currentGpuConfig.envVars
  ];

in
{
  services.ollama = lib.mkIf (userConfig.dev ? ollama && userConfig.dev.ollama) {
    enable = true;

    # GPU acceleration
    inherit (currentGpuConfig) acceleration;

    # Network configuration
    host = "127.0.0.1";
    port = 11434;
    openFirewall = true;

    # Storage configuration
    home = "/var/lib/ollama";
    models = "/var/lib/ollama/models";

    # Environment variables
    inherit environmentVariables;

    # Preload models (commented out by default)
    loadModels = [
      # "llama3.2:3b"
      # "codellama:7b"
    ];
  };

  # Service optimization
  systemd.services.ollama.serviceConfig =
    lib.mkIf (userConfig.dev ? ollama && userConfig.dev.ollama)
      {
        # Resource limits
        CPUQuota = "400%";
        # MemoryMax = "16G";

        # I/O optimization
        IOSchedulingClass = 1;
        IOSchedulingPriority = 4;

        # Process priority
        Nice = -5;
      };
}
