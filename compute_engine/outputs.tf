/*
Uploads a local file to GCS and reads its content.
Afterwards, it displays the content of the file and
outputs it to the root module.
*/

resource google_storage_bucket_object "data-source" {
  name   = "data_source.txt"
  source = "data/data_source.txt"
  bucket = var.bucket_name
}

data "google_storage_bucket_object_content" "data-source" {
  name   = "data_source.txt"
  bucket = var.bucket_name
  depends_on = [google_storage_bucket_object.data-source]
}

output "data-source" {
  value = data.google_storage_bucket_object_content.data-source.content
}
