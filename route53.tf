resource "aws_route53_zone" "example" {
  name = "abcde.com"  # Replace with your actual domain name
}

resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "a-record"
  type    = "A"
  ttl     = 300
  records = ["192.168.1.1"]
}