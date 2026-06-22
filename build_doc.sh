#!/usr/bin/env bash
#"C:\Program Files\Git\bin\bash.exe" ./build_doc.sh
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PYTHON_BIN=$(command -v python)

"$PYTHON_BIN" -m pip install -r requirements.txt

echo "Using Python: $("$PYTHON_BIN" -c 'import sys; print(sys.executable)')"

rm -rf docs/_build
mkdir -p docs/_build/html

build_competition() {
    local comp_name=$1
    local comp_dir=$2
    
    echo "Building $comp_name..."
    # sphinx-build -b html -D language=zh_CN docs/source docs/_build/html/cn
    # sphinx-build -b html -D language=en docs/source docs/_build/html/en
    # Chinese version
    "$PYTHON_BIN" -m sphinx -b html \
        -D language=zh_CN \
        docs/source/${comp_dir} docs/_build/html/${comp_dir}/cn
        
    # English version  
    "$PYTHON_BIN" -m sphinx -b html \
        -D language=en \
        docs/source/${comp_dir} docs/_build/html/${comp_dir}/en
        
    cp docs/source/${comp_dir}/_static/index.html docs/_build/html
    
    touch docs/_build/html/.nojekyll
}

build_competition "Tianchi" "tianchi"
build_competition "ICRA" "icra"
