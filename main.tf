resource "aws_directory_service_directory" "main" {
  name        = var.ad_name
  password    = var.ad_password
  size        = var.ad_size
  type        = var.type
  alias       = var.alias
  enable_sso  = var.enable_sso
  description = var.description
  short_name  = var.short_name
  edition     = var.edition
  tags        = var.tags

  dynamic "vpc_settings" {
    for_each = length(keys(var.vpc_settings)) == 0 ? [] : [var.vpc_settings]

    content {
      subnet_ids = split(",", vpc_settings.value.subnet_ids)
      vpc_id     = vpc_settings.value.vpc_id
    }
  }

  dynamic "connect_settings" {
    for_each = length(keys(var.connect_settings)) == 0 ? [] : [var.connect_settings]

    content {
      customer_username = lookup(connect_settings.value, "customer_username", null)
      customer_dns_ips  = lookup(connect_settings.value, "customer_dns_ips", null)
      subnet_ids        = split(",", lookup(connect_settings.value, "subnet_ids", null))
      vpc_id            = lookup(connect_settings.value, "vpc_id", null)
    }
  }
  lifecycle {
    ignore_changes = [edition]
  }
}

locals {
  ip_rules = var.ip_whitelist
}

resource "aws_workspaces_ip_group" "ipgroup" {
  name        = format("ipgroup-%s-aws", var.name)
  description = var.description
  tags        = var.tags

  dynamic "rules" {
    for_each = local.ip_rules
    content {
      source = rules.value
    }
  }
}

resource "aws_workspaces_directory" "main" {

  directory_id = aws_directory_service_directory.main.id
  subnet_ids   = var.subnet_ids
  ip_group_ids = [
    aws_workspaces_ip_group.ipgroup.id,
  ]

  self_service_permissions {
    change_compute_type  = var.change_compute_type
    increase_volume_size = var.increase_volume_size
    rebuild_workspace    = var.rebuild_workspace
    restart_workspace    = var.restart_workspace
    switch_running_mode  = var.switch_running_mode
  }

  workspace_access_properties {
    device_type_android    = var.device_type_android
    device_type_chromeos   = var.device_type_chromeos
    device_type_ios        = var.device_type_ios
    device_type_osx        = var.device_type_osx
    device_type_web        = var.device_type_web
    device_type_windows    = var.device_type_windows
    device_type_zeroclient = var.device_type_zeroclient
    device_type_linux      = var.device_type_linux
  }

  workspace_creation_properties {
    enable_internet_access              = var.enable_internet_access
    enable_maintenance_mode             = var.enable_maintenance_mode
    user_enabled_as_local_administrator = var.user_enabled_as_local_administrator
  }

  saml_properties {
    relay_state_parameter_name = var.relay_state_parameter_name
    status                     = var.status
    user_access_url            = var.user_access_url
  }

  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access,
    aws_iam_role_policy_attachment.workspaces_custom_s3_access
  ]

  lifecycle {
    ignore_changes        = [subnet_ids] # Ignore changes to the subnet IDs
    create_before_destroy = true         # Create the new directory before destroying the old one
  }
}

data "aws_iam_policy_document" "workspaces" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "workspaces_default" {
  name                  = "workspaces_DefaultRole"
  assume_role_policy    = data.aws_iam_policy_document.workspaces.json
  description           = var.description
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  path                  = var.path
  permissions_boundary  = var.permissions_boundary
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "workspaces_default_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}

resource "aws_iam_role_policy_attachment" "workspaces_default_self_service_access" {
  role       = aws_iam_role.workspaces_default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}

resource "aws_iam_role_policy_attachment" "workspaces_custom_s3_access" {
  count      = var.custom_policy != "" ? 1 : 0
  role       = aws_iam_role.workspaces_default.name
  policy_arn = var.custom_policy
}

data "aws_workspaces_bundle" "bundle" {
  for_each  = var.workspaces
  bundle_id = each.value.bundle_id
}

resource "aws_workspaces_workspace" "workspace_ad" {
  for_each = var.enable_workspace ? var.workspaces : {}

  directory_id                   = join("", aws_workspaces_directory.main[*].id)
  bundle_id                      = data.aws_workspaces_bundle.bundle[each.key].id
  user_name                      = each.value.user_name
  root_volume_encryption_enabled = each.value.root_volume_encryption_enabled
  user_volume_encryption_enabled = each.value.user_volume_encryption_enabled
  volume_encryption_key          = each.value.volume_encryption_key

  workspace_properties {
    compute_type_name                         = each.value.compute_type_name
    user_volume_size_gib                      = each.value.user_volume_size_gib
    root_volume_size_gib                      = each.value.root_volume_size_gib
    running_mode                              = each.value.running_mode
    running_mode_auto_stop_timeout_in_minutes = each.value.running_mode_auto_stop_timeout_in_minutes
  }

  timeouts {
    create = "30m" # Timeout for resource creation
    update = "10m" # Timeout for resource update
    delete = "10m" # Timeout for resource deletion
  }

  depends_on = [
    aws_directory_service_directory.main,
    aws_iam_role.workspaces_default,
    aws_workspaces_directory.main,
  ]
}
