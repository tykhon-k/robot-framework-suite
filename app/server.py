"""Local app under test: static UI + a small JSON API, stdlib only.

Serves app/web (login -> secure area) and /api/* (health, login, items) used
by the API suite. Started as a CI step on a fixed port (default 8000).
"""

import json
from functools import partial
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path

WEB_DIR = str(Path(__file__).parent / "web")
PORT = 8000

TOKEN = "token-abc"
CREDS = {"username": "admin", "password": "admin123"}
ITEMS = [
    {"id": 1, "name": "Nightly regression", "status": "passing"},
    {"id": 2, "name": "API contract suite", "status": "passing"},
    {"id": 3, "name": "Accessibility scan", "status": "passing"},
]


class Handler(SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def _json(self, status, payload):
        body = json.dumps(payload).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _read_json(self):
        length = int(self.headers.get("Content-Length", 0))
        raw = self.rfile.read(length) if length else b"{}"
        try:
            return json.loads(raw or b"{}")
        except json.JSONDecodeError:
            return None

    def do_GET(self):
        if self.path == "/api/health":
            return self._json(200, {"status": "ok"})
        if self.path == "/api/items":
            if self.headers.get("Authorization") != f"Bearer {TOKEN}":
                return self._json(401, {"error": "unauthorized"})
            return self._json(200, ITEMS)
        return super().do_GET()

    def do_POST(self):
        if self.path == "/api/login":
            body = self._read_json()
            if body and body.get("username") == CREDS["username"] and body.get("password") == CREDS["password"]:
                return self._json(200, {"token": TOKEN})
            return self._json(401, {"error": "invalid credentials"})
        return self._json(404, {"error": "not found"})


if __name__ == "__main__":
    handler = partial(Handler, directory=WEB_DIR)
    print(f"app under test on http://localhost:{PORT}")
    HTTPServer(("127.0.0.1", PORT), handler).serve_forever()
