#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN=$(command -v python)

"$PYTHON_BIN" -m pip install -U pip
"$PYTHON_BIN" -m pip install -r requirements.txt


rm -rf docs/_build
mkdir -p docs/_build/html

build_competition() {
    local comp_name=$1
    local comp_dir=$2
    
    echo "Building $comp_name..."
    # sphinx-build -b html -D language=zh_CN docs/source docs/_build/html/cn
    # sphinx-build -b html -D language=en docs/source docs/_build/html/en
    # Chinese version
    sphinx-build -b html \
        -D language=zh_CN \
        docs/source/${comp_dir} docs/_build/html/${comp_dir}/cn
        
    # English version  
    sphinx-build -b html \
        -D language=en \
        docs/source/${comp_dir} docs/_build/html/${comp_dir}/en
        
    cp docs/source/${comp_dir}/_static/index.html docs/_build/html
    
    touch docs/_build/html/.nojekyll
}

build_competition "Tianchi" "tianchi"
build_competition "ICRA" "icra"
