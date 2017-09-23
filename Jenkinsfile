#!/usr/bin/groovy
/**
 * Copyright (C) 2015 Red Hat, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@Library('github.com/fabric8io/fabric8-pipeline-library@master')
def utils = new io.fabric8.Utils()
def flow = new io.fabric8.Fabric8Commands()
def project = "fabric8io-images/maven-builder"
dockerTemplate{
   clientsNode {
    ws{
      checkout scm

      if (utils.isCI()){
        def snapshotImageName = "${project}:SNAPSHOT-${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        container('docker'){
          stage('build snapshot image'){
            sh "docker build -t ${snapshotImageName} ."
          }
          stage('push snapshot image'){
            sh "docker push ${snapshotImageName}"
          }
        }
        stage('notify'){
            def pr = env.CHANGE_ID
            if (!pr){
                error "no pull request number found so cannot comment on PR"
            }
            def message = "snapshot maven-builder image is available for testing.  `docker pull ${snapshotImageName}`"
            container('docker'){
                flow.addCommentToPullRequest(message, pr, project)
            }
        }
      } else if (utils.isCD()){
        
        def v = getNewVersion{}
        // stage('tag'){
        //   container('clients'){
        //     gitTag{
        //       releaseVersion = v
        //       skipVersionPrefix = true
        //     }
        //   }
        // }

        def imageName = "${project}:${v}"

        container('docker'){
          stage('build image'){
            sh "docker build -t ${imageName} ."
          }
          stage('push image'){
            sh "docker push ${imageName}"
          }
        }
      }
    }
  }
}
