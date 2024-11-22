# Terraform-aws-workspace
# Terraform AWS Cloud Workspace Modules
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#Examples)
- [Author](#Author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)


## Introduction
This Terraform module creates AWS Workspace along with additional configuration options.

## Usage
To use this module, include it in your Terraform configuration file and provide the required input variables. Below is an example of how to use the module:
# Examples:
# Example: vpc

```hcl
module "vpc" {
  source          ="git::https://github.com/SyncArcs/terraform-aws-vpc.git?ref=v1.0.0"
  name            = "vpc"
  environment     = "test"
  cidr_block      = "10.0.0.0/16"
  enable_flow_log = true
}
```

# Example: subnets

```hcl
module "subnets" {
  source              ="git::https://github.com/SyncArcs/terraform-aws-subnet.git?ref=v1.0.0"
  name                = "subnet"
  environment         = "workspace-subnet"
  availability_zones  = ["eu-west-1a", "eu-west-1b", ]
  vpc_id              = module.vpc.id
  type                = "public-private"
  nat_gateway_enabled = true
  single_nat_gateway  = true
  cidr_block          = module.vpc.vpc_cidr_block
  igw_id              = module.vpc.igw_id

}
```

# Example: workspace

```hcl
module "workspace" {
  sour      = "git::https://github.com/SyncArcs/terraform-aws-workspace.git?ref=v1.0.0"
  name      = "workspace"

  ##ad
  subnet_ids = module.subnets.private_subnet_id
  vpc_settings = {
    vpc_id     = module.vpc.id
    subnet_ids = join(",", module.subnets.private_subnet_id)
  }

  ad_name                             = "ad.workspace.com"
  ad_password                         = "xyz123@abc"
  ip_whitelist                        = ["0.0.0.0/0"]
  enable_internet_access              = true
  user_enabled_as_local_administrator = true

  ##workspace
  enable_workspace = true
  // first run terraform apply with enable_workspace = false and then create custom user names in workspace manually and specify here that username and re-run tf apply with enable_workspace = true so that workspace with custom-username gets created .

  workspaces = {
    workspace1 = {
      user_name = "admin"
      bundle_id = "wsb-208l8k46h"
    }
  }
}
```


You can customize the input variables according to your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/SyncArcs/terraform-aws-workspace/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **SyncArcs** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/SyncArcs/terraform-aws-workspace/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_directory_service_directory.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_iam_role.workspaces_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.workspaces_custom_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workspaces_default_self_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workspaces_default_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_workspaces_directory.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_directory) | resource |
| [aws_workspaces_ip_group.ipgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_ip_group) | resource |
| [aws_workspaces_workspace.workspace_ad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_workspace) | resource |
| [aws_iam_policy_document.workspaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_workspaces_bundle.bundle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/workspaces_bundle) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_name"></a> [ad\_name](#input\_ad\_name) | The fully qualified name for the directory, such as corp.example.com | `string` | `"corp.example.com"` | no |
| <a name="input_ad_password"></a> [ad\_password](#input\_ad\_password) | The password for the directory administrator or connector user. | `string` | `"xyzsf58f5fqar"` | no |
| <a name="input_ad_size"></a> [ad\_size](#input\_ad\_size) | The size of the directory (Small or Large are accepted values). | `string` | `"Small"` | no |
| <a name="input_alias"></a> [alias](#input\_alias) | The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). | `string` | `""` | no |
| <a name="input_change_compute_type"></a> [change\_compute\_type](#input\_change\_compute\_type) | Whether WorkSpaces directory users can change the compute type (bundle) for their workspace. | `bool` | `true` | no |
| <a name="input_connect_settings"></a> [connect\_settings](#input\_connect\_settings) | (Required for ADConnector) Connector related information about the directory. Fields documented below. | `map(string)` | `{}` | no |
| <a name="input_custom_policy"></a> [custom\_policy](#input\_custom\_policy) | Custom policy ARN | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | A textual description for the directory. | `string` | `"Workspace Active Directory"` | no |
| <a name="input_device_type_android"></a> [device\_type\_android](#input\_device\_type\_android) | Indicates whether users can use Android devices to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_chromeos"></a> [device\_type\_chromeos](#input\_device\_type\_chromeos) | Indicates whether users can use Chromebooks to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_ios"></a> [device\_type\_ios](#input\_device\_type\_ios) | Indicates whether users can use iOS devices to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_linux"></a> [device\_type\_linux](#input\_device\_type\_linux) | Indicates whether users can use Linux devices to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_osx"></a> [device\_type\_osx](#input\_device\_type\_osx) | Indicates whether users can use macOS clients to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_web"></a> [device\_type\_web](#input\_device\_type\_web) | Indicates whether users can access their WorkSpaces through a web browser. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_windows"></a> [device\_type\_windows](#input\_device\_type\_windows) | Indicates whether users can use Windows clients to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_device_type_zeroclient"></a> [device\_type\_zeroclient](#input\_device\_type\_zeroclient) | Indicates whether users can use zero client devices to access their WorkSpaces. | `string` | `"ALLOW"` | no |
| <a name="input_edition"></a> [edition](#input\_edition) | The MicrosoftAD edition (Standard or Enterprise). | `string` | `"Standard"` | no |
| <a name="input_enable_internet_access"></a> [enable\_internet\_access](#input\_enable\_internet\_access) | (optional) Whether workspace virtual desktops should have internet access. Note that a VPC internet gateway is not required. | `bool` | `true` | no |
| <a name="input_enable_maintenance_mode"></a> [enable\_maintenance\_mode](#input\_enable\_maintenance\_mode) | Indicates whether maintenance mode is enabled for your WorkSpaces. | `bool` | `true` | no |
| <a name="input_enable_sso"></a> [enable\_sso](#input\_enable\_sso) | Whether to enable single-sign on for the directory. Requires alias. | `bool` | `false` | no |
| <a name="input_enable_workspace"></a> [enable\_workspace](#input\_enable\_workspace) | Flag to control the module creation. | `bool` | `false` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether to force detaching any policies the role has before destroying it. | `bool` | `false` | no |
| <a name="input_increase_volume_size"></a> [increase\_volume\_size](#input\_increase\_volume\_size) | Whether WorkSpaces directory users can increase the volume size of the drives on their workspace. | `bool` | `true` | no |
| <a name="input_ip_whitelist"></a> [ip\_whitelist](#input\_ip\_whitelist) | List of IP's to for whitelist | `list(string)` | <pre>[<br>  "103.59.207.249/32"<br>]</pre> | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration (in seconds) for the specified role. | `number` | `3600` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_path"></a> [path](#input\_path) | Path to the role. | `string` | `"/"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `""` | no |
| <a name="input_rebuild_workspace"></a> [rebuild\_workspace](#input\_rebuild\_workspace) | Whether WorkSpaces directory users can rebuild the operating system of a workspace to its original state. | `bool` | `true` | no |
| <a name="input_relay_state_parameter_name"></a> [relay\_state\_parameter\_name](#input\_relay\_state\_parameter\_name) | The relay state parameter name supported by the SAML 2.0 identity provider (IdP). | `string` | `"RelayState"` | no |
| <a name="input_restart_workspace"></a> [restart\_workspace](#input\_restart\_workspace) | Whether WorkSpaces directory users can restart their workspace. | `bool` | `true` | no |
| <a name="input_short_name"></a> [short\_name](#input\_short\_name) | The short name of the directory, such as CORP. | `string` | `"CORP"` | no |
| <a name="input_status"></a> [status](#input\_status) | Status of SAML 2.0 authentication. | `string` | `"DISABLED"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | VPC Subnet IDs to create workspaces in | `list(string)` | n/a | yes |
| <a name="input_switch_running_mode"></a> [switch\_running\_mode](#input\_switch\_running\_mode) | Whether WorkSpaces directory users can switch the running mode of their workspace. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). | `string` | `"SimpleAD"` | no |
| <a name="input_user_access_url"></a> [user\_access\_url](#input\_user\_access\_url) | The SAML 2.0 identity provider (IdP) user access URL. | `string` | `"https://idp.example.com/saml"` | no |
| <a name="input_user_enabled_as_local_administrator"></a> [user\_enabled\_as\_local\_administrator](#input\_user\_enabled\_as\_local\_administrator) | Indicates whether users are local administrators of their WorkSpaces. | `bool` | `true` | no |
| <a name="input_vpc_settings"></a> [vpc\_settings](#input\_vpc\_settings) | (Required for SimpleAD and MicrosoftAD) VPC related information about the directory. Fields documented below. | `map(string)` | `{}` | no |
| <a name="input_workspaces"></a> [workspaces](#input\_workspaces) | Map of workspace configurations. | <pre>map(object({<br>    user_name                                 = string<br>    bundle_id                                 = string<br>    root_volume_encryption_enabled            = optional(bool, false)<br>    user_volume_encryption_enabled            = optional(bool, false)<br>    volume_encryption_key                     = optional(string, null)<br>    compute_type_name                         = optional(string, "VALUE")<br>    user_volume_size_gib                      = optional(number, 10)<br>    root_volume_size_gib                      = optional(number, 80)<br>    running_mode                              = optional(string, "AUTO_STOP")<br>    running_mode_auto_stop_timeout_in_minutes = optional(number, 60)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ad_id"></a> [ad\_id](#output\_ad\_id) | The concatenated ID(s) of the main AWS WorkSpaces directory, combining multiple IDs into a single string. |
| <a name="output_directory_dns_ip_addresses"></a> [directory\_dns\_ip\_addresses](#output\_directory\_dns\_ip\_addresses) | The DNS IP addresses of the created Directory Service Directory. |
| <a name="output_directory_id"></a> [directory\_id](#output\_directory\_id) | The ID of the created WorkSpaces directory. |
| <a name="output_directory_name"></a> [directory\_name](#output\_directory\_name) | The name of the created Directory Service Directory. |
| <a name="output_directory_service_id"></a> [directory\_service\_id](#output\_directory\_service\_id) | The ID of the Directory Service |
| <a name="output_saml_status"></a> [saml\_status](#output\_saml\_status) | The status of SAML 2.0 authentication. |
| <a name="output_user_access_url"></a> [user\_access\_url](#output\_user\_access\_url) | The user access URL for the SAML 2.0 identity provider (IdP). |
| <a name="output_workspaces_directory_id"></a> [workspaces\_directory\_id](#output\_workspaces\_directory\_id) | The ID of the WorkSpaces Directory |
| <a name="output_workspaces_ip_group_id"></a> [workspaces\_ip\_group\_id](#output\_workspaces\_ip\_group\_id) | The ID of the WorkSpaces IP Group |
<!-- END_TF_DOCS -->