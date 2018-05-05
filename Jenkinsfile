pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh '''whoami
pwd
which bundle || gem install bundler
'''
        sh 'bundle install'
        sh 'rubocop'
        sh '''aws --version
#export PATH="$PATH:/var/lib/jenkins/apps/packer"

packer -version

echo "hello hani"'''
      }
    }
    stage('Deployment') {
      steps {
        sh 'echo "start deployment"'
      }
    }
  }
}