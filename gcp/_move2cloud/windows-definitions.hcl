terraform {
  source = "${local.base_source_url}?ref=v0.3.4"
}

locals {
  env_vars        = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  project         = local.env_vars.locals.project
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-compute-engine.git//modules//single_instance"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
}

dependency "snapshot-scheduler" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/snapshot-policy/default-no-vss"
}

dependency "service-account" {
  config_path = "${dirname(find_in_parent_folders("common.hcl"))}/iam/serviceaccounts/robot"
}

inputs = {
  instance_name     = local.base_name
  tags              = ["internet", "windows", "mv2cloud"]
  snapshot_schedule = dependency.snapshot-scheduler.outputs.scheduler-name
  boot_disk_name    = "${local.base_name}-boot-disk"
  service_account = {
    email  = dependency.service-account.outputs.email
    scopes = ["cloud-platform"]
  }
  public_ip     = false
  image_family  = "mycompany-windows2019-v1"
  image_project = "myproject"
  labels = {
    creator = "terraform"
    manager = "atlantis"
    project = "move2cloud"
  }
  boot_disk_size = 100
  boot_disk_type = "pd-ssd"
  disk_labels = {
  }
}
