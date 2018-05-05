#!/usr/bin/env groovy
pipeline {
  agent any
  stages {
    stage('Commit') {
      steps {
        sh 'echo "Start Pipeline"'
        checkout scm
        sh 'which bundle || gem install bundler'
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