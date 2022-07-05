module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.26.2"
  create          = true
  cluster_name    = var.eks.name
  cluster_version = var.eks.version
  create_iam_role = true

  # VPC
  vpc_id                   = try(var.vpc.id, "")
  subnet_ids               = try(var.vpc.subnet_ids, [])
  control_plane_subnet_ids = try(var.vpc.intra_subnets, [])

  # Encryption key
  create_kms_key            = false
  cluster_encryption_config = [
    {
      provider_key_arn = var.kms_key_id
      resources        = ["secrets"]
    }
  ]

  # logs
  create_cloudwatch_log_group            = true
  cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_kms_key_id        = var.kms_key_id
  cloudwatch_log_group_retention_in_days = var.eks.cloudwatch_log_group_retention_in_days

  # Private cluster
  cluster_endpoint_private_access = var.eks.cluster_endpoint_private_access

  # Public cluster
  cluster_endpoint_public_access       = var.eks.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.eks.cluster_endpoint_public_access_cidrs

  # Cluster addons
  cluster_addons = {
    coredns    = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni    = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # tags
  cluster_tags = local.tags
  tags         = local.tags

  # IAM
  map_roles = concat([
    {
      rolearn  = module.eks.worker_iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ], var.eks.aws_auth_roles)
  map_users = concat([
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.arn}:user/admin"
      username = "admin"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    }
  ], var.eks.aws_auth_users)

  /*
    cluster_encryption_policy_name                   = null
    cluster_encryption_policy_path                   = null
    cluster_iam_role_dns_suffix                      = null
    cluster_ip_family                                = "ipv4" # "ipv4" or "ipv6"
    cluster_security_group_name                      = null
    cluster_service_ipv4_cidr                        = null # either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks
    iam_role_arn                                     = null # Required if `create_iam_role` is set to `false`
    iam_role_description                             = null
    iam_role_name                                    = null
    iam_role_path                                    = null
    iam_role_permissions_boundary                    = null
    kms_key_deletion_window_in_days                  = 30
    kms_key_description                              = null
    node_security_group_name                         = null
    attach_cluster_encryption_policy                 = true
    aws_auth_accounts                                = []
    aws_auth_fargate_profile_pod_execution_role_arns = []
    aws_auth_node_iam_role_arns_non_windows          = []
    aws_auth_node_iam_role_arns_windows              = []
    aws_auth_roles                                   = []
    aws_auth_users                                   = []
    cluster_additional_security_group_ids            = []
    cluster_encryption_config                        = []
    cluster_encryption_policy_description            = "Cluster encryption policy to allow cluster role to utilize CMK provided"
    cluster_encryption_policy_tags                   = {}
    cluster_encryption_policy_use_name_prefix        = true
    cluster_identity_providers                       = {}
    cluster_security_group_additional_rules          = {}
    cluster_security_group_description               = "EKS cluster security group"
    cluster_security_group_id                        = ""
    cluster_security_group_tags                      = {}
    cluster_security_group_use_name_prefix           = true
    #  Create, update, and delete timeout configurations for the cluster
    cluster_timeouts                                 = {}
    create_aws_auth_configmap                        = false
    create_cluster_primary_security_group_tags       = true
    create_cluster_security_group                    = true
    create_cni_ipv6_iam_policy                       = false
    create_node_security_group                       = true
    custom_oidc_thumbprints                          = []
    eks_managed_node_group_defaults                  = {}
    eks_managed_node_groups                          = {}
    enable_irsa                                      = true
    enable_kms_key_rotation                          = true
    fargate_profile_defaults                         = {}
    fargate_profiles                                 = {}
    iam_role_additional_policies                     = []
    iam_role_tags                                    = {}
    iam_role_use_name_prefix                         = true
    kms_key_administrators                           = []
    kms_key_aliases                                  = []
    kms_key_enable_default_policy                    = false
    kms_key_override_policy_documents                = []
    kms_key_owners                                   = []
    kms_key_service_users                            = []
    kms_key_source_policy_documents                  = []
    kms_key_users                                    = []
    manage_aws_auth_configmap                        = false
    node_security_group_additional_rules             = {}
    node_security_group_description                  = "EKS node shared security group"
    node_security_group_id                           = ""
    node_security_group_ntp_ipv4_cidr_block          = ["0.0.0.0/0"]
    node_security_group_ntp_ipv6_cidr_block          = ["::/0"]
    node_security_group_tags                         = {}
    node_security_group_use_name_prefix              = true
    openid_connect_audiences                         = []
    prefix_separator                                 = "-"
    putin_khuylo                                     = true
    self_managed_node_group_defaults                 = {}
    self_managed_node_groups                         = {}
    */
}