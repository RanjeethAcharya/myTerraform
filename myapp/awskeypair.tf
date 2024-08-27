locals {
  key_name   = "ex-${replace(basename(path.cwd), "_", "-")}"
}

################################################################################
# Key Pair Module
################################################################################

module "key_pair" {
  source = "../modules/terraform-aws-key-pair"

  key_name           = local.key_name
  create_private_key = true

  tags = local.tags
}