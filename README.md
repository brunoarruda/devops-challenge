# DevOps Challenge (Terraform)

Repositório contendo os módulos e configurações de infraestrutura Terraform para a criação de uma instância EC2 na AWS.

## TODO

- [x] EC2
  - [x] módulo
  - [x] instância
  - [ ] script para instalação do minikube e argoCD
- [x] backend S3
- [x] chave ssh da instância minikube
- [ ] módulo SG
- [ ] refatoração para Terragrunt

## How to use

Para criação dos recursos

```shell
cd infrastructure/lab/ec2/challenge
terraform init
terraform plan -var-file=./variables.tfvars -out tf.plan
terraform apply tf.plan -auto-approve
```

Para destruição dos recursos

```shell
cd infrastructure/lab/ec2/challenge
terraform destroy -var-file=./variables.tfvars -auto-approve
```
