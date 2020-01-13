variable "environment" {
  description = "A logical name that will be used as prefix and tag for the created resources."
  type        = string
  default     = "elb-dev"
}

variable "elb_name" {
  description = "The name of the ELB"
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the ELB"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the ELB"
  type        = list(string)
}

variable "internal" {
  description = "If true, ELB will be an internal ELB"
  type        = bool
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle"
  type        = number
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining"
  type        = bool
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "listener" {
  description = "A list of listener blocks"
  type        = list(map(string))
}

variable "access_logs" {
  description = "An access logs block"
  type        = map(string)
  default     = {}
}

variable "health_check" {
  description = "A health check block"
  type        = map(string)
}
