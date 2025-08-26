#!/usr/bin/env python3
import re
import sys


def remove_print_statements(file_path):
    with open(file_path, 'r') as f:
        content = f.read()

    # Pattern to match print statements with their arguments
    # This handles single line and multiline print statements
    pattern = r'print\s*\([^;]*?\);?'

    # Remove all print statements
    content_cleaned = re.sub(pattern, '', content, flags=re.DOTALL)

    # Clean up empty lines left behind
    content_cleaned = re.sub(r'\n\s*\n\s*\n', '\n\n', content_cleaned)

    with open(file_path, 'w') as f:
        f.write(content_cleaned)

    print(f"Removed print statements from {file_path}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 remove_prints.py <file_path>")
        sys.exit(1)

    remove_print_statements(sys.argv[1])
