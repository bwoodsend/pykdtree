#!/bin/bash
set -e -x

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" install setuptools bdist_wheel
    (cd /io/ && "${PYBIN}/python" setup.py bdist_wheel)
done


# Install packages and test
#for PYBIN in /opt/python/*/bin/; do
#    "${PYBIN}/pip" install python-manylinux-demo --no-index -f /io/wheelhouse
#    (cd "$HOME"; "${PYBIN}/nosetests" pymanylinuxdemo)
#done

