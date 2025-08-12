{
  userConfig,
  lib,
  ...
}:

let
  inherit (userConfig.machineConfig) gpuType;

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
  config = lib.mkIf userConfig.devStack.ollama {
    services.ollama = {
      enable = true;

      # GPU acceleration
      inherit (currentGpuConfig) acceleration;

      # Network configuration
      openFirewall = true;

      # Environment variables
      inherit environmentVariables;

      # Load models pre-defined
      loadModels = [
        "qwen2.5-coder:1.5b" # size:986MB, context:32K, text-inputes
      ];
    };
  };
}
