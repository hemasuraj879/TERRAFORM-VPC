variable "vpc_cidr" {
  type = string
  description = "Please provide vpc cidr range"
  
}

variable "enable_dns_support" {
  type = bool
  description = "To enable/disable DNS support in the VPC."
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
  description = "To enable/disable DNS hostnames in the VPC"
  default = true
}

variable "common_tags" {
  type = map 
  description = "Please provide common tags for the resources"
  default = {}
}

variable "project_name" {
  type = string
  description = "Please provide project name"
  default = ""
}

variable "env" {
  type = string
  description = "Please provide env"
  default = ""
}

#SUBNET LEVEL VARIABLES
variable "public_cidr" {
  type = list 
  description = "Please provide cidr range for subnet"
  
}

variable "availability_zone" {
  type = list 
  description = "Please provide zones"
  default = []
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "Please provide whether true or false"
  default = true 
}

#PRIVATE SUBNET LEVEL CREATION
variable "private_cidr" {
  type = list 
  description = "Please provide cidr range for subnet"
  
}

variable "is_perring_req" {
  type = bool
  description = "Please provide true if peering is required"
  default = false
}


