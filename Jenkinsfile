def ami_id = 'UNKNOWN'
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
        '''
        script {
          ami_id="$(cat manifest.json | jq -r .builds[0].artifact_id | cut -d\':\' -f2)"
          echo "1 ==> $ami_id"
        }
        echo "2 ==> ${ami_id}"
      }
    }
    stage('Deployment') {
      steps {
        sh '''
          echo "start deployment"
          echo "3 ==> deploy ami: $ami_id"
        '''
        echo "4 ==> ${ami_id}"
      }
    }
  }
}
