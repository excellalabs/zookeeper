#!/usr/bin/env groovy

pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh 'which bundle || gem install bundler'
        sh 'bundle install'
      }
    }
    stage('Code Analysis') {
      steps {
        rake 'rubocop'
      }
    }
    stage('Zookeeper AMI') {
      steps {
        sh '''
          # create vendor cookbooks
          berks vendor cookbooks/vendor-cookbooks
        '''
        sh '''
          # Build AMI with Packer
          # packer build packer.json
          # ami_id="$(cat manifest.json | jq -r .builds[0].artifact_id | cut -d\':\' -f2)"
          # keystore.rb store --table $inventory_store --kmsid $kms_id --keyname "ZOOKEEPER_LATEST_AMI" --value ${ami_id}
        '''
      }
    }
    stage('Deployment') {
      steps {
        sh '''
          echo "start deployment"
          ami_id="$(keystore.rb retrieve --table $inventory_store --keyname ZOOKEEPER_LATEST_AMI)"
          echo "deploy this ami: ${ami_id}"
        '''

        // Deploy Zookeeper
        rake 'deploy'
      }
    }
  }
}

// Helper function for rake
def rake(String command) {
  sh "bundle exec rake $command"
}
