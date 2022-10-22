resource "aws_instance" "instance" {
    ami = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
}