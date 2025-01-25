terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-multicloud-project"
    key            = "IAC-Multi-Cloud-Disaster-Recovery.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
