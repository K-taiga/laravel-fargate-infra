resource "aws_db_instance" "this" {
  // Engine options
  engine         = "mysql"
  engine_version = "8.0.25"

  // Settings
  identifier = "${local.system_name}-${local.env_name}-${local.service_name}"

  // Credentials Settings
  username = local.env_name
  // passwordはダミーで後ほどAWS CLIを使って変更
  password = "MustChangeStrongPassword!"

  // DB instance class
  instance_class = "db.t3.micro"

  // Storage
  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 0

  // Availability & durability
  // 通常はtrueだが個人での利用なため費用を考えてfalse
  multi_az = false

  // Connectivity
  db_subnet_group_name = data.terraform_remote_state.network_main.outputs.db_subnet_group_this_id
  // private subnetなためfalse
  publicly_accessible = false
  vpc_security_group_ids = [
    data.terraform_remote_state.network_main.outputs.security_group_db_laravel-fargate-app_id,
  ]
  availability_zone = "ap-northeast-1a"
  port              = 3306

  // Database authentication
  iam_database_authentication_enabled = false

  // Database options
  name                 = local.env_name
  parameter_group_name = aws_db_parameter_group.this.name
  option_group_name    = aws_db_option_group.this.name

  // Backup
  // スナップショットの保持する日数
  backup_retention_period = 1
  // 自動バックアップの時間 UTCのため日本だとAM2:00~3:00
  backup_window         = "17:00-18:00"
  copy_tags_to_snapshot = true
  // 削除時スナップショットも同時に削除
  delete_automated_backups = true
  // 削除時スナップショットを作成しない
  skip_final_snapshot = true

  // Encryption = ストレージの暗号化
  storage_encrypted = true
  // ストレージの暗号化に使うKMSキー(AWS管理)
  kms_key_id = data.aws_kms_alias.rds.target_key_arn

  // Performance Insights (db.t3.micro, db.t3.small are not supported)
  // t3.microだとより詳細なモニタリングができないためfalse
  performance_insights_enabled = false
  # performance_insights_kms_key_id       = data.aws_kms_alias.rds.target_key_arn
  # performance_insights_retention_period = 7

  // Monitoring = 拡張モニタリングの収集間隔
  monitoring_interval = 60
  // 拡張モニタリングをcloudwatchに送信するためのIAMロール
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  // Log exports = 出力するログの種類
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  // Maintenance
  // マイナーバージョンのauto updateをするか
  auto_minor_version_upgrade = false
  // RDSに対する各種変更を適用する時間帯 日本時間だとsat:3:00~sat:4:00
  maintenance_window = "fri:18:00-fri:19:00"

  // Deletion protection = terraform destroyできる
  deletion_protection = false

  tags = {
    Name = "${local.system_name}-${local.env_name}-${local.service_name}"
  }
}