resource "aws_vpc" "VPC_from_Tf" {
  cidr_block = "10.0.0.0/26"

  tags = {
    Name = "VPC_from_Tf"

  }
}

resource "aws_subnet" "Pub_subnet" {
  vpc_id = aws_vpc.VPC_from_Tf.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-west-1c"

  tags = {
    Name = "Public_Sub"
}
}

resource "aws_key_pair" "private_key" {
  key_name = "my_private_key"
  public_key = file("/root/.ssh/id_rsa.pub")
}

resource "aws_instance" "FirstInstance" {
  ami = "ami-061ad72bc140532fd"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Pub_subnet.id
  key_name = aws_key_pair.private_key.key_name

  tags = {
    Name = "TerraformInstance"
  }
}
