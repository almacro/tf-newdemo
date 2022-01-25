node("gcloud") {
    stage('Clone') {
        // Clone the configuration repository
        cleanWs()
        git branch: 'main', 
            url: 'https://github.com/almacro/tf-newdemo.git'
    }
    stage('Backend-Init') {
        // Initialize the Terraform configuration
        dir('remote_resources') {
            sh script: 'terraform init -input false'
        }
    }
    stage('Backend-Plan') {
        // Create Terraform plan for backend resources
        withCredentials([string(credentialsId: 'gcp-terraform-auth', variable: 'GCLOUD_KEY')]) {
            dir('remote_resources') {
                sh("gcloud auth activate-service-account --key-file=${GCLOUD_KEY}")
                sh script: 'terraform plan \
                -out backend.tfplan'
            }
        }
    }
    stage('Destroy') {
        input 'Destroy?'
        withCredentials([string(credentialsId: 'gcp-terraform-auth', variable: 'GCLOUD_KEY')]) {
            dir('remote_resources') {
                sh("gcloud auth activate-service-account --key-file=${GCLOUD_KEY}")
                sh script: 'terraform destroy -auto-approve'
            }
        }
    }
}