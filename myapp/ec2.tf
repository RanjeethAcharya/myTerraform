################################################################################
# EC2 Module
################################################################################

module "ec2_complete" {
  source = "../modules/aws-ec2"

  name = "jenkins"

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium" # used to set core count below
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  disable_api_stop            = false
  key_name                    = module.key_pair.key_pair_name
  associate_public_ip_address = true
  private_ip                  = "10.0.48.82"

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  tags = {
    Name = "jenkins"
  }
}

################################################################################
# EC2 Module
################################################################################

module "ec2_jump_server" {
  source = "../modules/aws-ec2"

  name = "ansi_terra"

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" # used to set core count below
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  disable_api_stop            = false
  key_name                    = module.key_pair.key_pair_name
  associate_public_ip_address = true

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 8
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  tags = {
    Name = "ansi_terra"
  }
}
