resource "google_compute_firewall" "my_network" {
  name    = "my-network-firewall"
  network = google_compute_network.my_network.name

  direction = "INGRESS"

  # 通信を許可するprotocolとportを指定する
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # 対象のVMインスタンスのタグを指定する
  target_tags = ["bastion-tag"]
  # Cloud IAPのバックエンドIPアドレス範囲を指定する
  # https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
  source_ranges = ["35.235.240.0/20"]

  # CloudLoggingにFlowLogログを出力したい場合は設定する
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
