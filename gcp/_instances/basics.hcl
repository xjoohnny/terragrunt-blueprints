terraform {
  source = "${local.base_source_url}?ref=v0.3.5"
}

dependency "snapshot-scheduler" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/snapshot-policy/default-no-vss"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-compute-engine.git//modules//single_instance"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
}

inputs = {
  instance_name  = local.base_name
  boot_disk_name = local.base_name
  tags           = ["myorg", "internet"]
  labels = {
    creator = "terraform"
    manager = "atlantis"
  }
  public_ip         = false
  snapshot_schedule = dependency.snapshot-scheduler.outputs.scheduler-name
}
