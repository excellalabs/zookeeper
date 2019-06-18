#!/usr/bin/env groovy

pipeline {
  agent any
  parameters {
    choice(
      choices: 'NO\nYES',
      description: 'Build AMI feature toggle',
      name: 'BUILD_AMI')
  }
  stages {

    stage('Commit') {
      steps {
        sh 'rm -rf ./*'
        checkout scm
        rvm '2.5.3'
      }
    }

    stage('Code Analysis') {
      steps {
        rake 'rubocop'
      }
    }

    stage('Zookeeper AMI') {
      when {
        expression { params.BUILD_AMI == 'YES' }
      }
      steps {
        sh '''
          # create vendor cookbooks
          cd cookbooks/zookeeper-config/
          berks vendor ../vendor-cookbooks
          cd ../..
        '''
        sh '''
          # Build AMI with Packer
          packer build packer/zookeeper.json
        '''
        sh '''
          # Save ami_id
          ami_id="$(cat manifest.json | jq -r .builds[0].artifact_id | cut -d\':\' -f2)"
          keystore.rb store --table $inventory_store --kmsid $kms_id --keyname "ZOOKEEPER_LATEST_AMI" --value ${ami_id}
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

def rvm(String version) {
  sh returnStdout: false, script: """#!/bin/bash --login
    source /usr/share/rvm/scripts/rvm && \
      rvm use --install --create ${version} && \
      export | egrep -i "(ruby|rvm)" > rvm.env
    rvm use default ${version}
    rvm alias create default ruby-${version}
    which bundle || gem install bundler -v 1.17.3
    bundle install
  """
}