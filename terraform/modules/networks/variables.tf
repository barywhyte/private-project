variable "labels" {
  type = map(string)
  default = {
    managed = "Terraform"
    project = "special-projects"
  }
}
