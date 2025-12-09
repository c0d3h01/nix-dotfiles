{
  userConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge;
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

    intel = {
      acceleration = "vulkan";
      envVars = {
        OLLAMA_GPU_OVERHEAD = "0";
        OLLAMA_NUM_PARALLEL = "2";
      };
    };

    cpu = {
      acceleration = "cpu";
      envVars = {
        OLLAMA_NUM_PARALLEL = "1";
      };
    };
  };

  # Get current GPU config
  currentGpuConfig = gpuConfigs.${gpuType};

  # Ollama environment
  environmentVariables = mkMerge [
    currentGpuConfig.envVars
  ];

in {
  services.ollama = {
    enable = true;

    # GPU acceleration
    package = pkgs.lib.getAttr ollamaPkgName pkgs;

    # Network configuration
    openFirewall = true;

    # Environment variables
    inherit environmentVariables;

    # Load models pre-defined
    loadModels = [
      # "qwen2.5-coder:1.5b" # size:986MB, context:32K, text-inputes
    ];
  };
}
