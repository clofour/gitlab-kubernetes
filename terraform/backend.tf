terraform {
    backend "s3" {
        bucket = "gitlab-tfstate-a2ca73"
        key = "terraform.tfstate"
        region = "us-east-1"
        endpoints = {
            s3 = "https://fra1.digitaloceanspaces.com"
        }

        skip_credentials_validation = true
        skip_metadata_api_check = true
        skip_requesting_account_id = true
    }
}