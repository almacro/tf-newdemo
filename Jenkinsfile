node("gcloud") {
    
    environment {
        GCLOUD_KEY = credentials('gcp-terraform-auth')
        GOOGLE_APPLICATION_CREDENTIALS = "creds/serviceaccount.json"
    }

    stage('Clone') {
        // Clone the configuration repository
        cleanWs()
        git branch: 'main', 
            url: 'https://github.com/almacro/tf-newdemo.git'
        sh script: 'mkdir -p creds'
        sh script: 'echo $GCLOUD_KEY | base64 -d > creds/serviceaccount.json'
        sh script: "printf '%s = \"%s\"\n' 'project' $params.GCLOUD_PROJECT_ID > ./ci.auto.tfvars"
        sh script: "sudo gcloud config set project $GCLOUD_PROJECT_ID"

    }
    stage('Download') {
        // Download Terrform
        sh label: '', curl https://mirror/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip \
            --output terraform_0.12.31_linux_amd64.zip 
           script: '\
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
            sh script: 'sudo ../terraform plan \
            -out backend.tfplan \
            -var-file=../ci.auto.tfvars && \
            sudo chown jenkins:jenkins backend.tfplan'
            stash includes: 'backend.tfplan', name: 's1'
        }
    }
    stage('Backend-Apply') {
        dir('./remote_resources') {
            unstash 's1'
            sh script: 'sudo ../terraform apply backend.tfplan'
        }
    }
    stage('Config-Init') {
        dir('.') {
            sh script: 'sudo ./terraform init \
                -backend-config="bucket=$GCLOUD_PROJECT_ID-tfstate" \
                -backend-config="prefix=terraform/state" \
                -backend-config="region=us-west1" \
                -input=false'
       }
    }
    stage('Config-Plan') {
        // Generate Terraform plan
        dir('.') {
            sh script: 'sudo ./terraform plan \
            -out s1.tfplan \
            -var-file=./ci.auto.tfvars && \
            sudo chown jenkins:jenkins s1.tfplan'
        }
    }
    /*
TODO add in backend-apply and main config stages
    */
    stage('Destroy') {
        input 'Destroy?'
            dir('.') {
                sh script: 'sudo ./terraform destroy \
                -auto-approve \
                -var-file=./ci.auto.tfvars'
            }
            dir('./remote_resources') {
                sh script: 'sudo ../terraform destroy \
                -auto-approve \
                -var-file=../ci.auto.tfvars'
            }
    }
}