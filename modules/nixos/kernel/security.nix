{
  config,
  lib,
  pkgs,
  ...
}: {
  security = {
    # Prevents /dev/mem, /dev/kmem writes and kernel image tampering.
    protectKernelImage = true;

    # network adapters, VirtualBox, etc.). Set true only on servers/kiosks.
    lockKernelModules = false;

    # Trade-off decision.
    forcePageTableIsolation = true;

    # Required for Flatpak, containers (podman --rootless), bubblewrap sandboxes,
    # and various dev tools. Must stay true.
    allowUserNamespaces = true;

    # Restrict *unprivileged* creation of user namespaces — only root/CAP_SYS_ADMIN
    # can create them. This breaks rootless podman/docker by default; pair with
    # `virtualisation.podman.extraPackages` or grant per-binary via sysctl override.
    unprivilegedUsernsClone = false;

    # SMT (Hyper-Threading equivalent on AMD). Ryzen 3500U has real cores, no SMT.
    # This option is effectively a no-op on your hardware but correct to leave true.
    allowSimultaneousMultithreading = true;

    # Mandatory Access Control
    apparmor = {
      enable = true;
      killUnconfinedConfinables = false;
    };

    # Audit subsystem
    # Low overhead; provides forensic trail for privilege escalations and file access.
    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
      "-a exit,always -F arch=b64 -S execve" # log all exec calls
      "-w /etc/passwd -p wa -k identity" # watch passwd changes
      "-w /etc/shadow -p wa -k identity"
      "-w /etc/sudoers -p wa -k sudoers"
    ];

    # sudo hardening
    sudo = {
      execWheelOnly = true; # Only binaries in PATH, not arbitrary paths
      wheelNeedsPassword = true;
    };

    # RTKit (real-time scheduling for audio)
    rtkit.enable = true;

    # Polkit
    polkit.enable = true;
  };
}
