#!/usr/bin/env python3

import os
import sys
import shutil
import argparse
from pathlib import Path
import filecmp
import difflib
import datetime


def parse_arguments():
    parser = argparse.ArgumentParser(description="Merge two .config directories")
    parser.add_argument(
        "source", help="Source .config directory (e.g., your GitHub repo)"
    )
    parser.add_argument("target", help="Target .config directory to merge into")
    parser.add_argument(
        "--backup", action="store_true", help="Create backups of modified files"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes",
    )
    parser.add_argument(
        "--force", action="store_true", help="Overwrite files without prompting"
    )
    return parser.parse_args()


def create_backup(file_path):
    """Create a backup of the given file with timestamp."""
    if not os.path.exists(file_path):
        return

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"{file_path}.backup_{timestamp}"
    shutil.copy2(file_path, backup_path)
    print(f"Created backup: {backup_path}")


def show_diff(file1, file2):
    """Show the differences between two files."""
    with open(file1, "r", errors="replace") as f1, open(
        file2, "r", errors="replace"
    ) as f2:
        try:
            file1_lines = f1.readlines()
            file2_lines = f2.readlines()
            diff = difflib.unified_diff(
                file1_lines, file2_lines, fromfile=str(file1), tofile=str(file2)
            )
            return "".join(diff)
        except UnicodeDecodeError:
            return "Binary files differ"


def merge_directories(source_dir, target_dir, backup=False, dry_run=False, force=False):
    """Merge source_dir into target_dir."""
    source_dir = Path(source_dir).expanduser().resolve()
    target_dir = Path(target_dir).expanduser().resolve()

    if not source_dir.exists():
        sys.exit(f"Error: Source directory {source_dir} does not exist")

    if not target_dir.exists():
        if dry_run:
            print(f"Would create target directory: {target_dir}")
        else:
            print(f"Creating target directory: {target_dir}")
            target_dir.mkdir(parents=True, exist_ok=True)

    # Get all files from source, including those in subdirectories
    for source_path in source_dir.glob("**/*"):
        # Skip directories themselves
        if source_path.is_dir():
            continue

        # Calculate the relative path and the corresponding target path
        rel_path = source_path.relative_to(source_dir)
        target_path = target_dir / rel_path

        # Ensure the parent directory exists in the target
        if not target_path.parent.exists():
            if dry_run:
                print(f"Would create directory: {target_path.parent}")
            else:
                print(f"Creating directory: {target_path.parent}")
                target_path.parent.mkdir(parents=True, exist_ok=True)

        # Check if the target file already exists
        if target_path.exists():
            # If the files are identical, skip
            if filecmp.cmp(source_path, target_path, shallow=False):
                print(f"Skipping identical file: {rel_path}")
                continue

            # If files are different, show diff and prompt for action
            diff_output = show_diff(target_path, source_path)
            print(f"\nDifferences for {rel_path}:")
            print(diff_output)

            if not force:
                if not dry_run:
                    choice = input(
                        f"Overwrite {target_path}? [y/N/d] (y=yes, N=no, d=show detailed diff): "
                    ).lower()
                    if choice == "d":
                        print(show_diff(target_path, source_path))
                        choice = input(f"Overwrite {target_path}? [y/N]: ").lower()

                    if choice != "y":
                        print(f"Skipping: {rel_path}")
                        continue
                else:
                    print(f"Would prompt for overwriting: {rel_path}")
                    continue

            if backup and not dry_run:
                create_backup(target_path)

            if dry_run:
                print(f"Would overwrite: {rel_path}")
            else:
                print(f"Overwriting: {rel_path}")
                shutil.copy2(source_path, target_path)
        else:
            # Target file doesn't exist, just copy it
            if dry_run:
                print(f"Would copy new file: {rel_path}")
            else:
                print(f"Copying new file: {rel_path}")
                shutil.copy2(source_path, target_path)


def main():
    args = parse_arguments()

    print(f"Source directory: {args.source}")
    print(f"Target directory: {args.target}")
    print(f"Backup mode: {'enabled' if args.backup else 'disabled'}")
    print(f"Dry run mode: {'enabled' if args.dry_run else 'disabled'}")
    print(f"Force mode: {'enabled' if args.force else 'disabled'}")

    if args.dry_run:
        print("\n=== DRY RUN MODE: No changes will be made ===\n")

    try:
        merge_directories(
            args.source,
            args.target,
            backup=args.backup,
            dry_run=args.dry_run,
            force=args.force,
        )
        print("\nMerge completed successfully!")
    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"\nError during merge: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
