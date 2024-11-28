terraform {
  source = "${local.base_source_url}?ref=v0.3.1"
}

dependency "snapshot-scheduler" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/snapshot-policy/default-no-vss"
}

dependency "service-account" {
  config_path = "${dirname(find_in_parent_folders("common.hcl"))}/iam/serviceaccounts/automation"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-compute-engine.git//modules//single_instance"
  base_name       = "${lower(element(split("/", get_original_terragrunt_dir()), length(split("/", get_original_terragrunt_dir())) - 1))}"
}

inputs = {
  instance_name  = local.base_name
  boot_disk_name = local.base_name
  image_family   = "mycompany-standard-ubuntu-master"
  image_project  = "myproject"
  boot_disk_size = 30
  tags           = ["myorg", "internet", "all-ingress"]
  labels = {
    app        = "redis"
    prometheus = "true"
    creator    = "terraform"
  }
  additional_disks = [
    {
      name        = "${local.base_name}-data-disk"
      type        = "pd-ssd"
      size        = "20"
      description = null
      labels      = {}
    }
  ]
  service_account = {
    email  = dependency.service-account.outputs.service_accounts_map["redis"].email
    scopes = ["cloud-platform"]
  }
  metadata = {
    startup-script = file("_startup-scripts/ansible-playbook.sh")
    app            = "redis"
  }
  public_ip         = false
  snapshot_schedule = dependency.snapshot-scheduler.outputs.scheduler-name
}
