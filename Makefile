plan:
	terraform plan

apply:
	terraform apply

fmt:
	terraform fmt --recursive

state-list:
	terraform state list

show:
	terraform show

pull:
	terraform state pull

# exportがターミナルの再起動で消えてconfigの参照ができないので操作前はこれを実行する
setup-env:
	export AWS_PROFILE=m1-mac-terraform