# Jenkins Agent PYB

This project is a docker-based build agent with the capability of running PyBuilder via Python.

More importantly, the process for building **and testing** this agent is fully automated.

Prerequisites

- For building on Jenkins: https://github.com/jvalentino/jenkins-agent-docker
- For running Jenkins use Docker Agents: https://github.com/jvalentino/example-jenkins-docker-jcasc-2

# Locally

## Build

I wrote a script to run the underlying command:

```bash
$ ./build.sh 

+ docker build -t jvalentino2/jenkins-agent-pyb .
[+] Building 1.1s (7/7) FINISHED                                                            
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 37B                                                    0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 2B                                                        0.0s
 => [internal] load metadata for docker.io/jenkins/agent:latest-jdk11                  1.0s
 => [auth] jenkins/agent:pull token for registry-1.docker.io                           0.0s
 => [1/2] FROM docker.io/jenkins/agent:latest-jdk11@sha256:cbafd026949fd9a796eb3d125a  0.0s
 => CACHED [2/2] RUN apt-get update &&      apt-get install python3-minimal=3.9.2-3 -  0.0s
 => exporting to image                                                                 0.0s
 => => exporting layers                                                                0.0s
 => => writing image sha256:0dc6a3dc8ee1a50800ec11baa2c21949143bce02d223035368371d6da  0.0s
 => => naming to docker.io/jvalentino2/jenkins-agent-pyb                               0.0s
```

The result is the image of `jvalentino2/jenkins-agent-pyb`.

## Run

If you want to open a temporary shell into an instance of this image, run the following command:

```bash
$ ./run.sh 
+ docker compose run --rm jenkins_agent_pyb
root@0bf64aeed414:/home/jenkins# 
```

This opens a shell into container, where you can do things like verify the versions in use:

```bash
root@0bf64aeed414:/home/jenkins# python -V
Python 3.9.2
root@0bf64aeed414:/home/jenkins# pyb --version
pyb 0.13.8
root@0bf64aeed414:/home/jenkins# pip --version
pip 20.3.4 from /usr/lib/python3/dist-packages/pip (python 3.9)
```

when done, just type:

```bash
root@5e02d6963730:/home/jenkins# exit
exit
~/workspaces/personal/jenkins-agent-python $ 
```

It will kill the container and put you back at your own shell.

## Test

It is important to know that this container can actually build an Python project, so a script was included to launch the container and also run an PyBuilder build on the project within the workspace. It will then check for the specific files and return a non-zero exit code if they are not found.

```bash
$ ./test.sh

+ docker compose run --rm jenkins_agent_pyb sh -c 'cd workspace; ./test.sh'
+ cd example-python-pyb-lib-1
+ pyb clean
PyBuilder version 0.13.8
Build started at 2023-01-04 19:09:33
------------------------------------------------------------
[INFO]  Building example-python-pyb-lib-1 version 1.0.dev0
[INFO]  Executing build in /home/jenkins/workspace/example-python-pyb-lib-1
[INFO]  Going to execute task clean
[INFO]  Removing target directory /home/jenkins/workspace/example-python-pyb-lib-1/target
------------------------------------------------------------
BUILD SUCCESSFUL
------------------------------------------------------------
Build Summary
             Project: example-python-pyb-lib-1
             Version: 1.0.dev0
      Base directory: /home/jenkins/workspace/example-python-pyb-lib-1
        Environments: 
               Tasks: clean [5546 ms]
Build finished at 2023-01-04 19:09:47
Build took 14 seconds (14148 ms)
+ pyb install_dependencies
PyBuilder version 0.13.8
Build started at 2023-01-04 19:09:47
------------------------------------------------------------
[INFO]  Building example-python-pyb-lib-1 version 1.0.dev0
[INFO]  Executing build in /home/jenkins/workspace/example-python-pyb-lib-1
[INFO]  Going to execute task install_dependencies
[INFO]  Processing plugin packages 'coverage~=6.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'flake8~=4.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'pypandoc~=1.4' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'setuptools>=38.6.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'twine>=1.15.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'unittest-xml-reporting~=3.0.4' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'wheel>=0.34.0' to be installed with {'upgrade': True}
[INFO]  Creating target 'build' VEnv in '/home/jenkins/workspace/example-python-pyb-lib-1/target/venv/build/cpython-3.9.2.final.0'
[INFO]  Processing dependency packages 'mockito' to be installed with {}
[INFO]  Processing dependency packages 'requests' to be installed with {}
[INFO]  Creating target 'test' VEnv in '/home/jenkins/workspace/example-python-pyb-lib-1/target/venv/test/cpython-3.9.2.final.0'
[INFO]  Processing dependency packages 'requests' to be installed with {}
[INFO]  Installing all dependencies
[INFO]  Processing dependency packages 'mockito' to be installed with {}
[INFO]  Processing dependency packages 'requests' to be installed with {}
------------------------------------------------------------
BUILD SUCCESSFUL
------------------------------------------------------------
Build Summary
             Project: example-python-pyb-lib-1
             Version: 1.0.dev0
      Base directory: /home/jenkins/workspace/example-python-pyb-lib-1
        Environments: 
               Tasks: prepare [45527 ms] install_dependencies [1238 ms]
Build finished at 2023-01-04 19:10:41
Build took 53 seconds (53465 ms)
+ pyb
PyBuilder version 0.13.8
Build started at 2023-01-04 19:10:41
------------------------------------------------------------
[INFO]  Building example-python-pyb-lib-1 version 1.0.dev0
[INFO]  Executing build in /home/jenkins/workspace/example-python-pyb-lib-1
[INFO]  Going to execute task publish
[INFO]  Processing plugin packages 'coverage~=6.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'flake8~=4.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'pypandoc~=1.4' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'setuptools>=38.6.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'twine>=1.15.0' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'unittest-xml-reporting~=3.0.4' to be installed with {'upgrade': True}
[INFO]  Processing plugin packages 'wheel>=0.34.0' to be installed with {'upgrade': True}
[INFO]  Creating target 'build' VEnv in '/home/jenkins/workspace/example-python-pyb-lib-1/target/venv/build/cpython-3.9.2.final.0'
[INFO]  Creating target 'test' VEnv in '/home/jenkins/workspace/example-python-pyb-lib-1/target/venv/test/cpython-3.9.2.final.0'
[INFO]  Requested coverage for tasks: pybuilder.plugins.python.unittest_plugin:run_unit_tests
[INFO]  Running unit tests
[INFO]  Executing unit tests from Python modules in /home/jenkins/workspace/example-python-pyb-lib-1/src/unittest/python
[INFO]  Executed 2 unit tests
[INFO]  All unit tests passed.
[INFO]  Building distribution in /home/jenkins/workspace/example-python-pyb-lib-1/target/dist/example-python-pyb-lib-1-1.0.dev0
[INFO]  Copying scripts to /home/jenkins/workspace/example-python-pyb-lib-1/target/dist/example-python-pyb-lib-1-1.0.dev0/scripts
[INFO]  Writing setup.py as /home/jenkins/workspace/example-python-pyb-lib-1/target/dist/example-python-pyb-lib-1-1.0.dev0/setup.py
[INFO]  Collecting coverage information for 'pybuilder.plugins.python.unittest_plugin:run_unit_tests'
[WARN]  ut_coverage_branch_threshold_warn is 0 and branch coverage will not be checked
[WARN]  ut_coverage_branch_partial_threshold_warn is 0 and partial branch coverage will not be checked
[INFO]  Running unit tests
[INFO]  Executing unit tests from Python modules in /home/jenkins/workspace/example-python-pyb-lib-1/src/unittest/python
[INFO]  Executed 2 unit tests
[INFO]  All unit tests passed.
[INFO]  Overall pybuilder.plugins.python.unittest_plugin.run_unit_tests coverage is 100%
[INFO]  Overall pybuilder.plugins.python.unittest_plugin.run_unit_tests branch coverage is 100%
[INFO]  Overall pybuilder.plugins.python.unittest_plugin.run_unit_tests partial branch coverage is 100%
[INFO]  Overall example-python-pyb-lib-1 coverage is 100%
[INFO]  Overall example-python-pyb-lib-1 branch coverage is 100%
[INFO]  Overall example-python-pyb-lib-1 partial branch coverage is 100%
[INFO]  Building binary distribution in /home/jenkins/workspace/example-python-pyb-lib-1/target/dist/example-python-pyb-lib-1-1.0.dev0
[INFO]  Running Twine check for generated artifacts
------------------------------------------------------------
BUILD SUCCESSFUL
------------------------------------------------------------
Build Summary
             Project: example-python-pyb-lib-1
             Version: 1.0.dev0
      Base directory: /home/jenkins/workspace/example-python-pyb-lib-1
        Environments: 
               Tasks: prepare [27110 ms] compile_sources [0 ms] run_unit_tests [887 ms] package [52 ms] run_integration_tests [0 ms] verify [0 ms] coverage [1858 ms] publish [4749 ms]
Build finished at 2023-01-04 19:11:22
Build took 41 seconds (41659 ms)
+ echo  
 
+ echo Validation...
Validation...
+ [ ! -f target/dist/example-python-pyb-lib-1-1.0.dev0/dist/example_python_pyb_lib_1-1.0.dev0-py3-none-any.whl ]
+ [ ! -f target/dist/example-python-pyb-lib-1-1.0.dev0/dist/example-python-pyb-lib-1-1.0.dev0.tar.gz ]
+ [ ! -f target/reports/example-python-pyb-lib-1_coverage ]
+ [ ! -f target/reports/unittest ]
+ echo Validation Done
Validation Done
~/workspaces/personal/jenkins-agent-pyb $ 
```



# On Jenkins

On Jenkins, the pipeline itself requires the image build from https://github.com/jvalentino/jenkins-agent-docker, which is jvalentino2/jenkins-agent-docker. The docker label on Jenkins must be mapped to that jvalentino2/jenkins-agent-docker image.

![](https://github.com/jvalentino/jenkins-agent-docker/raw/main/wiki/02.png)

In this case though, the actual image in use in jvalentino2/jenkins-agent-docker:latest to always pull the latest.

The Jenkinsfile itself then calls the same commands as the Docker Agent, to build, test, and then publish that image to Dockerhub:

```groovy
pipeline {
 agent { label 'docker' }

 environment {
    IMAGE_NAME    = 'jvalentino2/jenkins-agent-pyb'
    MAJOR_VERSION = '1'
    HUB_CRED_ID   = 'dockerhub'
  }

  stages {
    
    stage('Docker Start') {
      steps {
       dockerStart()
      }
    } // Docker Start

     stage('Build') {
      steps {
       build("${env.IMAGE_NAME}")
      }
    } // Build

    stage('Test') {
      steps {
       test()
      }
    } // Test
    
    stage('Publish') {
      steps {
        publish("${env.IMAGE_NAME}", "${env.MAJOR_VERSION}", "${env.HUB_CRED_ID}")
      }
    } // Publish

    stage('Docker Stop') {
      steps {
       dockerStop()
      }
    } // Docker Start

  }
}

def dockerStart() {
  sh '''
    nohup dockerd &
    sleep 10
  '''
}

def dockerStop() {
  sh 'cat /var/run/docker.pid | xargs kill -9 || true'
}

def build(imageName) {
  sh "docker build -t ${imageName} ."
}

def test() {
  sh "./test.sh"
}

def publish(imageName, majorVersion, credId) {
  withCredentials([usernamePassword(
      credentialsId: credId, 
      passwordVariable: 'DOCKER_PASSWORD', 
      usernameVariable: 'DOCKER_USERNAME')]) {
          sh """
              docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD
              docker tag ${imageName}:latest ${imageName}:${majorVersion}.${BUILD_NUMBER}
              docker tag ${imageName}:latest ${imageName}:latest
              docker push ${imageName}:${majorVersion}.${BUILD_NUMBER}
              docker push ${imageName}:latest
          """
      }
}
```

Note that I wrote groovy methods to handle running the underlying commands via different stages.

