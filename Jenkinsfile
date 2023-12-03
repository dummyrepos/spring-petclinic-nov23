pipeline {
    agent { label 'MAVEN' }
    options { 
        timeout(time: 30, unit: 'MINUTES') 
    }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage('git') {
            steps {
                git url: 'https://github.com/dummyrepos/spring-petclinic-nov23.git', 
                    branch: 'dev'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean package'
                stash name: 'spc', includes: '**/target/spring-petclinic-3.2.0-SNAPSHOT.jar'
                withSonarQubeEnv(installationName: 'SONAR_CLOUD', credentialsId: 'SONAR_CLOUD') {
                   sh  'mvn clean verify sonar:sonar -Dsonar.host.url=https://sonarcloud.io -Dsonar.organization=jenkinsdec23 -Dsonar.projectKey=jenkinsdec23_test'
                }
                
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
        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
        stage("docker image") {
            agent { label 'DOCKER' }
            steps {
                unstash name: 'spc'
                sh 'docker image build -t shaikkhajaibrahim/spc:dev-$BUILD_ID .'
            }
        }
    }
    
}