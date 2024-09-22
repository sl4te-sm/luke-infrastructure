resource "talos_machine_secrets" "machine_secrets" {}

data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.clusterName
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = var.controlNodeIps
  nodes                = concat(var.controlNodeIps, var.workerNodeIps)
}

data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.clusterName
  cluster_endpoint = "https://${var.controlNodeIps[0]}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "cp_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.control_nodes]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  count                       = length(var.controlNodes)
  endpoint                    = var.controlNodeIps[count.index]
  node                        = var.controlNodeIps[count.index]
}

data "talos_machine_configuration" "machineconfig_worker" {
  cluster_name     = var.clusterName
  cluster_endpoint = "https://${var.controlNodeIps[0]}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "worker_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.worker_nodes]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_worker.machine_configuration
  count                       = length(var.workerNodeIps)
  node                        = var.workerNodeIps[count.index]
  endpoint                    = var.workerNodeIps[count.index]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.controlNodeIps[0]
  endpoint             = var.controlNodeIps[0]
}

data "talos_cluster_health" "health" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply, talos_machine_configuration_apply.worker_config_apply]
  client_configuration = data.talos_client_configuration.talosconfig.client_configuration
  control_plane_nodes  = var.controlNodeIps
  worker_nodes         = var.workerNodeIps
  endpoints            = data.talos_client_configuration.talosconfig.endpoints
}

data "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap, data.talos_cluster_health.health]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = var.controlNodeIps[0]
}

output "talosconfig" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}
