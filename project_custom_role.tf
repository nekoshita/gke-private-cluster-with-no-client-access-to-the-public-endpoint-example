# IAPを用いてSSH接続するのに必要な権限
# プロジェクトレベルで付与する必要がある
resource "google_project_iam_custom_role" "use_iap" {
  role_id = "UseIAP"
  title   = "use iap"

  permissions = [
    # プロジェクト内のリソースにアクセスするのに必要な権限
    "compute.projects.get",
    # 別のサービスアカウントにアクセスするために必要な権限
    # SSH接続するときはVMインスタンスのサービスアカウントにアクセスするので必要になる
    "iam.serviceAccounts.actAs",
    # IAPに必要な権限
    "iap.tunnelInstances.accessViaIAP",
  ]
}

# 踏み台サーバーにSSHするためのロール
resource "google_project_iam_custom_role" "ssh_to_vm_instance" {
  role_id = "SSHToVMInstance"
  title   = "SSH to VM Instance"

  permissions = [
    # VMインスタンスを取得するのに必要な権限
    "compute.instances.get",
    # メタ情報を付与するのに必要な権限
    # 初めてSSH接続する時、鍵を渡すために必要
    "compute.instances.setMetadata",
  ]
}

# kubectlするためのロール
resource "google_project_iam_custom_role" "enable_kubectl" {
  role_id = "EnableKubectl"
  title   = "Enable Kubectl"

  permissions = [
    # クラスタの認証情報を取得するのに必要な権限
    "container.clusters.get",
    # podの一覧取得するのに必要な権限,
    "container.pods.list"
  ]
}
