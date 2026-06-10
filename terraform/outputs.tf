output "vm_ips" {
  description = "IPs des VM deployees"
  value = {
    db_server     = "192.168.20.10"
    runner_server = "192.168.50.10"
    soc_server    = "192.168.30.10"
    web_server    = "192.168.20.20"
    ia_server     = "192.168.20.30"
  }
}
