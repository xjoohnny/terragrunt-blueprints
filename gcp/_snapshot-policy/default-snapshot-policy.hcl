terraform {
  source = "${local.base_source_url}?ref=v0.3.0"
}

locals {
  env_vars        = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region          = local.env_vars.locals.region
  base_source_url = "git::git@github.com:myorg/mycompany-infra-terraform-modules-gcp-compute-engine.git//modules//scheduler-policy"
}

inputs = {
  snapshot_retention_policy = {
    max_retention_days    = 7
    on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
  }

  snapshot_schedule = {
    daily_schedule = {
      days_in_cycle = 1
      start_time    = "04:00"
    }
    hourly_schedule = null
    weekly_schedule = null
  }
  snapshot_properties = {
    guest_flush       = false
    storage_locations = [local.region]
    labels = {
      creator = "terraform"
      vss     = "false"
    }
  }
}
