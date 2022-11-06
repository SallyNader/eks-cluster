def FAILED_STAGE

pipeline {

    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_KEY = credentials('AWS_SECRET_ACCESS')
        SONARQUBE_TOKEN = credentials('sonarqube_token')
        SONARQUBE_URL  = 'http://localhost:9095'
        CLUSTER_NAME = 'eks-cluster'
        KEY_PAIR = '/home/sally/Downloads/ec2-ssh.pem '
        SSH_KEY = '~/.ssh/id_rsa.pub'
        BUCKET_NAME = 's3--backend'
    }

    stages {
        stage("Build Code") {
            steps {
                dir('backend') {
                    sh "npm install"
                }
            }
        }
        stage("Test Code") {
            steps {
                dir('backend') {
                    sh "npm run test"
                }
            }
        }
        stage("Scan Code") {
            steps {
                dir('backend') {
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
                script {
                    // Stores stage name to check it on failure.
                    FAILED_STAGE=env.STAGE_NAME
                }

                dir("terraform/backend-state") {
                    sh '''
                        terraform init

                        terraform apply -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -var="s3_bucket_name=${BUCKET_NAME}" -auto-approve
                    '''

                }
            }
        }
        
        stage("Deploy Infrastructure") {
            steps {
                 script {
                    // Stores stage name to check it on failure.
                    FAILED_STAGE=env.STAGE_NAME
                }

                dir("terraform") {
                    sh '''
                        terraform init

                        terraform apply  -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -var="cluster_name=${CLUSTER_NAME}" -auto-approve
                    '''

                }
            }
        }

        stage("Deploy Code and Kubernetes Project") {
            steps {
                dir("ansible") {
                    sh '''
                        ansible-playbook deploy-code.yml -i inventory.txt --user ec2-user --key-file ${KEY_PAIR}  -e "key=${SSH_KEY}"
                        ansible-playbook -i inventory.txt deploy-kubernetes.yml
                    '''

                }
            }
        }

    }

    post {
        // Rollback based on the stage.
        failure {
            echo "Failed stage name: ${FAILED_STAGE}"
            echo "----------------------------------"
            script {
                if (FAILED_STAGE == 'Create S3 Backend') {
                    dir("terraform/backend-state") {
                        sh '''
                            terraform destroy -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -var="s3_bucket_name=${BUCKET_NAME}" -auto-approve
                        '''
                    }    
            
                }
                if (FAILED_STAGE == 'Deploy Infrastructure' || FAILED_STAGE == 'Deploy Code and Kubernetes Project') {
                    dir("terraform") {
                        sh 'terraform destroy -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -var="cluster_name=${CLUSTER_NAME}" -auto-approve'
                    }    
            
                }
            }
        }
    }
}
