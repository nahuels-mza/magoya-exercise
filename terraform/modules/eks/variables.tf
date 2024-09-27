variable "cluster_name" {
  default = "magoya-testing"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "max_size_system_node" {
  default = 3
}
variable "desire_size_system_node" {
  default = 2
}
variable "max_size_app_node" {
  default = 2
}
variable "desire_size_app_node" {
  default = 1
}
