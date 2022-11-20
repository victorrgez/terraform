variable "zone" {
    type = string
}

variable "node-count" {
    type = number
    default = 1
}

variable "machine-type" {
    default = "g1-small"
}

variable "cluster-name" {
    type = string
}

variable "network" {
    type = string
}

variable "subnetwork" {
    type = string
}