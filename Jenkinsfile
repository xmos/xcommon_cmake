@Library('xmos_jenkins_shared_library@v0.27.0') _

def run_tests(cmake_ver) {
  sh 'git submodule update --init'
  createVenv('python_version.txt')
  withVenv {
    sh 'pip install -r requirements.txt'
    script {
      if ("${cmake_ver}" == 'latest') {
        sh 'pip install cmake'
      }
      else {
        sh "pip install cmake==${cmake_ver}"
      }
    }

    dir('tests') {
      withTools(params.TOOLS_VERSION) {
        withEnv(["XMOS_CMAKE_PATH=${WORKSPACE}"]) {
          sh 'pytest -n auto --junitxml=pytest_result.xml'
        }
      }
    }
  }
}

getApproval()

pipeline {
  agent none
  options {
    timestamps()
    buildDiscarder(xmosDiscardBuildSettings(onlyArtifacts=false))
  }
  parameters {
    string(
      name: 'TOOLS_VERSION',
      defaultValue: '15.2.1',
      description: 'The XTC Tools version'
    )
  }

  stages {
    stage('Test') {
      matrix {
        axes {
          axis {
            name 'PLATFORM'
            values 'linux', 'macos', 'windows'
          }
          axis {
            name 'CMAKE_VERSION'
            values '3.21.0', 'latest'
          }
        }
        stages {
          stage("Test") {
            agent {
              label "${PLATFORM} && x86_64"
            }
            steps {
              run_tests("${CMAKE_VERSION}")
            }
            post {
              always {
                junit 'tests/pytest_result.xml'
              }
              cleanup {
                xcoreCleanSandbox()
              }
            }
          }
        }
      }
    }
  }
}
