import os
import subprocess
import sys

FORMATTERS = {
    ".py": [("black", []), ("isort", [])],
    ".r": [("Rscript", ["-e", "styler::style_file('{file}')"])],
    ".go": [("gofmt", ["-w"])],
    ".java": [("google-java-format", ["-i"])],
    ".rs": [("rustfmt", [])],
    ".php": [("php-cs-fixer", ["fix"])],
    ".scala": [("scalafmt", [])],
    ".pl": [("perltidy", ["-b"])],
    ".lua": [("stylua", [])],
    ".dart": [("dart", ["format"])],
    ".xml": [("xmllint", ["--format", "-o", "{file}", "{file}"])],
    ".js": [("prettier", ["--write"])],
    ".ts": [("prettier", ["--write"])],
    ".json": [("prettier", ["--write"])],
    ".md": [("prettier", ["--write"])],
    ".yaml": [("prettier", ["--write"])],
    ".yml": [("prettier", ["--write"])],
    ".sh": [("shfmt", ["-w"])],
    ".c": [("clang-format", ["-i"])],
    ".cpp": [("clang-format", ["-i"])],
    ".h": [("clang-format", ["-i"])],
    ".hpp": [("clang-format", ["-i"])],
}


def find_files(root_dir):
    files = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            ext = os.path.splitext(filename)[1]
            if ext in FORMATTERS:
                files.append(os.path.join(dirpath, filename))
    return files


def format_file(file_path):
    ext = os.path.splitext(file_path)[1]
    results = []
    for formatter, args in FORMATTERS[ext]:
        cmd = [formatter] + args + [file_path]
        try:
            res = subprocess.run(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=True,
            )
            results.append((formatter, "ok", res.stdout.strip()))
        except FileNotFoundError:
            results.append(
                (formatter, "not found", "Formatter not installed or not in PATH.")
            )
        except subprocess.CalledProcessError as e:
            results.append((formatter, "fail", e.stderr.strip()))
    return results


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 auto_formatter.py <target_folder>")
        sys.exit(1)
    target = sys.argv[1]
    if not os.path.isdir(target):
        print(f"Error: {target} is not a directory.")
        sys.exit(1)

    files = find_files(target)
    if not files:
        print("No supported files to format.")
        sys.exit(0)

    print(f"Found {len(files)} files to format.\n")
    summary = {"ok": 0, "fail": 0, "not found": 0}
    for file_path in files:
        print(f"Formatting: {file_path}")
        results = format_file(file_path)
        for formatter, status, message in results:
            print(f"  [{formatter}] {status}")
            if message:
                print(f"    {message}")
            summary[status] = summary.get(status, 0) + 1
        print()

    print("Summary:")
    print(f"  Successfully formatted: {summary['ok']}")
    print(f"  Errors:                {summary['fail']}")
    print(f"  Formatter not found:   {summary['not found']}")


if __name__ == "__main__":
    main()
