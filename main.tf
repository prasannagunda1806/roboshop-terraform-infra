module "ec2" {
    source = "./ec2"
    for_each = var.instances
    instance_type = each.value[ "type"]
    component = each.value[ "name " ]
    sg_id = module.sg.sg_id
}

module "sg" {
    source = "./sg"
}

module "route53" {
    for_each = var.instances
    source = "./route53"
    private_ip = module.ec2.[each.value[ " name " ]].private_ip
    component = each.value[ "name" ]
}

output ec2 {
    value = "module.ec2"
}