variable "default_vars" {
    type = map(string)
    default = {
        "default_disk_type" = "pd-standard"
        "default_disk_size" = 100
        "default_machine_type" = "n1-standard-1"
    }
}

# all allowed_regions in the sandbox environment:
variable "allowed_regions" {
    type = list(string)
    default = [
        "europe-west1",
        "us-central1",
        "us-west1",
        "us-east1",
        "australia-southeast1"
    ]
}

variable "vpc_internal_ip_ranges" {
    type = map(list(string))
    default = {
        "primary" : [
            "10.1.0.0/16",
            "10.2.0.0/16",
            "10.3.0.0/16",
            "10.4.0.0/16",
            "10.5.0.0/16"
        ],
        "secondary": [
            "192.168.10.0/24",
            "192.168.11.0/24",
            "192.168.12.0/24",
            "192.168.13.0/24",
            "192.168.14.0/24"
        ]
    }
}