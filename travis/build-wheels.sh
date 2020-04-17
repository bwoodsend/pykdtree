#!/bin/bash
set -e -x

pwd
ls

# Test then Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" install -q setuptools wheel auditwheel twine nose
    (cd /io/ && "${PYBIN}/python" setup.py -q nosetests)
    (cd /io/ && "${PYBIN}/python" setup.py -q bdist_wheel)
done

# Wheels aren't considered manylinux unless they have been through 
# auditwheel. (Know idea why.) Auditted wheels go in /io/wheels/.
mkdir -p /io/wheels/
for whl in /io/dist/*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w /io/wheels/
        
done

ls wheels

twine upload wheels/*.whl --skip-existing -- repository-url https://test.pypi.org/legacy/ --non-interactive --username bwoodsend



