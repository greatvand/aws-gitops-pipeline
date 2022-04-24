terraform {
  cloud {
    organization = "bits-utkarsh"

    workspaces {
      name = "bits-tf"
    }
  }
}