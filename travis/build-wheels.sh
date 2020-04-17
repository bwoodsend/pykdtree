#!/bin/bash
set -e -x

pwd
ls

# Test then Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" install setuptools wheel auditwheel
    (cd /io/ && "${PYBIN}/python" setup.py test)
    (cd /io/ && "${PYBIN}/python" setup.py bdist_wheel)
done

# Wheels aren't considered manylinux unless they have been through 
# auditwheel. (Know idea why.) Auditted wheels go in /io/wheels/.
mkdir -p /io/wheels/
for whl in /io/dist/*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w /io/wheels/
        
done

