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
        sh 'bash scripts/health_check.sh cron nginx '
      }
    }
    stage('User Report') {
      steps {
        sh 'bash scripts/user_report.sh'
      }
    }
    stage('Backup') {
      steps {
        sh 'bash scripts/backup.sh'
      }
    }
    stage('Log Cleanup Preview') {
      steps {
        sh 'bash scripts/log_cleanup.sh --dry-run'
      }
    }
  }
}
