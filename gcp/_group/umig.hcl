terraform {
  source = "${local.base_source_url}?ref=v0.3.0"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-compute-engine.git//modules//umig"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
}

inputs = {
  name = local.base_name
}
