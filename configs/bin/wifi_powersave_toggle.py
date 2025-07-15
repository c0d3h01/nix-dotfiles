#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess
import sys


def is_root():
    return os.geteuid() == 0


def run_cmd(cmd):
    try:
        out = subprocess.check_output(cmd, stderr=subprocess.STDOUT, text=True)
        return out.strip(), 0
    except subprocess.CalledProcessError as e:
        return e.output.strip(), e.returncode


def get_wifi_interfaces():
    out, _ = run_cmd(["iw", "dev"])
    interfaces = []
    for line in out.splitlines():
        if line.strip().startswith("Interface"):
            interfaces.append(line.strip().split()[-1])
    return interfaces


def set_power_save_iw(interface, enable):
    state = "on" if enable else "off"
    print(f"Setting power save '{state}' on '{interface}' using 'iw'...")
    out, code = run_cmd(["iw", "dev", interface, "set", "power_save", state])
    if code == 0:
        print(f"  [OK] Power saving set to '{state}' for {interface} with 'iw'.")
    else:
        print(f"  [WARN] Could not set power save for {interface} with 'iw': {out}")


def set_power_save_nmcli(interface, enable):
    print(
        f"Setting power save {'on' if enable else 'off'} on '{interface}' using NetworkManager (nmcli)..."
    )
    value = "3" if enable else "2"
    out, code = run_cmd(
        ["nmcli", "connection", "modify", interface, "802-11-wireless.powersave", value]
    )
    if code == 0:
        print(
            f"  [OK] Power saving set to {'on' if enable else 'off'} for {interface} with NetworkManager."
        )
    else:
        print(f"  [WARN] Could not set power save with NetworkManager: {out}")


def set_persistent_config(enable):
    nm_conf_path = "/etc/NetworkManager/conf.d/wifi-powersave.conf"
    if shutil.which("NetworkManager"):
        try:
            with open(nm_conf_path, "w") as f:
                value = "3" if enable else "2"
                f.write(f"[connection]\nwifi.powersave = {value}\n")
            print(
                f"  [OK] Wrote NetworkManager config at {nm_conf_path} (value: {value})."
            )
        except Exception as e:
            print(f"  [FAIL] Could not write {nm_conf_path}: {e}")


def set_udev_rule(interfaces, enable):
    udev_path = "/etc/udev/rules.d/70-wifi-powersave.rules"
    try:
        with open(udev_path, "w") as f:
            for interface in interfaces:
                state = "on" if enable else "off"
                rule = f'ACTION=="add", SUBSYSTEM=="net", KERNEL=="{interface}", RUN+="/usr/sbin/iw dev {interface} set power_save {state}"'
                f.write(rule + "\n")
        print(f"  [OK] Wrote udev rules at {udev_path}.")
    except Exception as e:
        print(f"  [FAIL] Could not write {udev_path}: {e}")


def print_final_instructions(interfaces):
    print("\n=== ACTION COMPLETE ===")
    print("You may need to:")
    print("  - Restart NetworkManager: sudo systemctl restart NetworkManager")
    print("  - Or reboot for persistent changes.")
    print("  - Verify status with: iw dev <iface> get power_save")
    print(f"Example: iw dev {interfaces[0]} get power_save" if interfaces else "")


def main():
    parser = argparse.ArgumentParser(
        description="Enable or disable Wi-Fi power saving for all detected wireless interfaces."
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--disable",
        action="store_true",
        help="Disable Wi-Fi power saving (recommended for stability).",
    )
    group.add_argument(
        "--enable",
        action="store_true",
        help="Enable Wi-Fi power saving (recommended for laptops on battery).",
    )
    args = parser.parse_args()

    if not is_root():
        print("ERROR: You must run this script as root (sudo).")
        sys.exit(1)
    if not shutil.which("iw"):
        print(
            "ERROR: 'iw' utility not found. Please install it (e.g., sudo apt install iw)."
        )
        sys.exit(1)

    interfaces = get_wifi_interfaces()
    if not interfaces:
        print("No Wi-Fi interfaces detected. Exiting.")
        sys.exit(0)

    print(f"Detected Wi-Fi interfaces: {', '.join(interfaces)}\n")
    for iface in interfaces:
        set_power_save_iw(iface, enable=args.enable)
        if shutil.which("nmcli"):
            set_power_save_nmcli(iface, enable=args.enable)

    set_persistent_config(enable=args.enable)
    set_udev_rule(interfaces, enable=args.enable)
    print_final_instructions(interfaces)


if __name__ == "__main__":
    main()
