# 変数の指定 moduleを呼ぶ際に具体的な値を入れる
variable "name" {
  # ここで型宣言をする
  type = string
}
variable "holding_count" {
  type = number
  # デフォルト値
  default = 10
}