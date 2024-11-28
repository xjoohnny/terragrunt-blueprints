terraform {
  source = "${local.base_source_url}?ref=v0.0.2"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-storage.git//modules//bucket"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
  env_vars        = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region          = local.env_vars.locals.region
}

inputs = {
  bucket_name          = local.base_name
  bucket_location      = local.region
  bucket_force_destroy = false
  labels = {
    creator = "terraform"
    manager = "atlantis"
  }
}
