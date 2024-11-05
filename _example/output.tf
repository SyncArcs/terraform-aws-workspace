# Output for the VPC ID
output "vpc_id" {
  value       = module.vpc.id
  description = "The ID of the created VPC"
}

# Output for the Public Subnet IDs
output "public_subnet_ids" {
  value       = module.subnets.public_subnet_id
  description = "The IDs of the created public subnets"
}

# Output for the Private Subnet IDs
output "private_subnet_ids" {
  value       = module.subnets.private_subnet_id
  description = "The IDs of the created private subnets"
}

# Output for the Internet Gateway ID
output "igw_id" {
  value       = module.vpc.igw_id
  description = "The ID of the created Internet Gateway"
}

# Output for the WorkSpaces Directory ID
output "workspaces_directory_id" {
  value       = module.workspace.workspaces_directory_id
  description = "The ID of the WorkSpaces Directory"
}