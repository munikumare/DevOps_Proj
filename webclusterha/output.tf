output "elb_dns_name" {
  value = "${aws_elb.elbterraform.dns_name}"
}
output "elb_dns_zone_id" {
  value = "${aws_elb.elbterraform.zone_id}"
}
