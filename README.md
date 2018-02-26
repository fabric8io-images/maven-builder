# Maven Builder

Builder image used by kubernetes-workflow to execute Java maven builds


# Configuration:
 * *Maven Caching*: Allows building local maven repository with predefined set of dependencies on container boot up. Following are the ENV variables to configure this option
 	* MAVEN_CACHE_ENABLE: Set `true`  to enable maven caching feature. By default its disabled.
 	* MAVEN_CACHE_TAR_URL: URL to download tarball containing predefined set of dependencies required for maven build. e.g. https://s3.us-east-2.amazonaws.com/build-artifacts.tar.gz. URL must have the tarball file name like `build-artifacts.tar.gz` in given example.
    * MAVEN__LOCAL_REPOSITORY_PATH: Local maven repository path. Doesn't consider default path (/home/.m2)
