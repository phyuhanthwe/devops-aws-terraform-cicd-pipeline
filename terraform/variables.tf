variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "prefix" {
  type    = string
  default = "demo"
}

variable "az" {
  type    = string
  default = "ap-southeast-1a"
}

variable "my-ip" {
  description = "Your public IP address"
  type        = string
}

# variable "bucket-name" {
#   type    = string
#   default = "ph-demo-bucket01"
# }