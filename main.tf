module "networking" {
  source = "./modules/networking"

  project_name              = var.project_name
  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  availability_zones         = var.availability_zones
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_app_subnet_cidrs   = var.private_app_subnet_cidrs
  private_db_subnet_cidrs    = var.private_db_subnet_cidrs
}

module "compute" {
  source = "./modules/compute"

  project_name            = var.project_name
  environment              = var.environment
  vpc_id                   = module.networking.vpc_id
  vpc_cidr                 = var.vpc_cidr
  public_subnet_ids        = module.networking.public_subnet_ids
  private_app_subnet_ids   = module.networking.private_app_subnet_ids
  app_instance_type        = var.app_instance_type
  app_min_size              = var.app_min_size
  app_max_size              = var.app_max_size
  app_desired_capacity      = var.app_desired_capacity
}

module "database" {
  source = "./modules/database"

  project_name            = var.project_name
  environment              = var.environment
  vpc_id                   = module.networking.vpc_id
  private_db_subnet_ids    = module.networking.private_db_subnet_ids
  app_security_group_id    = module.compute.app_security_group_id
  db_instance_class        = var.db_instance_class
  db_engine                = var.db_engine
  db_engine_version        = var.db_engine_version
  db_name                  = var.db_name
  db_username              = var.db_username
  db_allocated_storage     = var.db_allocated_storage
  db_multi_az              = false
}
