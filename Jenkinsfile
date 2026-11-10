pipeline { 
  agent any
  stages {
    stage('System Information') {
      steps {
        sh 'bash scripts/system_info.sh'
      }
    }
    stage('Health Check') {
      steps { 
        sh 'bash scripts/health_check.sh cron nginx'
      }
    }
    stage('User Report') {
      steps {
        sh 'bash scripts/user_report.sh'
      }
    }
  }
}
