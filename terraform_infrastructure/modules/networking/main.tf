
# data "aws_availability_zones" "available" {}

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.0.0"

#   name = var.vpc_name

#   cidr = var.cidr_block_range
#   azs  = slice(data.aws_availability_zones.available.names, 0, 3)

#   private_subnets = var.public_subnets_cidr
#   public_subnets  = var.private_subnets_cidr

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true
#   enable_dns_support   = var.dns_allowed


#   public_subnet_tags = {
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#     "kubernetes.io/role/elb"                      = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#     "kubernetes.io/role/internal-elb"             = 1
#   }

#    tags = {
#     Environment = "${var.environment}"
#     Name = "${var.vpc_name}-vpc"
#   }
# }




 resource "aws_vpc" "projectVPC" {
   cidr_block           = var.cidr_block_range
   enable_dns_hostnames = var.hostnames_enabled
   enable_dns_support   = var.dns_allowed

   tags = {
     Environment = var.environment
     Name = var.vpc_name

  #    public_subnet_tags = {
  #   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  #   "kubernetes.io/role/elb"                      = 1
  #   }

  #   private_subnet_tags = {
  #   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  #   "kubernetes.io/role/internal-elb"             = 1
  #  }

  #    public_subnet_tags = {
  #     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  #     "kubernetes.io/role/elb"                      = 1
  #   }

  #    private_subnet_tags = {
  #    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  #    "kubernetes.io/role/internal-elb"             = 1
  #  }
                        
 }  
}

resource "aws_subnet" "public-subnets" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.projectVPC.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet-${var.environment}-${count.index + 1}"

    Environment = "${var.environment}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id            = aws_vpc.projectVPC.id
  count             = length(var.private_subnets_cidr)
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name        = "Private Subnet-${var.environment}-${count.index + 1}"
    Environment = "${var.environment}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"   =  1
  }
}

resource aws_internet_gateway "proj-igw" {
  vpc_id = aws_vpc.projectVPC.id

   tags = {
    Name        = "${var.environment}-project-igw"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.projectVPC.id
     route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.proj-igw.id

 }
    tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_association" {
  count = length(aws_subnet.public-subnets[*])
  route_table_id = aws_route_table.publicRT.id
  subnet_id = aws_subnet.public-subnets[count.index].id
}

resource "aws_route" "public_internet_gateway" {
 route_table_id         = aws_route_table.publicRT.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id             = aws_internet_gateway.proj-igw.id
}

resource "aws_eip" "nat-eip" {
  count                     = length(var.availability_zones)
}

resource "aws_nat_gateway" "nat-gateway" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.nat-eip[count.index].id
  connectivity_type = var.connectivity_type
  subnet_id         = aws_subnet.public-subnets[count.index].id
  tags = {
    Name = "${var.environment}-nat-gateway-${count.index + 1}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "privateRT" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.projectVPC.id
   route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.nat-gateway[count.index].id
  }
  tags = {
    
    Name        = "${var.environment}-private-route-table-${count.index+1}"
    Environment = "${var.environment}"
  }
}

# resource "aws_route" "private_nat_gateway" {
#   route_table_id         = aws_route_table.privateRT.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat-gateway.id
# }

resource "aws_route_table_association" "private" {
  count  = length(var.private_subnets_cidr)
  route_table_id = aws_route_table.privateRT[count.index].id
  subnet_id = aws_subnet.private-subnets[count.index].id

}









