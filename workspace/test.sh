#!/bin/sh
set -x
cd example-python-pyb-lib-1

pyb clean
pyb install_dependencies
pyb

echo " "
echo "Validation..."
[ ! -f target/dist/example-python-pyb-lib-1-1.0.dev0/dist/example_python_pyb_lib_1-1.0.dev0-py3-none-any.whl ] && exit 1
[ ! -f target/dist/example-python-pyb-lib-1-1.0.dev0/dist/example-python-pyb-lib-1-1.0.dev0.tar.gz ] && exit 1
[ ! -f target/reports/example-python-pyb-lib-1_coverage ] && exit 1
[ ! -f target/reports/unittest ] && exit 1

echo "Validation Done"
