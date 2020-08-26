variable "description" {
  description = "Description of API gateway"
  type        = string
  default     = ""     
}

variable "endpoint_type" {
  description = "endpoint_type of API gateway"
  type        = list(string)
  default     = ["EDGE"]     
}

variable "api_name" {
  description = "Name of api gateway"
  type        = string
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the object."
  type        = map(string)
}

variable "policy_json" {
  default     = null
  description = "json document of policy to attach to json"
}

variable "binary_media_types" {
  description = "The list of binary media types supported by the RestApi Note--> By default, the RestApi supports only UTF-8-encoded text payloads."
  type        = list(string)
  default     = ["UTF-8-encoded"]
}
