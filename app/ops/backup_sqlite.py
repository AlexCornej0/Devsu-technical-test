"""Consistent SQLite backup taken before every migration (Helm pre-install/pre-upgrade hook).

Uses SQLite's online backup API, so the copy is consistent even if the app is writing.
Keeps the newest KEEP backups next to the database.
"""

import os
import sqlite3
import sys
from datetime import UTC, datetime
from pathlib import Path

KEEP = 5


def main() -> int:
    db = Path(os.environ["DATABASE_NAME"])
    if not db.is_absolute():
        db = Path(__file__).resolve().parent.parent / db
    if not db.exists():
        print(f"No database yet at {db}; nothing to back up (first install).")
        return 0

    backups = db.parent / "backups"
    backups.mkdir(exist_ok=True)
    stamp = datetime.now(UTC).strftime("%Y%m%d%H%M%S")
    revision = os.environ.get("REVISION", "manual")
    target = backups / f"db-{stamp}-r{revision}.sqlite3"

    with sqlite3.connect(db) as src, sqlite3.connect(target) as dst:
        src.backup(dst)
    print(f"Backup written: {target}")

    for old in sorted(backups.glob("db-*.sqlite3"))[:-KEEP]:
        old.unlink()
        print(f"Old backup removed: {old}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
