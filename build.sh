#! /bin/bash
echo '1'
set -o nounset
set -o errexit
set -o pipefail
echo '2'
cd $(dirname $0)
echo '3'
TAG=${1}
echo '4'
echo ${TAG}
echo '5'
docker build --tag ${TAG} --label panw.di.commit=${CI_COMMIT_SHORT_SHA:-unknown} --label panw.di.branch=${CI_COMMIT_REF_SLUG:-unknown} .
echo '6'
echo BUILT ${TAG}
