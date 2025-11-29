pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
        TF_CLI_ARGS_init = "-upgrade"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                sh """
                    cd launchEC2
                    terraform init
                    terraform plan -out=tfplan
                """
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                    terraform plan -out=tfplan
                """
            }
        }
        stage('Approval Required') {
            steps {
                script {
                    emailext(
                        to: "team@company.com",
                        subject: "APPROVAL REQUIRED: Terraform Deployment Pending",
                        body: """
                        The Terraform pipeline is waiting for manual approval.

                        Job: ${env.JOB_NAME}
                        Build: ${env.BUILD_NUMBER}
                        User: ${env.BUILD_USER}

                        Please navigate to Jenkins and approve the deployment.
                        """
                    )
                    timeout(time: 15, unit: 'MINUTES') {
                        input(
                            message: "Approve Terraform Apply?",
                            submitter: "sandeep,teamlead,admin",
                            parameters: [
                                string(
                                    name: "JIRA_ID",
                                    defaultValue: "",
                                    description: "Enter associated Jira Ticket ID"
                                ),
                                booleanParam(
                                    name: "Emergency_Change",
                                    defaultValue: false,
                                    description: "Is this an emergency?"
                                )
                            ]
                        )
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    terraform apply -auto-approve tfplan
                """
            }
        }
    }


}
