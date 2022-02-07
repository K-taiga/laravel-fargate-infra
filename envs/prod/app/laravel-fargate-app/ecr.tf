module "nginx" {
  source = "../../../../modules/ecr"

  name = "${local.name_prefix}-${local.service_name}-nginx"
}

module "PHP" {
  source = "../../../../modules/ecr"

  name = "${local.name_prefix}-${local.service_name}-php"
}