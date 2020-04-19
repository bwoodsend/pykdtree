#!/bin/bash
set -e -x

#pwd
#ls
echo "Use OpenMP = $USE_OMP"


# Test then Compile wheels
# Skip cp27mu
mkdir -p /io/pip-cache
for PYBIN in /opt/python/*[!u]/bin; do
    "${PYBIN}/pip" install -q -U setuptools wheel nose numpy --cache-dir /io/pip-cache
    (cd /io/ && USE_OMP=$USE_OMP "${PYBIN}/python" setup.py -q nosetests)
    (cd /io/ && USE_OMP=$USE_OMP "${PYBIN}/python" setup.py -q bdist_wheel)
#    break
done

"$PYBIN/pip" install -q auditwheel twine

# Wheels aren't considered manylinux unless they have been through 
# auditwheel. (Know idea why.) Auditted wheels go in /io/wheels/.
mkdir -p /io/wheels/
for whl in /io/dist/*.whl; do
    auditwheel repair "$whl" --plat $PLAT -w /io/wheels/
        
done

ls /io/wheels




