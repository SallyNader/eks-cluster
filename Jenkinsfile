pipeline {

    agent any

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube_token')
        SONARQUBE_URL = 'http://localhost:9095'
        CLUSTER_NAME = "udacity"
    }

    stages {
        stage("Build Code") {
            steps {
                dir('node-app') {
                    sh "npm install"
                }
            }
        }
        stage("Test Code") {
            steps {
                dir('node-app') {
                    sh "npm run test"
                }
            }
        }
        stage("Scan Code") {
            steps {
                dir('node-app') {
                    sh "npm audit fix --audit-level=critical --force"
                }
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                dir('node-app') {
                    // Replaces Sonarqube token in Sonarqube file.
                    sh " sed -i -e 's|URL|${SONARQUBE_URL}|; s|TOKEN|${SONARQUBE_TOKEN}|' sonar-project.properties"

                    nodejs(nodeJSInstallationName: 'nodejs') {
                        sh 'npm install'
                        withSonarQubeEnv('sonar') {
                            sh '''
                                npm set strict-ssl false
                                npm run sonar
                            '''
                        }
                    }
                }
            }
        }

        stage("Create S3 Backend") {
            steps {
                dir("terraform/backend-state") {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', passwordVariable: 'AWS_SECRET_KEY', usernameVariable: 'AWS_ACCESS_KEY')]) {
                        sh '''
                            terraform init

                            terraform apply -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -auto-approve
                        '''
                    }

                }
            }
        }
        
        stage("Deploy Infrastructure") {
            steps {
                dir("terraform") {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', passwordVariable: 'AWS_SECRET_KEY', usernameVariable: 'AWS_ACCESS_KEY')]) {
                        sh '''
                            terraform init

                            terraform apply  -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -var="cluster_name=${CLUSTER_NAME}" -auto-approve
                        '''
                    }

                }
            }
        }

        stage("Deploy Code To NFS") {
            steps {
                dir('terraform') {
                    // Transfers project files to bastion host to be sharable among all instances via nfs.
                    sh '''
                        chmod 400 ${KEY_NAME}.pem
                        scp -o StrictHostKeyChecking=no -rp -i ${KEY_NAME}.pem $WORKSPACE ec2-user@${BASTION_HOST_IP}: /home/ec2-user/
                    '''
                }
            }

        }

    }
}