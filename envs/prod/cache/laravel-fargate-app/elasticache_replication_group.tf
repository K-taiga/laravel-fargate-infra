resource "aws_elasticache_replication_group" "this" {
  engine = "redis"

  // Redis settings
  replication_group_id          = "${local.system_name}-${local.env_name}-${local.service_name}"
  replication_group_description = "Session storage for Laravel"
  engine_version                = "6.x"
  port                          = 6379
  parameter_group_name          = aws_elasticache_parameter_group.this.name
  // 料金がかかるため一番低いスペックにしているので本番などで使う場合はいいスペックにする必要あり
  node_type = "cache.t3.micro"
  // nodeを２つ作成しMultiAz化
  number_cache_clusters = 2
  multi_az_enabled      = true

  // Advanced Redis settings
  subnet_group_name = data.terraform_remote_state.network_main.outputs.elasticache_subnet_group_this_name

  // Security
  security_group_ids = [
    data.terraform_remote_state.network_main.outputs.security_group_cache_laravel-fargate-app_id
  ]
  // ElastiCacheに暗号化して保存 AWS側のキーで管理
  at_rest_encryption_enabled = true
  // ElasticCacheとの通信の暗号化
  transit_encryption_enabled = false

  // Backup
  // 自動バックアップの保持日数
  snapshot_retention_limit = 1
  // UTCなので日本時間で午前2時~3時
  snapshot_window = "17:00-18:00"

  // Maintenance
  // UTCなので日本時間で土曜の午前2時~3時
  maintenance_window = "fri:18:00-fri:19:00"
  // SNSでの通知
  notification_topic_arn = ""

  // Others
  // プライマリノード(Write&Read)に障害があったらレプリカノード（ReadOnly)をプライマリにフェイルオーバーする
  automatic_failover_enabled = true
  auto_minor_version_upgrade = false

  tags = {
    Name = "${local.system_name}-${local.env_name}-${local.service_name}"
  }
}