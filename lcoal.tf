# private IPs for each instance
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

## public IPs for each instance

locals {
  manager_public_ip = [for in in aws_instance.nodes : in.private_ip if in.tags.Name == "manager"][0]
}

locals {
  web1_public_ip = [for in in aws_instance.nodes : in.public_ip if in.tags.Name == "web1"][0]
}

locals {
  web2_public_ip = [for in in aws_instance.nodes : in.public_ip if in.tags.Name == "web2"][0]
}

locals {
  proxy_public_ip = [for in in aws_instance.nodes : in.public_ip if in.tags.Name == "proxy"][0]
}

locals {
  test_public_ip = [for in in aws_instance.nodes : in.public_ip if in.tags.Name == "test"][0]
}

locals {
  database_public_ip = [for in in aws_instance.nodes : in.public_ip if in.tags.Name == "database"][0]
}