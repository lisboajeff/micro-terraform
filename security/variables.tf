variable "config" {
  type = object({
    country     = string
    environment = string
    file_path   = string
  })
}
