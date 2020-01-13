variable "environment" {
  description = "A logical name that will be used as prefix and tag for the created resources."
  type        = string
  default     = "sg-dev"
}

# number of from_ports should be equal to number of to_ports
variable "tcp_from_ports" {
  default = "default_null"
}

variable "tcp_to_ports" {
  default = "default_null"
}

variable "udp_from_ports" {
  default = "default_null"
}

variable "udp_to_ports" {
  default = "default_null"
}

variable "cidrs" {
  type = list(string)
}

variable "security_group_name" {
}

variable "vpc_id" {
}

