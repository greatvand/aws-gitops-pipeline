variable "vpc_cidr" {
  type    = string
  default = "10.123.0.0/16"
}

variable "main_instance_count" {
  type    = number
  default = 1
}