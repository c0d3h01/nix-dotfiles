#!/usr/bin/env python3

import argparse
import json
import os
import subprocess
import sys
from typing import List, Optional, Tuple


class nixEnvInstaller:
    def __init__(
        self,
        config_path: str,
        operation: str,
        channel: Optional[str] = None,
        verbose: bool = False,
    ):
        self.config_path = config_path
        self.operation = operation
        self.verbose = verbose
        self.processed = set()
        self.failed = []

        self.is_nixos = self._is_nixos_from_os_release()
        self.channel = channel or ("nixos" if self.is_nixos else "nixpkgs")

        if not self._command_exists("nix-env"):
            print("nix-env not found in PATH. Please install Nix first.")
            sys.exit(1)

        print(f"Using channel: {self.channel}")

    def _is_nixos_from_os_release(self) -> bool:
        try:
            if os.path.exists("/etc/os-release"):
                with open("/etc/os-release") as f:
                    return "ID=nixos" in f.read()
        except Exception:
            pass
        return False

    def _command_exists(self, cmd: str) -> bool:
        return (
            subprocess.run(
                ["which", cmd], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
            ).returncode
            == 0
        )

    def _read_package_list(self) -> List[str]:
        try:
            with open(self.config_path, "r") as f:
                data = json.load(f)

            if isinstance(data, list):
                return data
            elif isinstance(data, dict) and "packages" in data:
                return data["packages"]
            else:
                print(f"Invalid configuration format in {self.config_path}")
                sys.exit(1)
        except (json.JSONDecodeError, FileNotFoundError) as e:
            print(f"Error reading configuration: {e}")
            sys.exit(1)

    def _process_package(self, package: str) -> Tuple[str, bool, Optional[str]]:
        if self.operation == "install":
            cmd = ["nix-env", "-iA", f"{self.channel}.{package}"]
            timeout = 600
        else:
            cmd = ["nix-env", "-e", package]
            timeout = 300

        try:
            process = subprocess.run(
                cmd, capture_output=True, text=True, timeout=timeout
            )

            success = process.returncode == 0
            error_msg = None if success else process.stderr.strip()

            if success and self.verbose and process.stdout.strip():
                print(f"Output for {package}:\n{process.stdout}")

            return (package, success, error_msg)

        except subprocess.TimeoutExpired:
            return (
                package,
                False,
                f"Operation timed out after {timeout // 60} minutes",
            )
        except Exception as e:
            return (package, False, f"Error: {str(e)}")

    def run(self) -> bool:
        packages = self._read_package_list()

        if not packages:
            print("No packages found in configuration")
            return True

        total = len(packages)
        op_word = "installing" if self.operation == "install" else "uninstalling"
        print(f"Found {total} packages for {op_word}")

        return self._sequential_process(packages)

    def _sequential_process(self, packages: List[str]) -> bool:
        total = len(packages)

        for idx, package in enumerate(packages, 1):
            action = "Installing" if self.operation == "install" else "Uninstalling"
            self._show_progress(idx - 1, total, package, f"{action}...")

            package, success, error = self._process_package(package)

            self._show_progress(idx, total, package, "Success" if success else "Failed")

            if success:
                self.processed.add(package)
            else:
                self.failed.append((package, error or "Unknown error"))
                print(f"\nFailed to {self.operation} {package}: {error}")

        return len(self.failed) == 0

    def _show_progress(
        self, current: int, total: int, package: str, status: str
    ) -> None:
        if self.verbose:
            return

        bar_len = 30
        progress = min(1.0, current / total) if total > 0 else 1.0
        filled_len = int(bar_len * progress)

        bar = "■" * filled_len + "□" * (bar_len - filled_len)

        if status == "Success":
            status_fmt = "\033[92mSuccess\033[0m"
        elif status == "Failed":
            status_fmt = "\033[91mFailed\033[0m"
        elif "..." in status:
            status_fmt = f"\033[93m{status}\033[0m"
        else:
            status_fmt = status

        percent = int(progress * 100)
        sys.stdout.write(f"\r[{bar}] {percent:3d}% | {package[:25]:<25} | {status_fmt}")
        sys.stdout.flush()

        if current == total:
            print()

    def summarize(self) -> None:
        total = len(self.processed) + len(self.failed)
        operation_past = "installed" if self.operation == "install" else "uninstalled"

        print(f"\n=== {self.operation.upper()} SUMMARY ({total} packages) ===")

        if self.processed:
            print(f"\n[+] Successfully {operation_past} ({len(self.processed)}):")
            for pkg in sorted(self.processed):
                print(f"  • {pkg}")

        if self.failed:
            print(f"\n[-] Failed to {self.operation} ({len(self.failed)}):")
            for pkg, error in self.failed:
                first_line = error.split("\n")[0] if error else "Unknown error"
                print(f"  • {pkg}: {first_line}")

        print("\n" + "=" * 40)
        if self.failed:
            print("Some packages failed. Run with --verbose for details.")
        else:
            print(f"All packages were {operation_past} successfully!")


def main() -> None:
    parser = argparse.ArgumentParser()

    parser.add_argument("operation", choices=["install", "uninstall"])
    parser.add_argument("-c", "--config", default="apps.json")
    parser.add_argument("--channel")
    parser.add_argument("-v", "--verbose", action="store_true")

    args = parser.parse_args()

    try:
        manager = nixEnvInstaller(
            config_path=args.config,
            operation=args.operation,
            channel=args.channel,
            verbose=args.verbose,
        )

        success = manager.run()
        manager.summarize()
        sys.exit(0 if success else 1)

    except KeyboardInterrupt:
        print("\nOperation interrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"Error: {e}")
        if args.verbose:
            import traceback

            traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
