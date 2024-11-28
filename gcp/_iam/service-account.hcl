terraform {
  source = "${local.base_source_url}?ref=v0.0.2"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-iam.git//modules//serviceaccounts"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
}

inputs = {
  suffix       = local.base_name
  display_name = "Contas ${local.base_name}"
  description  = "Gerenciada por Atlantis"
}
