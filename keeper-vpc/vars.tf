variable "region" {
  type        = string
  description = "The Amazon region."
}

variable "cidr_block" {
  default = "10.1.1.0/24"
}

variable "public_cidr_width" {
  default = 8
}

variable "enable_nat_iam_setup" {
  default = 0
}

variable "gateway" {
  default = "1.1.1.1"
}
