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

# resource "aws_ecs_task_definition" "this" {
#   # タスク定義の名前を設定
#   family = "${local.name_prefix}-${local.service_name}"

#   # タスク用に追加したroleを設定
#   task_role_arn = aws_iam_role.ecs_task.arn

#   # コンテナで使用するDockerネットワーキングモード Fargateならawsvpc
#   network_mode = "awsvpc"

#   # ECSの起動タイプ
#   requires_compatibilities = [
#     "FARGATE"
#   ]

#   # タスク実行ロール(コンテナに入れるロール)
#   execution_role_arn = aws_iam_role.ecs_task_execution.arn

#   # タスクに使用されるメモリとCPU
#   # 最小512 = 0.5GB
#   memory = "512"
#   # 最小256 = 0.25vCPU
#   cpu = "256"

#   container_definitions = jsonencode(
#     [
#       {
#         name  = "nginx"
#         image = "${module.nginx.ecr_repository_this_repository_url}:latest"
#         portMappings = [
#           {
#             containerPort = 80
#             protocol      = "tcp"
#           }
#         ]
#         environment = []
#         secrets     = []
#         dependsOn = [
#           {
#             containerName = "php"
#             condition     = "START"
#           }
#         ]
#         # mountPointsでnginxとPHP間の通信をUNIXドメインソケットで設定(PHPのタスクも同様の場所を定義)
#         mountPoints = [
#           {
#             containerPath = "/var/run/php-fpm"
#             sourceVolume  = "php-fpm-socket"
#           }
#         ]
#         logConfiguration = {
#           logDriver = "awslogs"
#           options = {
#             awslogs-group         = "/ecs/${local.name_prefix}-${local.service_name}/nginx"
#             awslogs-region        = data.aws_region.current.id
#             awslogs-stream-prefix = "ecs"
#           }
#         }
#       },
#       {
#         name         = "php"
#         image        = "${module.php.ecr_repository_this_repository_url}:latest"
#         portMappings = []
#         environment  = []
#         # パラメータストアのAPP_KEYを環境設定として取得
#         secrets = [
#           {
#             name      = "APP_KEY"
#             valueFrom = "/${local.system_name}/${local.env_name}/${local.service_name}/APP_KEY"
#           }
#         ]
#         mountPoints = [
#           {
#             containerPath = "/var/run/php-fpm"
#             sourceVolume  = "php-fpm-socket"
#           }
#         ]
#         logConfiguration = {
#           logDriver = "awslogs"
#           options = {
#             awslogs-group         = "/ecs/${local.name_prefix}-${(local.service_name)}/php"
#             awslogs-region        = data.aws_region.current.id
#             awslogs-stream-prefix = "ecs"
#           }
#         }
#       }
#     ]
#   )
#   # volumeとして同じソケットをマウント
#   volume {
#     name = "php-fpm-socket"
#   }
#   tags = {
#     Name = "${local.name_prefix}-${local.service_name}"
#   }
# }

# resource "aws_ecs_service" "this" {
#   name = "${local.name_prefix}-${local.service_name}"

#   # 属するECSクラスターのARN
#   cluster = aws_ecs_cluster.this.arn

#   capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     # 実行するFARGATEかFARGATE_SPOTのタイプの最小のタスク数
#     base = 0
#     # 実行するFARGATEかFARGATE_SPOTの比率
#     weight = 1
#   }

#   platform_version = "1.4.0"

#   # taskの定義
#   task_definition = aws_ecs_task_definition.this.arn

#   # 起動するタスクの数 = 今回は1
#   desired_count = var.desired_count
#   # タスクの古いものから新しいものへの更新の際に最低何個のタスクを維持するかの％
#   # つまり１個は必ず実行している
#   deployment_minimum_healthy_percent = 100
#   # タスクの実行の最大数の%
#   deployment_maximum_percent = 200

#   # load_balancerに晒すコンテナとport
#   load_balancer {
#     container_name   = "nginx"
#     container_port   = 80
#     target_group_arn = data.terraform_remote_state.routing_laravel-fargate-app_link.outputs.lb_target_group_bodoge-cafe-reviews_arn
#   }

#   # タスクの起動直後のヘルスチェックの猶予時間
#   health_check_grace_period_seconds = 60

#   network_configuration {
#     # タスクにパブリックipを紐付けるか
#     assign_public_ip = false
#     # ALBと紐付いているsecurity_groupをタスクにも紐付けることでALBとの通信を許可
#     security_groups = [
#       data.terraform_remote_state.network_main.outputs.security_group_vpc_id
#     ]
#     subnets = [for s in data.terraform_remote_state.network_main.outputs.subnet_private : s.id]
#   }


#   enable_execute_command = true
#   tags = {
#     Name = "${local.name_prefix}-${local.service_name}"
#   }
# }