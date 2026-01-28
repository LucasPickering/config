#!/usr/bin/env python3

import argparse
import subprocess
from enum import Enum


class Condition(Enum):
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
        choices=[condition.value for condition in Condition],
        default=Condition.FAIL,
        help="Whether to stop on the first success, failure, or never (default: never)",
    )
    parser.add_argument("command", nargs="+", help="Command to run")
    args = parser.parse_args()

    i = 0
    passes = 0
    fails = 0
    while args.n is None or i < args.n:
        i += 1
        print(f"\n===== Run #{i} =====")
        proc = subprocess.run(args.command)
        passed = proc.returncode == 0
        if proc.returncode == 0:
            # Command passed
            passes += 1
            if args.stop_on == Condition.PASS:
                break
        else:
            fails += 1
            # Command failed
            if args.stop_on == Condition.FAIL:
                break

    print(f"{i} runs, {passes} passed, {fails} failed")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
