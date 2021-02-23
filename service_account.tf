resource "google_service_account" "bastion" {
  account_id   = "bastion"
  display_name = "My Service Account For Bastion"
}

resource "google_service_account" "my_cluster" {
  account_id   = "my-cluster"
  display_name = "My Service Account For My Cluster"
}
