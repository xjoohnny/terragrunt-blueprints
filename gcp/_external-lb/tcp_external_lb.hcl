terraform {
  source = "${local.base_source_url}?ref=stable"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-load-balancer.git//modules//lb-tcp-external"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
}

inputs = {
  name               = local.base_name
  enable_reserved_ip = true
}
