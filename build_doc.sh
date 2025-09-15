#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN=$(command -v python)

"$PYTHON_BIN" -m pip install -U pip
"$PYTHON_BIN" -m pip install -r requirements.txt


rm -rf docs/_build
mkdir -p docs/_build/html
sphinx-build -b html -D language=zh_CN docs/source docs/_build/html

touch docs/_build/html/.nojekyll

