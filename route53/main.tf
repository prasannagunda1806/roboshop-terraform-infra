resource "aws_route53_record" "record" {
  zone_id = Z07471731U7WCB4GJO8FS
  name    = "{var.component}-dev.devopsprasanna1.store"
  type    = "A"
  ttl     = 30
  records = [var.private_ip]
}

variable "component" {}
variable "private_ip" {}