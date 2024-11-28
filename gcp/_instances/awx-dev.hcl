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
  machine_type   = "e2-custom-8-20480"
  description    = "AWX Instance"
  image_family   = "mycompany-standard-awx"
  image_project  = "myproject"
  boot_disk_size = 50
  tags           = ["myorg", "internet", "all-ingress", "lb-healthcheck"]
  labels = {
    app        = "awx"
    prometheus = "true"
    creator    = "terraform"
    env        = "developer"
  }
  service_account = {
    email  = dependency.service-account.outputs.service_accounts_map["awx"].email
    scopes = ["cloud-platform"]
  }
  metadata = {
    startup-script = file("_startup-scripts/ansible-playbook.sh")
    app            = "awx"
    app_registry   = "gcr"
    app_cert       = "myapp.example.com"
  }
  public_ip         = false
  snapshot_schedule = dependency.snapshot-scheduler.outputs.scheduler-name
}
