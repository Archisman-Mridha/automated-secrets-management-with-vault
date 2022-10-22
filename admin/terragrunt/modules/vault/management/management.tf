//* authentication backend

resource "vault_github_auth_backend" "github_auth_backend" {
    path = "github"
    organization = "insta-cloned"
    description = "github authentication backend"

    tune {
        default_lease_ttl = "48h"
        token_type = "service" // vault persists service tokens and these tokens can be renewed
    }
}

//* aws secrets engine

resource "vault_aws_secret_backend" "aws_secret_backend" {
    path = "aws"
    description = "aws secrets engine"

    default_lease_ttl_seconds = 172800

    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
}

//* user

resource "vault_policy" "github_user_archi_policy" {
    name = local.github_user_archi_policy_name

    policy = file("./policies/archi.policy.hcl")
}

resource "vault_github_user" "github_user_archi" {
    backend = vault_github_auth_backend.github_auth_backend.id
    user = "Archisman-Mridha"

    policies = [ local.github_user_archi_policy_name ]
}

resource "vault_aws_secret_backend_role" "github_user_archi_aws_secret_backend_role" {
    backend = vault_aws_secret_backend.aws_secret_backend.path
    name = "project_admin"
    credential_type = "iam_user"

    policy_document = <<EOT

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": "*",
                    "Resource": "*"
                }
            ]
        }

    EOT
}

//* locals

locals {
    github_user_archi_policy_name = "github_user_archi_policy"
}

//* variables

variable "aws_access_key" {
    type = string
}

variable "aws_secret_key" {
    type = string
}

variable "aws_region" {
    type = string
}