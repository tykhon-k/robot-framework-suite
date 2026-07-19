# robot-framework-suite

[![CI](https://github.com/tykhon-k/robot-framework-suite/actions/workflows/ci.yml/badge.svg)](https://github.com/tykhon-k/robot-framework-suite/actions/workflows/ci.yml)

**Keyword-driven** test automation with Robot Framework + Python, covering both **UI** (SeleniumLibrary, headless Chrome) and **API** (RequestsLibrary) from one readable suite - against a small app bundled in the repo, green in CI.

## What it demonstrates

- **Keyword-driven design** - business-readable keywords live in `resources/*.resource`; the tests read like specifications, not scripts.
- **Two layers, one framework** - `tests/api.robot` (RequestsLibrary) and `tests/ui_login.robot` (SeleniumLibrary) share `resources/common.resource`.
- **Data-driven** - the invalid-login cases use a `[Template]` over a table of inputs.
- **Resilient UI** - `Wait Until ...` keywords and `id:` locators, no sleeps.
- **Zero driver management** - SeleniumLibrary + Selenium Manager resolve the browser driver.

## Layout

```text
app/                     login -> secure-area app under test + a small JSON API (stdlib)
resources/
  common.resource        shared variables (base URL, credentials)
  api_keywords.resource  RequestsLibrary keywords
  ui_keywords.resource   SeleniumLibrary keywords
tests/
  api.robot              health, login (valid/invalid), items (auth)
  ui_login.robot         valid login + data-driven rejected logins
```

## Run it

```bash
pip install -r requirements.txt

# start the app under test
python app/server.py &

# run everything, or a single layer
robot --outputdir results tests/
robot tests/api.robot
robot tests/ui_login.robot
```

Open `results/report.html` for the Robot report.

## CI

GitHub Actions installs the dependencies, starts the app, and runs both suites (`robot tests/`), uploading the HTML report as an artifact.
