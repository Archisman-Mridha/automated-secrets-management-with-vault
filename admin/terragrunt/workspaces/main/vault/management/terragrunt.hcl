include {
    path = find_in_parent_folders( )
}

remote_state {
    backend = "local"
    config = { }

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

terraform {
    source = "${path_relative_from_include( )}/modules/vault/management//"
}

generate "vault_provider" {
    path = "vault.provider.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF

        provider "vault" {
            address = "http://127.0.0.1:8200"
            token = "s.Ph9ftGon2uew9XVviPsbvb1a"
        }

    EOF
}

locals {
    project_root_path = "${path_relative_from_include( )}/.."
}

inputs = {
    aws_region = file("${local.project_root_path}/credentials/aws/region")

    aws_access_key = file("${local.project_root_path}/credentials/aws/access_key")
    aws_secret_key = file("${local.project_root_path}/credentials/aws/secret_key")
}