@Library('xmos_jenkins_shared_library@v0.27.0') _

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
    string(
      name: 'XMOSDOC_VERSION',
      defaultValue: 'v5.5.2',
      description: 'The xmosdoc version'
    )
  }

  stages {
    stage('Documentation') {
      agent {
        label 'docker'
      }
      steps {
        println "Stage running on ${env.NODE_NAME}"
        sh "docker pull ghcr.io/xmos/xmosdoc:${params.XMOSDOC_VERSION}"
        sh """docker run -u "\$(id -u):\$(id -g)" \
              --rm \
              -v ${WORKSPACE}:/build \
              ghcr.io/xmos/xmosdoc:${params.XMOSDOC_VERSION} -v"""
        archiveArtifacts artifacts: 'doc/_build/**', allowEmptyArchive: false
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
              label "${PLATFORM} && x86_64"
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
