#!/bin/bash
#
# Build script for CI builds on CentOS CI
set -ex

function setup() {
    if [ -f jenkins-env.json ]; then
        eval "$(./env-toolkit load -f jenkins-env.json \
                FABRIC8_HUB_TOKEN \
                FABRIC8_DOCKERIO_CFG \
                ghprbActualCommit \
                ghprbPullAuthorLogin \
                ghprbGhRepository \
                ghprbTargetBranch \
                ghprbPullId \
                GIT_COMMIT \
                BUILD_ID)"

        mkdir -p ${HOME}/.docker
        echo ${FABRIC8_DOCKERIO_CFG}|base64 --decode > ${HOME}/.docker/config.json
    fi

    # We need to disable selinux for now, XXX
    /usr/sbin/setenforce 0 || :

    yum -y install docker git
    service docker start

    echo 'CICO: Build environment created.'
}

function addCommentToPullRequest() {
    message="$1"
    pr="$2"
    project="$3"
    url="https://api.github.com/repos/${project}/issues/${pr}/comments"

    set +x
    echo curl -X POST -s -L -H "Authorization: XXXX|base64 --decode)" ${url} -d "{\"body\": \"${message}\"}"
    curl -X POST -s -L -H "Authorization: token $(echo ${FABRIC8_HUB_TOKEN}|base64 --decode)" ${url} -d "{\"body\": \"${message}\"}"
    set -x
}


function build() {
    local version="SNAPSHOT-PR-${ghprbPullId}-${BUILD_ID}"
    [[ $1 == "deploy" ]] && version="v$(git rev-parse --short ${GIT_COMMIT})"

    local image="fabric8/maven-builder:${version}"

    docker build -t ${image} .

    docker push ${image}

    [[ $1 == "deploy" ]] && return

    docker run ${image} /bin/bash -xe -c 'cat /etc/redhat-release && java -version && mvn --version && git --version && git clone --depth=1 https://github.com/openshiftio-vertx-boosters/vertx-http-booster && cd vertx-http-booster && pwd && mvn clean -B -e -U package -Dmaven.test.skip=false -P openshift'
}
