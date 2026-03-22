variable "region" {
  description = "The region to deploy resources in"
  type        = string
}

variable "zone" {
  description = "The zone to deploy resources in"
  type        = string
}

variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}