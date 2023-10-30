# Who is the cloud provider
provider "aws" {

# location of AWS
  region = var.aws-region

}
# To download required dependencies
# create a service/resource on the cloud - ec2 on AWS

resource "aws_instance" "app_instance" {
   ami = var.app_ami_id
   instance_type = var.instance_type
   subnet_id = aws_subnet.public_subnet.id
   tags = {
     Name = var.app_instance_name
   }

}

resource "aws_instance" "db_instance" {
   ami = var.db_ami_id
   instance_type = var.instance_type
   subnet_id = aws_subnet.private_subnet.id
   tags = {
     Name = var.db_instance_name
   }

}

# Define the VPC
resource "aws_vpc" "tech254-alex-2tier-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "tech254-alex-2tier-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.tech254-alex-2tier-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.tech254-alex-2tier-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "private-subnet"
  }
}

# Define the Internet Gateway
resource "aws_internet_gateway" "tech254-alex-vpc-ig" {
  vpc_id = aws_vpc.tech254-alex-2tier-vpc.id

  tags = {
    Name = "tech254-alex-vpc-ig"
  }
}

# Define the public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.tech254-alex-2tier-vpc.id

  tags = {
    Name = "public-route-table"
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Add a default route to the Internet Gateway in the public route table
resource "aws_route" "public_subnet_igw_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.tech254-alex-vpc-ig.id
}