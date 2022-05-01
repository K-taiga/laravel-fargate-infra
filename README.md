# laravel-fargate-infra

[envs/prod/app/laravel-fargate-app](https://github.com/K-taiga/laravel-fargate-infra/tree/main/envs/prod/app/laravel-fargate-app) ディレクトリで以下を実行しシンボリックリンクを貼っている

`ln -fs ../../provider.tf provider.tf`

`ln -fs ../../shared_locals.tf shared_locals.tf`

## パラメータストア
パラメータストアに関してはTerraform 管理外としAWSのコンソールで作成

## 構成図

![laravel-fargate-infra](https://user-images.githubusercontent.com/46162925/166137814-deba5911-3843-4012-b625-d6817ca95bab.jpg)
