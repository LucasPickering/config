#!/usr/bin/env python3

import argparse
import subprocess

PASS = "pass"
FAIL = "fail"
NEVER = "never"


def main():
    parser = argparse.ArgumentParser(description="Repeat a command")
    parser.add_argument(
        "-n", type=int, help="Number of iterations to run (default: infinite)"
    )
    parser.add_argument(
        "--stop-on",
        "-s",
        choices=[PASS, FAIL, NEVER],
        default=FAIL,
        help="Whether to stop on the first success, failure, or never (default: never)",
    )
    parser.add_argument("command", nargs="+", help="Command to run")
    args = parser.parse_args()

    i = 0
    while args.n is None or i < args.n:
        i += 1
        print(f"\n===== Run #{i} =====")
        proc = subprocess.run(args.command)
        if (args.stop_on == PASS and proc.returncode == 0) or (
            args.stop_on == FAIL and proc.returncode != 0
        ):
            break


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
