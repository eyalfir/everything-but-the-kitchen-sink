FROM google/cloud-sdk:354.0.0
LABEL description="docker image to use for CI/CD. has jq, helm, kubectl, gcloud, curl"



ENV VERSION=3.7.2

# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${VERSION}-linux-amd64.tar.gz"

RUN curl --insecure -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

RUN curl --insecure -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.2/kubeseal-0.17.2-linux-amd64.tar.gz | tar xvz && \
    mv kubeseal /usr/bin/ && \
    chmod +x /usr/bin/kubeseal && \
    rm -rf *


RUN apt-get -qqy update
RUN dpkg --configure -a
RUN apt-get install -f
RUN apt-get -o Dpkg::Options::="--force-confnew" install -y procps
RUN apt-get install -qqy jq zip python3-pip vim redis-tools default-mysql-client pandoc npm libxml2-dev libxslt1-dev gettext-base

ENV TERRAFORM_VERSION=0.13.5
ENV TERRAFORM_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl --insecure https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_FILE} -O && \
    unzip ${TERRAFORM_FILE} -d /usr/bin && \
    rm *.zip

RUN curl --insecure https://releases.hashicorp.com/packer/1.6.4/packer_1.6.4_linux_amd64.zip -O && unzip packer_1.6.4_linux_amd64.zip -d /usr/bin && rm *zip
RUN pip3 install grpcio==1.39.0 google-api-core==2.0.0 google-cloud-core==2.0.0 grpc-google-iam-v1==0.12.3
RUN pip3 install google-cloud-firestore==2.3.0 ipython==7.18.1 kafka-python==2.0.2 ujson==4.0.1 yq==2.11.1 PyYAML==5.3.1 pytest==6.1.1 PySocks==1.7.1 requests_toolbelt==0.9.1 pytest-xdist==2.1.0 pygit2==1.0.3 pytest-randomly==3.4.1 sirem==0.0.9 pytest-parallel
RUN pip3 install Cython happybase==1.2.0 lxml ply==3.11 pyaml==20.4.0 pymongo==3.11.0 ansible==2.10.1 elasticsearch==7.9.1 iso3166==1.0 junit-xml==1.8 pytest-html==2.1.1
RUN pip3 install thriftpy pytest-json==0.4.0 python-geoip==1.2 PyMySQL==0.10.1 locust==1.1 locustio==0.14.6
RUN pip3 install six==1.15.0 googleapis-common-protos==1.53.0 google-cloud-bigtable==2.3.3 google-cloud-storage==1.42.0 google-resumable-media==2.0.0 avro==1.9.1 redis==3.5.3 joblib==0.15.1 google-cloud-bigquery==2.25.1 PyJWT==1.7.1 cryptography==3.1.1 avro-python3==1.10.0
RUN npm install -g redoc-cli || npm install -g redoc-cli
RUN echo "alias ll='ls -l'" >> ~/.bashrc
RUN curl --insecure -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-Linux-x86_64" -o /usr/bin/docker-compose && chmod +x /usr/bin/docker-compose
RUN curl --insecure -L "https://github.com/homeport/dyff/releases/download/v1.0.2/dyff-linux-amd64" -O && \
    chmod +x dyff-linux-amd64 && \
    mv dyff-linux-amd64 /usr/bin/dyff
RUN curl --insecure -L "https://kind.sigs.k8s.io/dl/v0.9.0/kind-$(uname)-amd64" -o ./kind && \
    chmod +x ./kind && \
    mv ./kind /usr/bin/kind

WORKDIR /apps


# vault installation
ENV VAULT_VERSION=1.6.0
ENV VAULT_FILE=vault_${VAULT_VERSION}_linux_amd64.zip
RUN curl --insecure https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_FILE} -O && \
    unzip ${VAULT_FILE} -d /usr/bin && \
    rm *.zip

RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.7.4 TARGET_ARCH=x86_64 sh -

RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.7.8/argocd-linux-amd64 && chmod +x /usr/local/bin/argocd

# tools
RUN apt-get install -y netcat net-tools
