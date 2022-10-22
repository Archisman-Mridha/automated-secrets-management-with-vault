remote_state {
    backend = "local"
    config = { }

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

generate "aws_provider" {
    path = "aws.provider.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF

        provider "aws" {
            region = "us-east-1"

            access_key = ""
            secret_key = ""

            default_tags {
                tags = {
                    project = "vault_tutorial"
                }
            }
        }

    EOF
}

locals {
    project_root_path = "${get_parent_terragrunt_dir( )}/.."

    aws_access_key = file("${local.project_root_path}/credentials/aws/access_key")
    aws_secret_key = file("${local.project_root_path}/credentials/aws/secret_key")
}