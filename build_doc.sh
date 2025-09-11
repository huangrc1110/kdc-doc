# Building document command
rm -R docs/build
mkdir docs/build
sphinx-build -b html -D language=zh_CN docs/source docs/build/html
