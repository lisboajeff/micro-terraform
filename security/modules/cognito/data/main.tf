variable "userpools" {
  description = "List of domains and their respective subdomains"
  type = list(object({
    name      = string
    wildcards = optional(list(string))
  }))
}

output "output" {
  value = var.userpools
}
