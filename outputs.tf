output "data-source" {
  /*
  Displays the content of output variable from compute_engine module,
  which is the content of a file uploaded to GCS inside the module.
  May need to run `terraform refresh` for the output not be empty
  the first time the file is uploaded to GCS
  */
  value = module.compute_engine.data-source
}

output "myvar" {
  value = var.myvar
}