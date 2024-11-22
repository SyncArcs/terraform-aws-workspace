variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

# Workspaces directory settings
variable "enable_internet_access" {
  type        = bool
  description = "(optional) Whether workspace virtual desktops should have internet access. Note that a VPC internet gateway is not required."
  default     = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "VPC Subnet IDs to create workspaces in"
}

variable "enable_workspace" {
  type        = bool
  default     = false
  description = "Flag to control the module creation."
}

variable "vpc_settings" {
  type        = map(string)
  default     = {}
  description = "(Required for SimpleAD and MicrosoftAD) VPC related information about the directory. Fields documented below."

}

variable "connect_settings" {
  type        = map(string)
  default     = {}
  description = "(Required for ADConnector) Connector related information about the directory. Fields documented below."

}

variable "ad_name" {
  default     = "corp.example.com"
  type        = string
  description = " The fully qualified name for the directory, such as corp.example.com"
}

variable "ad_password" {
  default     = "xyzsf58f5fqar"
  type        = string
  description = "The password for the directory administrator or connector user."
  sensitive   = true
}

variable "ad_size" {
  default     = "Small"
  type        = string
  description = "The size of the directory (Small or Large are accepted values)."
}

variable "ip_whitelist" {
  default     = ["103.59.207.249/32"]
  type        = list(string)
  description = "List of IP's to for whitelist"
}

variable "custom_policy" {
  default     = ""
  type        = string
  description = "Custom policy ARN"
}


variable "change_compute_type" {
  default     = true
  type        = bool
  description = "Whether WorkSpaces directory users can change the compute type (bundle) for their workspace."
}

variable "increase_volume_size" {
  default     = true
  type        = bool
  description = "Whether WorkSpaces directory users can increase the volume size of the drives on their workspace."
}

variable "rebuild_workspace" {
  default     = true
  type        = bool
  description = "Whether WorkSpaces directory users can rebuild the operating system of a workspace to its original state."
}

variable "restart_workspace" {
  default     = true
  type        = bool
  description = "Whether WorkSpaces directory users can restart their workspace."
}

variable "switch_running_mode" {
  default     = true
  type        = bool
  description = "Whether WorkSpaces directory users can switch the running mode of their workspace."
}

variable "device_type_android" {
  default     = "ALLOW"
  type        = string
  description = " Indicates whether users can use Android devices to access their WorkSpaces."
}

variable "device_type_linux" {
  default     = "ALLOW"
  type        = string
  description = " Indicates whether users can use Linux devices to access their WorkSpaces."
}

variable "device_type_chromeos" {
  default     = "ALLOW"
  type        = string
  description = "Indicates whether users can use Chromebooks to access their WorkSpaces."
}

variable "device_type_ios" {
  default     = "ALLOW"
  type        = string
  description = "Indicates whether users can use iOS devices to access their WorkSpaces."
}

variable "device_type_osx" {
  default     = "ALLOW"
  type        = string
  description = "Indicates whether users can use macOS clients to access their WorkSpaces."
}

variable "device_type_web" {
  default     = "ALLOW"
  type        = string
  description = "Indicates whether users can access their WorkSpaces through a web browser."
}

variable "device_type_windows" {
  default     = "ALLOW"
  type        = string
  description = "Indicates whether users can use Windows clients to access their WorkSpaces."
}

variable "device_type_zeroclient" {
  default     = "ALLOW"
  type        = string
  description = "Indicates whether users can use zero client devices to access their WorkSpaces."
}

variable "enable_maintenance_mode" {
  default     = true
  type        = bool
  description = "Indicates whether maintenance mode is enabled for your WorkSpaces."
}

variable "user_enabled_as_local_administrator" {
  default     = true
  type        = bool
  description = "Indicates whether users are local administrators of their WorkSpaces."
}

variable "type" {
  default     = "SimpleAD"
  type        = string
  description = "The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values)."
}

variable "enable_sso" {
  default     = false
  type        = bool
  description = "Whether to enable single-sign on for the directory. Requires alias."
}

variable "alias" {
  default     = ""
  type        = string
  description = "The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values)."
}

variable "description" {
  default     = "Workspace Active Directory"
  type        = string
  description = "A textual description for the directory."
}

variable "short_name" {
  default     = "CORP"
  type        = string
  description = "The short name of the directory, such as CORP."
}

variable "edition" {
  default     = "Standard"
  type        = string
  description = "The MicrosoftAD edition (Standard or Enterprise)."
}

variable "workspaces" {
  description = "Map of workspace configurations."
  type = map(object({
    user_name                                 = string
    bundle_id                                 = string
    root_volume_encryption_enabled            = optional(bool, false)
    user_volume_encryption_enabled            = optional(bool, false)
    volume_encryption_key                     = optional(string, null)
    compute_type_name                         = optional(string, "VALUE")
    user_volume_size_gib                      = optional(number, 10)
    root_volume_size_gib                      = optional(number, 80)
    running_mode                              = optional(string, "AUTO_STOP")
    running_mode_auto_stop_timeout_in_minutes = optional(number, 60)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "relay_state_parameter_name" {
  description = "The relay state parameter name supported by the SAML 2.0 identity provider (IdP)."
  type        = string
  default     = "RelayState"
}

variable "status" {
  description = "Status of SAML 2.0 authentication."
  type        = string
  default     = "DISABLED"
}

variable "user_access_url" {
  description = "The SAML 2.0 identity provider (IdP) user access URL."
  type        = string
  default     = "https://idp.example.com/saml" # Replace with your actual URL
}

variable "force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it."
  type        = bool
  default     = false
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) for the specified role."
  type        = number
  default     = 3600 # 1 hour
}

variable "path" {
  description = "Path to the role."
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = ""
}