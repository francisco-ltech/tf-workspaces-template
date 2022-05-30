# Global variables definitions, e.g.: shared across all envs.

variable "location" {
  description = "The Azure region to deploy to."
  default     = ""
}

variable "default_tags" {
  description = "The default tags a resource will be deployed with."
  type        = map(any)
  default     = {}
}

variable "application" {
  description = "The name of the data/platform application."
  default     = ""
}

variable "environment" {
  description = "The name of the environment, e.g.: dev, test, prod."
  default     = ""
}
