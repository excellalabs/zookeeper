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
        sh '''#packer -version
#aws --version
ls -la /var/lib/jenkins/apps/
source ~/.bash_profile'''
      }
    }
    stage('Deployment') {
      steps {
        sh 'echo "start deployment"'
      }
    }
  }
}