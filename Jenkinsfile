pipeline {
    agent any
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['uat', 'lt', 'prod'], description: 'Select Environment')
        string(name: 'INFRA_TAG', defaultValue: '', description: 'Infra Release Tag in format vX.Y.Z-environment-description')
        choice(name: 'terraformchanges', choices: ['no', 'yes'], description: 'Do you want to apply terraform?')
    }
    stages {
        stage('Validate Tag') {
            steps {
                script {
                    if (!params.INFRA_TAG.matches(/^v\\d+\\.\\d+\\.\\d+-(uat|lt|prod)-[a-zA-Z0-9-]+(?:-\\d+)?$/)) {
                        error "Invalid tag format. Must be in format vX.Y.Z-uat/lt/prod-description or vX.Y.Z-uat/lt/prod-description-XX"
                    }
                    echo "Environment selected: ${params.ENVIRONMENT}"
                    echo "Tag selected: ${params.INFRA_TAG}"
                }
            }
        }
        stage('Checkout Infra Code') {
            steps {
                script {
                    // Fetch the repo and checkout by tag
                    git url: "https://github.com/bkash-ce/infra-tag-deployment", branch: "test", credentialsId: 'devops'
                    sh """
                       git fetch --all --tags
                       git fetch origin "refs/tags/${params.INFRA_TAG}:refs/tags/${params.INFRA_TAG}" || exit 1
                       git checkout tags/${params.INFRA_TAG} -b release-${params.INFRA_TAG}
                    """
                }
            }
        }
        stage('Terraform Plan') {
            when {
                expression { params.terraformchanges == 'yes' }
            }
            steps {
                script {
                    echo "Running Terraform Plan for ${params.ENVIRONMENT.toUpperCase()} environment..."
                    if (params.ENVIRONMENT == 'prod') {
                        input message: 'Do you want to proceed with Terraform Plan for PROD environment?'
                    }
                }
                dir('terraform') {
                    sh 'terraform init'
                    sh "terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}"
                    sh "terraform plan -out=myplan"
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression { params.terraformchanges == 'yes' }
            }
            steps {
                input message: 'Do you want to proceed with Terraform Apply?'
                dir('terraform') {
                    sh 'terraform apply -input=false myplan'
                }
            }
        }
        stage('Deploy to Environment') {
            steps {
                script {
                    echo "Deploying to ${params.ENVIRONMENT.toUpperCase()} environment..."
                    if (params.ENVIRONMENT == 'uat') {
                        echo "Running UAT-specific deployment..."
                    } else if (params.ENVIRONMENT == 'lt') {
                        echo "Running LT-specific deployment..."
                    } else if (params.ENVIRONMENT == 'prod') {
                        echo "Running PROD-specific deployment..."
                    }
                }
            }
        }
    }
}