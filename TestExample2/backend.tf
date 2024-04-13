terraform {
  backend "s3" {
    bucket         = "chutney-test-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"  # Specify the region of your S3 bucket
    encrypt        = true          # Optional: Enable encryption of state file
  }
}

resource "aws_instance" "example" {
  ami           = "${lookup(var.ami_id, var.region)}"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
tags = {
  Name = "Backend_VM"
}
}

