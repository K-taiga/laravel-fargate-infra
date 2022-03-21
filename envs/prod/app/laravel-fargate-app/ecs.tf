resource "aws_ecs_cluster" "this" {
  name = "${local.name_prefix}-${local.service_name}"

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  tags = {
    Name = "${local.name_prefix}-${local.service_name}"
  }
}

resource "aws_ecs_task_definition" "this" {
  # タスク定義の名前を設定
  family = "${local.name_prefix}-${local.service_name}"

  # タスク用に追加したroleを設定
  task_role_arn = aws_iam_role.ecs_task.arn

  # コンテナで使用するDockerネットワーキングモード Fargateならawsvpc
  network_mode = "awsvpc"

  # ECSの起動タイプ
  requires_compatibilities = [
    "FARGATE"
  ]

  # タスク実行ロール(コンテナに入れるロール)
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  # タスクに使用されるメモリとCPU
  # 最小512 = 0.5GB
  memory = "512"
  # 最小256 = 0.25vCPU
  cpu = "256"

  container_definitions = jsonencode(
    [
      {
        name  = "nginx"
        image = "${module.nginx.ecr_repository_this_repository_url}:latest"
        portMappings = [
          {
            containerPort = 80
            protocol      = "tcp"
          }
        ]
        environment = []
        secrets     = []
        dependsOn = [
          {
            containerName = "php"
            condition     = "START"
          }
        ]
        # mountPointsでnginxとPHP間の通信をUNIXドメインソケットで設定(PHPのタスクも同様の場所を定義)
        mountPoints = [
          {
            containerPath = "/var/run/php-fpm"
            sourceVolume  = "php-fpm-socket"
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/${local.name_prefix}-${local.service_name}/nginx"
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "ecs"
          }
        }
      },
      {
        name         = "php"
        image        = "${module.php.ecr_repository_this_repository_url}:latest"
        portMappings = []
        environment  = []
        # パラメータストアのAPP_KEYを環境設定として取得
        secrets = [
          {
            name      = "APP_KEY"
            valueFrom = "/${local.system_name}/${local.env_name}/${local.service_name}/APP_KEY"
          }
        ]
        mountPoints = [
          {
            containerPath = "/var/run/php-fpm"
            sourceVolume  = "php-fpm-socket"
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/${local.name_prefix}-${(local.service_name)}/php"
            awslogs-region        = data.aws_region.current.id
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ]
  )
  # volumeとして同じソケットをマウント
  volume {
    name = "php-fpm-socket"
  }
  tags = {
    Name = "${local.name_prefix}-${local.service_name}"
  }
}