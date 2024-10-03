variable "cluster_name" {
  default = "magoya-test"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ingress_port" {
  type    = list(number)
  default = [80, 8080, 443]

}
variable "egress_port" {
  type    = list(number)
  default = [80, 80, 443]

}
variable "s3bucket_state" {
  type    = string
  default = "bucket-state"
}
