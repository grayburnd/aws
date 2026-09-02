terraform {
  backend "s3" {
    bucket       = "tf-state-632988741882"
    key          = "aws"
    region       = "us-east-1"
    use_lockfile = true
  }
}
