node("gcloud") {
    /*
    environment {
        GCLOUD_KEY = credentials('gcp-terraform-auth')
    }
    */
    stage('Clone') {
        // Clone the configuration repository
        cleanWs()
        git branch: 'main', 
            url: 'https://github.com/almacro/tf-newdemo.git'
    }
    stage('Download') {
        // Download Terrform
        sh label: '', 
           script: 'curl https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip \
            --output terraform_0.12.29_linux_amd64.zip \
             && unzip terraform_0.12.29_linux_amd64.zip'
    }
    stage('Backend-Init') {
        // Initialize the Terraform configuration
        dir('./remote_resources') {
            sh script: '../terraform init -input false'
        }
    }
    stage('Backend-Plan') {
        // Create Terraform plan for backend resources
        withCredentials([string(credentialsId: 'gcp-terraform-auth', variable: 'GCLOUD_KEY')]) {
            dir('./remote_resources') {
                sh("gcloud auth activate-service-account --key-file=$GCLOUD_KEY")
                sh script: '../terraform plan \
                -out backend.tfplan'
            }
        }
    }
    stage('Destroy') {
        input 'Destroy?'
        withCredentials([string(credentialsId: 'gcp-terraform-auth', variable: 'GCLOUD_KEY')]) {
            dir('./remote_resources') {
                sh("gcloud auth activate-service-account --key-file=$GCLOUD_KEY")
                sh script: '../terraform destroy -auto-approve'
            }
        }
    }
}