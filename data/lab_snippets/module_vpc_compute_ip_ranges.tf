/*
Objective:
Be able to create a module that will allocate automatically the ranges for subnets based on
CIDR_RANGE for the whole VPC and the subnet_size. We will allocate subnets in a couple of regions
Odd count.index go to one region and even count.index go to the other one.
Based on whether it is dev or pro, we allocate more or less subnets
*/

/* MAIN CODE:

module "vpc" {
    source = "./vpc"
    environment = var.environment
    cidr_range = var.cidr_range
    regions = var.regions
    subnet_size = var.subnet_size
    network = google_compute_network.lab.id
}

*/


/* vpc MODULE CODE:

variable "environment" {
    type = string
}

variable "cidr_range" {
    type = string
}

variable "regions" {
    type = list(string)
}

variable "subnet_size" {
    type = number
}

variable "network" {
    type = string
}

locals {
    split_cidr = split("/", var.cidr_range)
    cidr_size = tonumber(element(local.split_cidr, length(local.split_cidr)-1))
    newbits = var.subnet_size - local.cidr_size
}

resource "google_compute_subnetwork" "labsubnets"{
  count = var.environment == "pro" ? 5 : 2
  name          = "labsubnet-${count.index}-${terraform.workspace}"
  ip_cidr_range = cidrsubnet(var.cidr_range, local.newbits, count.index)
  region        = var.regions[count.index % 2]
  network       = var.network
}

*/