pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh 'whoami;pwd;rvm --version'
        sh 'ruby --version'
        sh 'bundle install'
        sh 'rubocop'
        sh 'echo "packer build"'
      }
    }
    stage('Deployment') {
      steps {
        sh 'echo "start deployment"'
      }
    }
  }
}