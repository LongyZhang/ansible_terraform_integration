locals {
  database_private_ip = [for in in aws_instance.nodes : in.private_ip if in.tags.Name == "database"][0]
}

locals {
  web1_private_ip = [for in in aws_instance.nodes : in.private_ip if in.tags.Name == "web1"][0]
}

locals {
  web2_private_ip = [for in in aws_instance.nodes : in.private_ip if in.tags.Name == "web2"][0]
}

locals {
  proxy_private_ip = [for in in aws_instance.nodes : in.private_ip if in.tags.Name == "proxy"][0]
}

locals {
  test_private_ip = [for in in aws_instance.nodes : in.private_ip if in.tags.Name == "test"][0]
}