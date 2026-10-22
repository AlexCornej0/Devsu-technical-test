"""Post-deploy smoke test, run by `helm test` inside the cluster.

Checks readiness, then creates, reads and deletes a throwaway user through the API.
Exits 1 on the first unexpected status code so the Helm test (and the pipeline) fails.

"""

import json
import os
import secrets
import sys
import urllib.error
import urllib.request

BASE_URL = os.environ.get("BASE_URL", "http://localhost:8000").rstrip("/")
HOST_HEADER = os.environ.get("SMOKE_HOST_HEADER", "localhost")


def call(method: str, path: str, expected: int, payload: dict | None = None) -> dict | None:
    data = json.dumps(payload).encode() if payload is not None else None
    request = urllib.request.Request(  # noqa: S310 - scheme validated in main()
        f"{BASE_URL}{path}",
        data=data,
        method=method,
        headers={"Host": HOST_HEADER, "Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(request, timeout=10) as response:  # noqa: S310 - scheme validated in main()
            status, body = response.status, response.read()
    except urllib.error.HTTPError as error:
        status, body = error.code, error.read()

    if status != expected:
        print(f"FAIL {method} {path} -> {status} (expected {expected}): {body[:300]!r}")
        sys.exit(1)
    print(f"OK   {method} {path} -> {status}")
    return json.loads(body) if body else None


def main() -> int:
    if not BASE_URL.startswith(("http://", "https://")):
        print(f"BASE_URL must start with http:// or https:// (got {BASE_URL!r})")
        return 2

    call("GET", "/health/ready", 200)

    dni = secrets.token_hex(6)
    created = call("POST", "/api/users/", 201, {"name": "smoke-test", "dni": dni})
    user_id = created["id"]

    fetched = call("GET", f"/api/users/{user_id}/", 200)
    if fetched["dni"] != dni:
        print(f"FAIL dni mismatch: sent {dni}, got {fetched['dni']}")
        return 1

    call("DELETE", f"/api/users/{user_id}/", 204)
    call("GET", f"/api/users/{user_id}/", 404)

    print("Smoke test passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
