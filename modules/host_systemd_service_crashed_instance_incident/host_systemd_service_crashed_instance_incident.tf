resource "shoreline_notebook" "host_systemd_service_crashed_instance_incident" {
  name       = "host_systemd_service_crashed_instance_incident"
  data       = file("${path.module}/data/host_systemd_service_crashed_instance_incident.json")
  depends_on = [shoreline_action.invoke_cpu_mem_check,shoreline_action.invoke_restart_service]
}

resource "shoreline_file" "cpu_mem_check" {
  name             = "cpu_mem_check"
  input_file       = "${path.module}/data/cpu_mem_check.sh"
  md5              = filemd5("${path.module}/data/cpu_mem_check.sh")
  description      = "The host system's resources were overloaded due to high usage or traffic, causing the systemd service to fail."
  destination_path = "/agent/scripts/cpu_mem_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_service" {
  name             = "restart_service"
  input_file       = "${path.module}/data/restart_service.sh"
  md5              = filemd5("${path.module}/data/restart_service.sh")
  description      = "Restart the systemd service on the affected host instance: This can be done to try and resolve the issue by manually restarting the systemd service on the affected host instance. If the failure was due to a temporary issue, the service should resume normal operations after restarting."
  destination_path = "/agent/scripts/restart_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_mem_check" {
  name        = "invoke_cpu_mem_check"
  description = "The host system's resources were overloaded due to high usage or traffic, causing the systemd service to fail."
  command     = "`chmod +x /agent/scripts/cpu_mem_check.sh && /agent/scripts/cpu_mem_check.sh`"
  params      = ["SYSTEMD_SERVICE_NAME"]
  file_deps   = ["cpu_mem_check"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_mem_check]
}

resource "shoreline_action" "invoke_restart_service" {
  name        = "invoke_restart_service"
  description = "Restart the systemd service on the affected host instance: This can be done to try and resolve the issue by manually restarting the systemd service on the affected host instance. If the failure was due to a temporary issue, the service should resume normal operations after restarting."
  command     = "`chmod +x /agent/scripts/restart_service.sh && /agent/scripts/restart_service.sh`"
  params      = ["SYSTEMD_SERVICE_NAME","HOST_INSTANCE"]
  file_deps   = ["restart_service"]
  enabled     = true
  depends_on  = [shoreline_file.restart_service]
}

