variable "vpc_name" {
  description = "A unique name for the VPC"
  type = string
}

variable "cidr_blocks" {
  default = {
    vpc_cidr = "10.0.0.0/16"
  }
  type = object(
    {
      vpc_cidr = string
    }
  )
}
