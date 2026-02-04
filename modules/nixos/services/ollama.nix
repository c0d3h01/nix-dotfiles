{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    environmentVariables = {
      # Performance tuning
      OLLAMA_GPU_OVERHEAD = "0";
      HIP_VISIBLE_DEVICES = "0";

      # Conservative parallel
      OLLAMA_NUM_PARALLEL = "1";
    };

    # Auto-load small models suitable for your hardware
    # loadModels = [
    # "qwen2.5-coder:1.5b"
    # "llama3.2:1b"
    # ];
  };
}
