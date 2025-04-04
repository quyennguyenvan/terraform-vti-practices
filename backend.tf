terraform {
  backend "s3" {
    bucket = "quyennvdotcomtfpractices"
    key    = "dev-tf.tfstate"
    region = "ap-southeast-1"
  }
}
