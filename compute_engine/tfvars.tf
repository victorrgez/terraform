/*
All these variables are required and will be passed the default values from the root module.
However, they can be overriden if necessary
*/

variable "default_vars" {
    type = map(string)
}

variable "available_regions" {
    type = list(string)
}

variable "vpc_internal_ip_ranges" {
    type = map(list(string))
}

variable "project_id" {
    type = string
}

variable "region" {
    type = string
}

variable "zone" {
    type = string
}

variable "deletion_protection" {
    type = bool
}

variable "network" {
    type = string
}

variable "subnetwork" {
    type = string
}

/*
"We don't care about the value of the following variables,
but we need these resources to be created.
Used to propagate dependencies between parent and child modules"
*/

variable "proxy_only_subnet" {
    description = "subnet for proxy must have been created already"
    type = string
}

variable "docker_repository" {
    description = "docker-repository must have been created already"
    type = string
}