pipeline {

    agent any

    environment {
        // SONARQUBE_TOKEN = credentials('sonarqube_token')
        // SONARQUBE_URL = 'http://localhost:9095'
        S3_KEY = "key"
        HASH_KEY = "LockID"
        DYNAMODB_NAME = "eks-tf-state"
        S3_BUCKET_NAME = "eks-tf-s3-state"
        KMS_ALIAS = "alias/terraform-bucker"
    }

    stages {
        stage("create s3 backend") {
            steps {
                dir("terraform/backend-state") {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', passwordVariable: 'AWS_SECRET_KEY', usernameVariable: 'AWS_ACCESS_KEY')]) {
                        sh '''
                            terraform init

                            terraform apply -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -var="s3_key=${S3_KEY}" -var="hash_key=${HASH_KEY}" -var="dynamodb_name=${DYNAMODB_NAME}" -var="s3_bucket_name=${S3_BUCKET_NAME}" -var="kms_alias=${KMS_ALIAS}" -auto-approve
                        '''
                    }

                }
            }
        }
        
        stage("deploy infrastructure") {
            steps {
                dir("terraform") {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', passwordVariable: 'AWS_SECRET_KEY', usernameVariable: 'AWS_ACCESS_KEY')]) {
                        sh '''
                            terraform init

                            terraform apply -var="aws_access_key=${AWS_ACCESS_KEY}" -var="aws_secret_key=${AWS_SECRET_KEY}" -auto-approve
                        '''
                    }

                    // Returns bastion host ip.
                    script {
                        BASTION_HOST_IP = sh(
                            script: 'terraform output bastion-private-ip',
                            returnStdout: true
                        ).trim()

                        KEY = sh(
                            script: 'terraform output key',
                            returnStdout: true
                        ).trim()

                        echo "Bastion host ip: ${KEY}"
                    }

                }
            }
        }

        stage("deploy code") {
            steps {
                dir('terraform') {
                    // Transfers project files to bastion host to be sharable among all instances via nfs.
                    sh '''
                        chmod 400 ${KEY}.pem
                        scp -o StrictHostKeyChecking=no-rp -i ${KEY}.pem $WORKSPACE ec2-user@${BASTION_HOST_IP}: /home/ec2-user/
                    '''
                }
            }

        }

        // stage('sonarqube analysis') {
        //     steps {
        //         dir('node-app') {
        //             sh " sed -i -e 's|URL|${SONARQUBE_URL}|; s|TOKEN|${SONARQUBE_TOKEN}|' sonar-project.properties"

        //             nodejs(nodeJSInstallationName: 'nodejs') {
        //                 sh 'npm install'
        //                 withSonarQubeEnv('sonar') {
        //                     sh '''
        //                         npm set strict-ssl false
        //                         npm install sonar-scanner
        //                         npm run sonar
        //                     '''
        //                 }
        //             }
        //         }
        //     }
        // }

    }
}
