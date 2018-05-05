pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh '''whoami;pwd;
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm -y
rvm install ruby
'''
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