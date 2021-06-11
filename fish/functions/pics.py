#!/usr/bin/env python3

import argparse
import glob
import os.path
import subprocess


def main():
    parser = argparse.ArgumentParser(description="Picture file management")
    parser.add_argument(
        "--sd", default="/Volumes/Untitled", help="Path to the SD volume root"
    )
    parser.add_argument(
        "--local",
        default="~/Pictures/Sort",
        help="Path to the local folder to store .NEF files",
    )
    parser.add_argument(
        "--nksc",
        default="~/Google Drive/Pictures/Photos/Edited",
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
    parser_clean = subparsers.add_parser(
        "upload-edits", help="Copy NKSC_PARAM files to Google Drive"
    )
    parser_clean.set_defaults(func=upload_edits)
    parser_clean = subparsers.add_parser(
        "backup",
        help="Copy files on the SD card to a different directory",
    )
    parser_clean.set_defaults(func=backup_files)

    args = parser.parse_args()

    # Some additional derived paths
    args.sd_src = os.path.join(args.sd, "DCIM/100D5100")
    args.sd_backup = os.path.join(args.sd, "Backup")

    # Call the func corresponding to the given subcommand
    args.func(args)


def copy_from_sd(args):
    subprocess.check_output(
        # Trailing slash tells rsync to copy contents, not the dir itself
        rsync(args.sd_src + "/", args.local)
    )


def open_files(args):
    subprocess.check_output(
        [
            "open",
            *glob.glob(
                os.path.join(args.local, "*.NEF"),
            ),
        ]
    )


def clean_files(args):
    pass


def upload_edits(args):
    subprocess.check_output(
        rsync(
            os.path.join(args.local, "NKSC_PARAM"),
            args.nksc,
        )
    )


def backup_files(args):
    subprocess.check_output(
        rsync(
            os.path.join(args.local, "NKSC_PARAM"),
            args.nksc,
        )
    )


def rsync(*args):
    return ["rsync", "-rv", "--info=progress2", *args]


if __name__ == "__main__":
    main()
