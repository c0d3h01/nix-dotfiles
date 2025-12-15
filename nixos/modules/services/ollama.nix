{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    acceleration = "rocm";

    environmentVariables = {
      # GPU GCN 5.0 (Vega)
      HSA_OVERRIDE_GFX_VERSION = "9.0.0";

      # Performance tuning
      OLLAMA_GPU_OVERHEAD = "0";
      HIP_VISIBLE_DEVICES = "0";

      # Conservative parallel
      OLLAMA_NUM_PARALLEL = "1";

      # Limit models in memory due to low RAM
      OLLAMA_MAX_LOADED_MODELS = "1";

      # integrated GPU with shared RAM
      OLLAMA_MAX_VRAM = "2048"; # Reserve 2GB max for GPU
    };

    # Auto-load small models suitable for your hardware
    # loadModels = [
    # "qwen2.5-coder:1.5b"
    # "llama3.2:1b"
    # ];
  };
}
