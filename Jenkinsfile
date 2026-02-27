@Library('xmos_jenkins_shared_library@v0.39.0') _

def run_tests(cmake_ver) {
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
          sh 'pytest -n auto --junitxml=pytest_result.xml -v'
        }
      }
    }
  }
}

def os_label = [
    linux: 'linux && x86_64',
    macos: 'macos && arm64',
    windows: 'windows && x86_64',
]

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
      defaultValue: '15.3.1',
      description: 'The XTC Tools version'
    )
    string(
      name: 'XMOSDOC_VERSION',
      defaultValue: 'v7.1.0',
      description: 'The xmosdoc version'
    )
  }

  stages {
    stage('Documentation') {
      agent {
        label 'linux && x86_64'
      }
      steps {
        println "Stage running on ${env.NODE_NAME}"
        buildDocs()
      }
      post {
        cleanup {
          xcoreCleanSandbox()
        }
      }
    }
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
              label "${os_label[env.PLATFORM]}"
            }
            steps {
              println "Stage running on ${env.NODE_NAME}"
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
