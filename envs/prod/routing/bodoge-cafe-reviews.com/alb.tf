resource "aws_lb" "this" {
  count = var.enable_alb ? 1 : 0

  name = "${local.name_prefix}-bodoge-cafe-reviews"

  # これをtrueにすると内部のロードバランサーになり、インターネット向けじゃなくなる
  internal = false
  #   NLBならNetwork,Gateway Load Balancerならgatewayを選択
  load_balancer_type = "application"

  access_logs {
    # logの保存先
    bucket = data.terraform_remote_state.log_alb.outputs.s3_bucket_this_id
    # ログを保存するか
    enabled = true
    # ログのprefix
    prefix = "bodoge-cafe-reviews"
  }

  # outputsからALBに紐付けるセキュリティグループを取得
  security_groups = [
    data.terraform_remote_state.network_main.outputs.security_group_web_id,
    data.terraform_remote_state.network_main.outputs.security_group_vpc_id
  ]

  # inの値を取り出しsにし:以降の処理を行う s.idを取り出した配列ができる
  subnets = [for s in data.terraform_remote_state.network_main.outputs.subnet_public : s.id]

  tags = {
    Name = "${local.name_prefix}-bodoge-cafe-reviews"
  }
}

resource "aws_lb_listener" "https" {
  count = var.enable_alb ? 1 : 0

  # SSL証明書の指定
  certificate_arn = aws_acm_certificate.root.arn
  # このalbをHTTPSリスナーに紐付け
  load_balancer_arn = aws_lb.this[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  # リクエストを受け付けたときの挙動
  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.bodoge-cafe-reviews.arn
  }
}

# httpsからhttpへのリダイレクト
resource "aws_lb_listener" "redirect_http_to_https" {
  count = var.enable_alb ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "bodoge-cafe-reviews" {
  name = "${local.name_prefix}-bodoge-cafe-reviews"

  # タスクから切り離す前にALBが待機する時間　デフォルトでは300
  deregistration_delay = 60
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.network_main.outputs.vpc_this_id

  health_check {
    # ターゲットが正常と思われるまでに必要なヘルスチェック連続回数
    healthy_threshold = 2
    interval          = 30
    # 正常とみなすステータスコード
    matcher = 200
    path    = "/"
    # ALBからターゲットへのipと同じportを指定
    port     = "traffic-port"
    protocol = "HTTP"
    # ヘルスチェックが失敗とみなす応答時間
    timeout = 5
    # ヘルスチェック失敗の連続回数
    unhealthy_threshold = 2
  }
}