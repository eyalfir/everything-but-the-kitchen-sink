#! /bin/bash

set -o nounset
set -o errexit
set -o pipefail

cd $(dirname $0)
TAG=$1
echo TESTING ${TAG}
docker run --rm ${TAG} bash -c "
set -o errexit
echo ...kubectl
kubectl version --client=true
echo ...helm
helm version
echo ...jq
jq --version
echo ...gcloud
gcloud --version
echo ...terraform
terraform version
echo ...packer
packer version
echo ...python3
python3 --version
echo ...google-cloud-firestore
python3 -c 'import google.cloud.firestore'
echo ...ipython
ipython --version
echo ...vim
vim --help
echo ..kafka
python3 -c 'import kafka'
echo ..redis
redis-cli --version
echo ..mysql
mysql --version
echo ..docker-compose
docker-compose version
echo ..yq
yq --version
echo ..redoc-cli
redoc-cli --help
echo ..dyff
dyff --help
echo ..envsubst
envsubst --version
echo ..istioctl
istioctl version
echo ..argocd
argocd version
"
