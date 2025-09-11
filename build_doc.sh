#!/usr/bin/env bash
set -euo pipefail

python --version || true

python -m pip install -U pip
python -m pip install -r requirements.txt

rm -rf docs/build
mkdir -p docs/build/html
sphinx-build -b html -D language=zh_CN docs/source docs/build/html

touch docs/build/html/.nojekyll

