resource "linode_instance" "dpiproxy" {
  label = var.linodeName
  image = var.linodeImage
  region = var.linodeRegion
  type = var.linodeType
  authorized_keys = var.linodeSSHKeys
  root_pass = var.linodePassword
}
