node("gcloud") {
    
    environment {
        GCLOUD_KEY = credentials('gcp-terraform-auth')
    }
    parameters {
        string(name: 'GCLOUD_PROJECT_ID')
    }
    stage('Clone') {
        // Clone the configuration repository
        cleanWs()
        git branch: 'main', 
            url: 'https://github.com/almacro/tf-newdemo.git'
        sh script: 'mkdir -p creds'
        sh script: 'echo $GCLOUD_KEY | base64 -d > ./creds/serviceaccount.json'
        sh script: "printf '%s = \"%s\"\n' 'project' ${params.GCLOUD_PROJECT_ID} > ./ci.auto.tfvars"
    }
    stage('Download') {
        // Download Terrform
        sh label: '', 
           script: 'curl https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip \
            --output terraform_0.12.31_linux_amd64.zip \
             && unzip terraform_0.12.31_linux_amd64.zip'
    }
    stage('Backend-Init') {
        // Initialize the Terraform configuration
        dir('./remote_resources') {
            sh script: '../terraform init -input=false'
        }
    }
    stage('Backend-Plan') {
        // Create Terraform plan for backend resources
            dir('./remote_resources') {
                sh script: 'ls -l ..'
                sh script: '../terraform plan \
                -out backend.tfplan \
                -var-file=../ci.auto.tfvars'
            }
    }
    stage('Destroy') {
        input 'Destroy?'
            dir('./remote_resources') {
                sh script: '../terraform destroy \
                -auto-approve \
                -var-file=../ci.auto.tfvars'
            }
    }
}