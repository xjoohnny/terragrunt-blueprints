terraform {
  source = "${local.base_source_url}?ref=v0.0.5"
}

locals {
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-compute-engine.git//modules//disks"
}

dependency "snapshot-scheduler" {
  config_path = "${get_terragrunt_dir()}/../../snapshot-policy/default"
}

inputs = {
  snapshot_schedule = dependency.snapshot-scheduler.outputs.scheduler-name
}
