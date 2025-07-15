import shutil
import subprocess
import sys


def command_exists(cmd):
    return shutil.which(cmd) is not None


def run(cmd, check=True):
    result = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )
    if check and result.returncode != 0:
        print(f"Error running: {' '.join(cmd)}")
        print(result.stderr.strip())
        sys.exit(result.returncode)
    return result


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Minimal efficient Rust setup tool (Python version)"
    )
    parser.add_argument(
        "--toolchain",
        default="stable",
        help="Rust toolchain to install (default: stable)",
    )
    parser.add_argument(
        "--skip-cargo-tools", action="store_true", help="Skip installing cargo tools"
    )
    args = parser.parse_args()

    if not command_exists("rustup"):
        print("rustup not found.")
        print("Installing rustup (https://rustup.rs/)...")
        confirmation = input("Proceed to install rustup? [y/N]: ").strip().lower()
        if confirmation != "y":
            print("Aborting setup, rustup required.")
            sys.exit(1)
        # Install rustup (Linux/Mac only)
        run(["sh", "-c", "curl https://sh.rustup.rs -sSf | sh -s -- -y"], check=True)
        print("Please restart your shell or source $HOME/.cargo/env before continuing.")
        sys.exit(0)

    print(f"Ensuring Rust toolchain '{args.toolchain}' is installed...")
    run(["rustup", "toolchain", "install", args.toolchain], check=True)

    for comp in ["rustfmt", "clippy"]:
        print(f"Adding component '{comp}'...")
        run(
            ["rustup", "component", "add", comp, "--toolchain", args.toolchain],
            check=False,
        )

    if not args.skip_cargo_tools:
        cargo_tools = [
            "cargo-edit",
            "cargo-audit",
            "cargo-tree",
        ]
        for tool in cargo_tools:
            print(f"Installing '{tool}' (will skip if already installed)...")
            run(["cargo", "install", "--locked", tool], check=False)

    print("Rust setup complete!")


if __name__ == "__main__":
    main()
