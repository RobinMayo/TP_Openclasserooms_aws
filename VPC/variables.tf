#### region specification
variable region {
  default = "eu-west-1"
}


#### global variables used for all ressources
variable application {
  default = "tp_openclasserooms"
}

variable environment {
  default = "d2si"
}

variable owner {
  default = "robin"
}

#### 01_vpc
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "cidr_public" {
  default = "0.0.0.0/0"
}

#### subnet calcul

variable "netbits" {
  default = "8"
}

variable "public_networks_prefix" {
  default = "0"
}

variable "private_networks_prefix" {
  default = "100"
}

# specify availability zones for subnets creation
variable "azs" {
  default = "eu-west-1a,eu-west-1b"
}

variable "map_public_ip_on_launch" {
  default = "true"
}

### EC2

variable "protocol" {
  default = "TCP"
}

variable "default_port" {
  default = "22"
}
