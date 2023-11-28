pipeline {
    agent { label 'MAVEN' }
    options { 
        timeout(time: 30, unit: 'MINUTES') 
    }
    triggers {
        cron('30 16 * * *')
    }
    stages {
        stage('git') {
            steps {
                git url: 'https://github.com/dummyrepos/spring-petclinic-nov23.git', 
                    branch: 'release'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean package'
                
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/spring-petclinic-*.jar'
                    junit testResults: '**/TEST-*.xml'
                }
                failure {
                    mail subject: 'build stage failed',
                         from: 'build@learningthoughts.io',
                         to: 'all@learningthoughts.io',
                         body: "Refer to $BUILD_URL for more details"
                }
            }
        }
    }
    
}