variable "vpc_id" {
  type    = string
  default = "vpc-00be732295c0453ad"
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80, 443]
}
