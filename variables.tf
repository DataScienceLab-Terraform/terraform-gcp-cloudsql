variable "db_version" {
  description = "The version of the database."
  type        = string
}

variable "name" {
  description = "The name of the cloudSQL database instance."
  type        = string
}

variable "region" {
  description = "The region where the database instance will be created."
  type        = string
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network that connects to the cloudSQL database instance"
}

variable "network_id" {
  type        = string
  description = "The id of the VPC network that connects to the cloudSQL database instance"
}

variable "zone" {
  description = "The preferred compute engine zone"
  type        = string
}

variable "test" {
  description = "The preferred compute engine zone"
  type        = string
  default = "value"
}