pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh 'which bundle || gem install bundler'
        sh 'bundle install'
        sh 'rubocop'
        sh '''
          # create vendor cookbooks
          berks vendor cookbooks/vendor-cookbooks
        '''
        sh '''
          # Build AMI with Packer
          packer build packer.json
          ami_id="$(cat manifest.json | jq -r .builds[0].artifact_id |  cut -d\':\' -f2)"
        '''
      }
    }
    stage('Deployment') {
      steps {
        sh '''
          echo "start deployment"
          echo "deploy ami: $ami_id"
        '''
      }
    }
  }
}
