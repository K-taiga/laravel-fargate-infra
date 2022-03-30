# laravel-fargate-infra

[envs/prod/app/laravel-fargate-app](https://github.com/K-taiga/laravel-fargate-infra/tree/main/envs/prod/app/laravel-fargate-app) ディレクトリで以下を実行しシンボリックリンクを貼っている

`ln -fs ../../provider.tf provider.tf`

`ln -fs ../../shared_locals.tf shared_locals.tf`

## パラメータストア
パラメータストアに関してはTerraform 管理外としAWSのコンソールで作成
