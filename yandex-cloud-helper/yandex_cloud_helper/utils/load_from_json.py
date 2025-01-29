import json
import sys
from pathlib import Path
from typing import Any


def load_json_from_file(filepath: Path) -> Any | None:
    try:
        with open(filepath, encoding="utf-8") as f:
            data = json.load(f)
            return data
    except FileNotFoundError:
        print(f"Error: File not found: {filepath}", file=sys.stderr)
        return None
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}", file=sys.stderr)
        return None
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        return None
