resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    #   vpcのNameタグを指定
    Name = aws_vpc.this.tags.Name
  }
}