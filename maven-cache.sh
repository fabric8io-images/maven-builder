#!/bin/bash
# check if maven dependencies are cached by previous build
# if not then it downloads the prebuilt cache from online source
# MAVEN_CACHE_ENABLE : To enable maven prebuild caching
# MAVEN_CACHE_TAR_URL : The prebuilt tarball URL as tar.gz where all dependencies are located
# MAVEN__LOCAL_REPOSITORY_PATH: Local maven repository path

if [[ -n ${MAVEN_CACHE_ENABLE} && ${MAVEN_CACHE_ENABLE} == "true" && -n ${MAVEN_CACHE_TAR_URL} && \
      -n ${MAVEN__LOCAL_REPOSITORY_PATH} && -d ${MAVEN__LOCAL_REPOSITORY_PATH} ]]; then

    echo "Downloading the prebuilt maven cache\n"

	MAVEN_CACHE_TAR_FILE=$(basename ${MAVEN_CACHE_TAR_URL})

    curl -L ${MAVEN_CACHE_TAR_URL} -o /tmp/${MAVEN_CACHE_TAR_FILE} \
        && tar -xvzf /tmp/${MAVEN_CACHE_TAR_FILE} -C /tmp \
        && restorecon -Rv /tmp/repository/ \
        && mv /tmp/repository/* ${MAVEN__LOCAL_REPOSITORY_PATH} \
        && rm -rf /tmp/${MAVEN_CACHE_TAR_FILE}
fi

cat
