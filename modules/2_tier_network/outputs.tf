output "public_subnet1_id" {
  value = aws_subnet.public1.id
}
output "public_subnet2_id" {
  value = aws_subnet.public2.id
}
output "private_subnet1_id" {
  value = aws_subnet.private1.id
}
output "private_subnet2_id" {
  value = aws_subnet.private2.id
}
output "public_subnet1_cidr" {
  value = aws_subnet.public1.cidr_block
}
output "public_subnet2_cidr" {
  value = aws_subnet.public2.cidr_block
}
output "private_subnet1_cidr" {
  value = aws_subnet.private1.cidr_block
}
output "private_subnet2_cidr" {
  value = aws_subnet.private2.cidr_block
}
output "nat_public_ip" {
  value = aws_eip.nat.public_ip
}
output "nat_private_ip" {
  value = aws_nat_gateway.nat.private_ip
}
output "nat_allocation_id" {
  value = aws_eip.nat.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
output "public_route_table_id" {
  value = aws_route_table.public.id
}
output "private_route_table_id" {
  value = aws_route_table.private.id
}
output "vpc_id" {
  value = aws_vpc.main.id
}
