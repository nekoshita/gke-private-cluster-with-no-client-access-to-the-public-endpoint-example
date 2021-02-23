resource "google_container_cluster" "my_cluster" {
  name     = "my-cluster"
  location = var.gcp_zones["tokyo-a"]
  project  = var.gcp_project_id

  network    = google_compute_network.my_network.name
  subnetwork = google_compute_subnetwork.my_subnetwork.name

  # デフォルトのノードプールがないクラスターを作成することはできないので、
  # クラスター作成直後にデフォルトのノードプールを削除する
  remove_default_node_pool = true
  initial_node_count       = 1

  # 限定公開クラスタにするための設定
  private_cluster_config {
    # プライベートノードにするかどうか（ノードに外部IPを付与しない）
    enable_private_nodes = true
    # kubectlコマンドのアクセスを内部IPアドレスからのみにするかどうか
    enable_private_endpoint = true
    # クラスターのmasterとILB VIPのためのプライベードIPアドレスを指定する必要がある
    #  /28 subnetでないといけない
    master_ipv4_cidr_block = "192.168.0.0/28"
  }
  # enable_private_endpointがtrueの場合はmaster_authorized_networks_configを設定する必要があります。
  # master_authorized_networks_configにはコントロール プレーンにアクセスできるIPアドレスを指定します。
  # enable_private_endpointがtrueの時には、master_authorized_networks_configで指定しなくても、以下の2種類のIPアドレスからコントロールプレーンにアクセス可能です
  # 1, GKEクラスタが所属するサブネットのプライマリ範囲
  # 2, GKEクラスタのポッドに使用されるセカンダリ範囲
  master_authorized_networks_config {}

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.my_subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.my_subnetwork.secondary_ip_range.1.range_name
  }
}

resource "google_container_node_pool" "my_cluster_nodes" {
  name       = "my-node-pool"
  location   = var.gcp_zones["tokyo-a"]
  cluster    = google_container_cluster.my_cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    service_account = google_service_account.my_cluster.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
