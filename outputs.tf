output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_id" {
  value = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  value = aws_subnet.public[*].arn
}

output "public_subnet_cidr" {
  value = aws_subnet.public[*].cidr_block
}