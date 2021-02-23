# アクセスを許可するユーザーにプロジェクトレベルで付与するロール
# このロールに含まれる権限はプロジェクトレベルで付与する必要がある
resource "google_project_iam_binding" "bind_use_iap" {
  role = google_project_iam_custom_role.use_iap.id

  members = [
    "user:${var.allowed_user_mail}",
  ]
}

# プロジェクトレベルで踏み台サーバーにロールを付与する
# GKEはリソースレベルでのロールの付与ができない
resource "google_project_iam_binding" "bind_enable_kubectl" {
  role = google_project_iam_custom_role.enable_kubectl.id

  members = [
    "serviceAccount:${google_service_account.bastion.email}",
  ]
}
