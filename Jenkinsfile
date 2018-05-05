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

echo "hello hani"'''
        sh '''# create vendor cookbooks
berks vendor cookbooks/vendor-cookbooks

'''
        sh '''# Build AMI with Packer
# packer build packer.json
env | grep AWS_ACCESS_KEY_ID'''
      }
    }
    stage('Deployment') {
      steps {
        sh 'echo "start deployment"'
      }
    }
  }
}