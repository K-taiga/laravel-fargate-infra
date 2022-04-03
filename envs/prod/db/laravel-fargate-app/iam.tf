# RDSの拡張モニタリングをcloudwatchに送る用のrole
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${local.system_name}-${local.env_name}-${local.service_name}-rds-monitoring-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "monitoring.rds.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

# 拡張モニタリングにはawsの管理policyのAmazonRDSEnhancedMonitoringRoleを更につける
data "aws_iam_policy" "rds_enhanced_monitoring_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# ロールとpolicyを紐付け
resource "aws_iam_role_policy_attachment" "rds_monitoring_role" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = data.aws_iam_policy.rds_enhanced_monitoring_role.arn
}