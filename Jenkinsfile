pipeline {

    agent any

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube_token')
        SONARQUBE_URL = 'http://localhost:9095'
    }

    stages {

        stage("build infrastructure") {
            steps {
                dir("terraform") {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', passwordVariable: 'aws_secret_key', usernameVariable: 'aws_access_key')]) {
                        sh '''
                            terraform init

                            terraform apply -var='aws_access_key=${aws_access_key}' -var='aws_secret_key=${aws_secret_key}' -auto-approve
                        '''
                    }

                    // Returns bastion host ip.
                    script {
                        BASTION_HOST_IP = sh (
                            script: 'terraform output bastion-private-ip',
                            returnStdout: true
                        ).trim()
                        
                        echo "Bastion host ip: ${BASTION_HOST_IP}"
                    }

                }
            }
        }

        stage("deploy code") {
            steps {
                 dir('terraform') {
                    // Transfers project files to bastion host to be sharable among all instances via nfs.
                    sh '''
                        chmod 400 ec2-key.pem
                        scp -o StrictHostKeyChecking=no -rp -i ec2-key.pem $WORKSPACE ec2-user@${BASTION_HOST_IP}:/home/ec2-user/
                    '''
                }
            }

        }

        stage('sonarqube analysis') {
            steps {
                dir('node-app') {
                    sh " sed -i -e 's|URL|${SONARQUBE_URL}|; s|TOKEN|${SONARQUBE_TOKEN}|' sonar-project.properties"

                    nodejs(nodeJSInstallationName: 'nodejs') {
                        sh 'npm install'
                        withSonarQubeEnv('sonar') {
                            sh '''
                                npm set strict-ssl false
                                npm install sonar-scanner
                                npm run sonar
                            '''
                        }
                    }
                }
            }
        }

    }
}