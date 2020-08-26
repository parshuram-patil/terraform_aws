
module "api_gw_1" {
  source           = "./api-gateway/api"
  api_name = "api-gw-1"
}


module "api_gw_2" {
  source           = "./api-gateway/api"
  api_name = "api-gw-2"
}
