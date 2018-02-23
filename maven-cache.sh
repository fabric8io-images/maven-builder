#!/bin/bash
# check if maven dependencies are cached by previous build
# if its then it downloads the prebuild cache from online source
# MAVEN_CACHE_TAR_URL : The prebuilt tarball URL as tar.gz where all dependencies are located
set -x

if [[ -n ${MAVEN_CACHE_TAR_URL} && ! -d /root/.mvnrepository/repository ]]; then
    echo "Downloading the prebuilt maven cache\n"
	MAVEN_CACHE_TAR_FILE=$(basename ${MAVEN_CACHE_TAR_URL})

    curl -L ${MAVEN_CACHE_TAR_URL} -o /tmp/${MAVEN_CACHE_TAR_FILE} \
        && tar -xvzf /tmp/${MAVEN_CACHE_TAR_FILE} -C /tmp \
        && mv /tmp/repository /root/.mvnrepository \
        && rm -rf /tmp/${MAVEN_CACHE_TAR_FILE}
fi
exec sleep infinity
