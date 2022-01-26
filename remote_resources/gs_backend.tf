# //////////////////////////////
# VARIABLES
# //////////////////////////////
variable "project" {}

variable "credentials_file" {
    default = "../creds/serviceaccount.json"
}

variable "region" {
    default = "us-west1"
}

variable "zone" {
    default = "us-west1-b"
}

variable "override_bucket_name" {
    default = ""
}

variable "storage_class" {
    default = "regional"
}

# //////////////////////////////
# LOCALS
# //////////////////////////////
locals {
  bucket_name = "${var.override_bucket_name != "" ? var.override_bucket_name : "${var.project}-tfstate"}"
}

# //////////////////////////////
# PROVIDER
# //////////////////////////////
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

# //////////////////////////////
# TERRAFORM USER
# //////////////////////////////
# (if needed)

# //////////////////////////////
# GS BUCKET
# //////////////////////////////
resource "google_storage_bucket" "backend-tfremotestate" {
    name = local.bucket_name
    
    location = upper(var.region)
    force_destroy = true
    storage_class = upper(var.storage_class)

    versioning {
        enabled = true
    }
}