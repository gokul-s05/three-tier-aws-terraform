variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_app_subnet_ids" {
  type = list(string)
}

variable "app_instance_type" {
  type = string
}

variable "app_min_size" {
  type = number
}

variable "app_max_size" {
  type = number
}

variable "app_desired_capacity" {
  type = number
}
