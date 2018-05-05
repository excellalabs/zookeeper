pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh '''whoami;pwd;
echo jenkins | sudo -S adduser jenkins sudo
# echo jenkins | sudo -S apt-add-repository -y ppa:rael-gc/rvm
echo jenkins | sudo -S apt-get update
# sudo apt-get install rvm -y
# rvm install ruby
echo jenkins | sudo -S apt-get install ruby
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