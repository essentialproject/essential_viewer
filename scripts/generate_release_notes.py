#!/usr/bin/env python3
"""
Generate release notes from git commits (git-flow: release branch vs develop).

Usage:
  python scripts/generate_release_notes.py
  python scripts/generate_release_notes.py --release 6.21.4
  python scripts/generate_release_notes.py --release 6.21.4 --base develop --output-dir docs

Run from the repository root. Output: release-notes-<release>.md

By default compares develop..release/X.Y.Z. If develop has moved ahead (e.g. after
merging a later release), that range may be empty; use --base release/6.21.3 to
get commits in this release since the previous one.
"""

import argparse
import re
import subprocess
import sys
from pathlib import Path


def require_python():
    if sys.version_info < (3, 6):
        sys.exit("This script requires Python 3.6 or later.")


def run_git(repo_root: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(repo_root), *args],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout


def get_repo_root() -> Path:
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.exit("Not run from inside a git repository. Run from repo root.")
    return Path(result.stdout.strip())


def branch_exists(repo_root: Path, branch: str) -> bool:
    result = subprocess.run(
        ["git", "-C", str(repo_root), "rev-parse", "--verify", branch],
        capture_output=True,
    )
    return result.returncode == 0


def get_commits(repo_root: Path, base: str, release_branch: str) -> list[str]:
    out = run_git(repo_root, "log", "--no-merges", "--format=%H", f"{base}..{release_branch}")
    return [h.strip() for h in out.splitlines() if h.strip()]


def get_commit_files(repo_root: Path, commit_hash: str) -> list[str]:
    out = run_git(
        repo_root,
        "diff-tree",
        "--no-commit-id",
        "--name-only",
        "-r",
        commit_hash,
    )
    return [f.strip() for f in out.splitlines() if f.strip()]


def get_commit_body(repo_root: Path, commit_hash: str) -> str:
    return run_git(repo_root, "log", "-1", "--format=%B", commit_hash)


def parse_message(body: str) -> tuple[str, str]:
    """Split commit body into main message and optional TEST part. Returns (main, test)."""
    body = body.strip()
    # Split on "TEST:" or "TEST " (with optional colon later) to separate main from test instructions
    match = re.search(r"\s+TEST\s*:\s*", body, re.IGNORECASE)
    if match:
        main = body[: match.start()].strip()
        test = body[match.end() :].strip()
        # Normalise multiple lines in test part to a single line for the bullet
        test = " ".join(test.split())
        return (main, test)
    # Also handle "TEST " without colon (e.g. "TEST check popover")
    match = re.search(r"\s+TEST\s+", body, re.IGNORECASE)
    if match:
        main = body[: match.start()].strip()
        test = body[match.end() :].strip()
        test = " ".join(test.split())
        return (main, test)
    return (body, "")


def capitalize_first(s: str) -> str:
    """Capitalise the first letter; leave the rest unchanged."""
    if not s:
        return s
    return s[0].upper() + s[1:]


def format_file_list(files: list[str]) -> str:
    """Format as `File1` and `File2` and ..."""
    if not files:
        return "*(no files)*"
    return " and ".join(f"`{f}`" for f in files)


def _indent_continuation(text: str, prefix: str = "\t\t") -> str:
    """Indent all but the first line so markdown doesn't treat them as new list items."""
    if not text or "\n" not in text:
        return text
    first, *rest = text.split("\n")
    return first + "".join(f"\n{prefix}{line}" for line in rest)


def format_commit_block(files: list[str], main_message: str, test_message: str) -> str:
    lines = []
    lines.append(f"* {format_file_list(files)}")
    main = capitalize_first(main_message) if main_message else "(no message)"
    # Indent continuation lines so body lines like "- bullet" don't become top-level bullets
    main = _indent_continuation(main)
    lines.append(f"\t* {main}")
    if test_message:
        test_message = _indent_continuation(test_message, prefix="\t\t\t")
        lines.append(f"\t\t* TEST: {test_message}")
    return "\n".join(lines)


def build_markdown(blocks: list[str], release: str, base: str, release_branch: str) -> str:
    header = f"# Release notes – {release}\n\n"
    header += f"Commits on `{release_branch}` not in `{base}`.\n\n"
    return header + "\n\n".join(blocks)


def main() -> None:
    require_python()
    parser = argparse.ArgumentParser(
        description="Generate release notes from git (develop..release/X.Y.Z)."
    )
    parser.add_argument(
        "--release",
        metavar="VERSION",
        help="Release name (e.g. 6.21.4). If omitted, you will be prompted.",
    )
    parser.add_argument(
        "--base",
        metavar="REF",
        default="develop",
        help="Base ref to compare against (default: develop).",
    )
    parser.add_argument(
        "--output-dir",
        metavar="DIR",
        default=".",
        help="Directory to write the markdown file (default: repo root).",
    )
    args = parser.parse_args()

    repo_root = get_repo_root()
    release = args.release
    if not release:
        release = input("Release name (e.g. 6.21.4): ").strip()
    if not release:
        sys.exit("Release name is required.")

    release_branch = f"release/{release}"
    if not branch_exists(repo_root, release_branch):
        sys.exit(f"Branch '{release_branch}' does not exist.")

    if not branch_exists(repo_root, args.base):
        sys.exit(f"Base ref '{args.base}' does not exist.")

    commits = get_commits(repo_root, args.base, release_branch)
    if not commits:
        print(f"No commits found for {args.base}..{release_branch}. Nothing to write.")
        return

    blocks = []
    for commit_hash in commits:
        files = get_commit_files(repo_root, commit_hash)
        body = get_commit_body(repo_root, commit_hash)
        main_msg, test_msg = parse_message(body)
        blocks.append(format_commit_block(files, main_msg, test_msg))

    out_dir = Path(args.output_dir)
    if not out_dir.is_absolute():
        out_dir = repo_root / out_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / f"release-notes-{release}.md"

    markdown = build_markdown(blocks, release, args.base, release_branch)
    out_file.write_text(markdown, encoding="utf-8")
    print(f"Wrote {out_file}")


if __name__ == "__main__":
    main()
