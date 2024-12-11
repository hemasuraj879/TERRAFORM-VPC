resource "aws_vpc_peering_connection" "vpc" {
  count = var.is_perring_req ? 1 : 0
  peer_vpc_id   = aws_vpc.vpc.id # requestor
  vpc_id        = data.aws_vpc.default.id  #acceptor

  auto_accept   = true

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-peering-${var.env}"
    }
  )
}


resource "aws_route" "public_peering" {
  count = var.is_perring_req ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc[count.index].id
}

resource "aws_route" "private_peering" {
  count = var.is_perring_req ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc[count.index].id
}


resource "aws_route" "default_peering" {
  count = var.is_perring_req ? 1 : 0
  route_table_id            = data.aws_route_table.main.route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc[count.index].id
}