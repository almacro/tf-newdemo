variable "project" {}

variable "credentials_file" {
    default = "./creds/serviceaccount.json"
}

variable "region" {
    default = "us-west1"
}

variable "zone" {
    default = "us-west1-b"
}