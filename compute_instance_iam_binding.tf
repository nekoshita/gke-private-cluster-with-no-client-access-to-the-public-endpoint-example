# 踏み台サーバーにIAP経由でSSHするユーザーにリソースレベルのロールを付与する
resource "google_compute_instance_iam_binding" "enable_ssh_to_vm_instance_for_bastion" {
  instance_name = google_compute_instance.bastion.name
  zone          = var.gcp_zones["tokyo-a"]

  role = google_project_iam_custom_role.ssh_to_vm_instance.id

  members = [
    "user:${var.allowed_user_mail}",
  ]
}
