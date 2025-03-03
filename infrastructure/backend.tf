# terraform {
#   backend "s3" {
#     bucket = "shadrack-terraform-state-bucket"  # Replace with your bucket name
#     key    = "terraform.tfstate"           # Path to the state file in the bucket
#     region = "us-east-1"                   # Region of the bucket
#   }
# }