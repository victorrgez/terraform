locals {
    /*
    The way it is currently defined, the `default_vars` in locals will override any variable
    from variables.tf with the same name.
    If we do the merge in the oposite direction, we can override local configuration
    with the hypothetic organisation policy established by the centralised vars file
    */
    default_vars = merge (var.default_vars, {
        
        "default_disk_type" = "pd-standard"
        "default_disk_size" = 100
        "default_machine_type" = "n1-standard-1"
        "default_ubuntu_image" = "ubuntu-1804-bionic-v20221018"
    })

    /*
    In variables.tf, we define all the available_regions in the Sandbox environment.
    In locals.tf, we filter them to use only the ones in USA and Europe
    */
    allowed_regions = [ for region in var.available_regions : region if startswith(region, "us") || startswith (region, "eu") ]
    project_id = "<PROJECT_ID>"
    region = "europe-west1" 
    zone = "europe-west1-b"
    deletion_protection = true
}