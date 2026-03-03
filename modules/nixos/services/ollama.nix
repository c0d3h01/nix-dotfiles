{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    environmentVariables = {
      OLLAMA_GPU_OVERHEAD = "0";
      HIP_VISIBLE_DEVICES = "0";

      OLLAMA_NUM_PARALLEL = "1";
    };
  };
}
