#!/usr/bin/env python3

import argparse
import glob
import os.path
import shutil
import subprocess
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description="Picture file management")
    parser.add_argument(
        "--sd", default="/Volumes/Untitled", help="Path to the SD volume root"
    )
    parser.add_argument(
        "--local",
        default=f"{Path.home()}/Pictures/Sort",
        help="Path to the local folder to store .NEF files",
    )
    parser.add_argument(
        "--nksc",
        default=f"{Path.home()}/Google Drive/Pictures/Photos/Edited/",
        help="Path to the directory where NKSC_PARAM files are stored",
    )

    # Subcommands
    subparsers = parser.add_subparsers(title="subcommands")
    parser_cp = subparsers.add_parser(
        "cp", description="Copy files from the SD card to the local folder"
    )
    parser_cp.set_defaults(func=copy_from_sd)
    parser_open = subparsers.add_parser("open", help="Open local .NEF files")
    parser_open.set_defaults(func=open_files)
    parser_clean = subparsers.add_parser("clean", help="Delete files")
    parser_clean.set_defaults(func=clean_files)
    parser_upload_edits = subparsers.add_parser(
        "upload-edits", help="Copy NKSC_PARAM files to Google Drive"
    )
    parser_upload_edits.set_defaults(func=upload_edits)
    parser_backup = subparsers.add_parser(
        "backup",
        help="Copy files from the local directory back onto the SD card",
    )
    parser_backup.set_defaults(func=backup_files)

    args = parser.parse_args()

    # Some additional derived paths
    args.sd_src = os.path.join(args.sd, "DCIM/100D5100")
    args.sd_backup = os.path.join(args.sd, "Backup")

    # Call the func corresponding to the given subcommand
    args.func(args)


def copy_from_sd(args):
    # Trailing slash tells rsync to copy contents, not the dir itself
    rsync(args.sd_src + "/", args.local)


def open_files(args):
    run_cmd(
        "open",
        *glob.glob(
            os.path.join(args.local, "*.NEF"),
        ),
    )


def clean_files(args):
    to_delete = []
    for path in [args.sd_src, args.sd_backup, args.local]:
        if confirm(f"Delete contents of {path}?"):
            to_delete.append(path)
    if to_delete:
        dirs = ", ".join(to_delete)
        if confirm(f"Delete contents of the following directories? {dirs}"):
            for path in to_delete:
                rm_children(path)
            return
    print("Nothing deleted")


def upload_edits(args):
    rsync(
        "--exclude",
        "*",
        "--include",
        "*.nksc",
        os.path.join(args.local, "NKSC_PARAM"),
        args.nksc,
    )


def backup_files(args):
    rsync(
        # Trailing slash tells rsync to copy contents, not the dir itself
        args.local + "/",
        args.sd_backup,
    )


def run_cmd(*args):
    process = subprocess.Popen(
        args, stderr=subprocess.STDOUT, stdout=subprocess.PIPE
    )
    for line in iter(process.stdout.readline, b""):
        sys.stdout.write(line.decode(sys.stdout.encoding))


def rsync(*args):
    return run_cmd("rsync", "-rv", "--info=progress2", *args)


def confirm(prompt, default=False):
    """
    Prompt the user for a yes/no response
    """
    default_response = "Y/n" if default else "y/N"
    response = input(f"{prompt} ({default_response}) ")

    # Empty response, return default value
    if not response.strip():
        return default
    if response.lower() in ("y", "yes"):
        return True
    return False


def rm_children(directory):
    """
    Delete all children of a directory, without deleting the directory itself
    """
    for child in glob.glob(os.path.join(directory, "*")):
        shutil.rmtree(child)


if __name__ == "__main__":
    main()
