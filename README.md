# DevOps Challenge (Terraform)

Repositório contendo os módulos e configurações de infraestrutura Terraform para a criação de uma instância EC2 na AWS.

## TODO

- [x] EC2
  - [x] módulo
  - [ ] outputs
  - [x] instância
  - [x] script para instalação do minikube e argoCD
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
terraform apply -auto-approve tf.plan
```

Para destruição dos recursos

```shell
cd infrastructure/lab/ec2/challenge
terraform destroy -var-file=./variables.tfvars -auto-approve
```

## Sobre o Repositório

O repositório tem a seguinte estrutura:

```text
├── infrastructure
│   └── lab # conta ou ambiente do recurso
│       └── ec2 # tipo de recurso
│           └── challenge # projeto
│               └── <arquivos terraform para deployment>
├── module
│   └── ec2 # tipo do módulo
│       └── <arquivos de definição do módulo>
└── README.md
```

O ideal seria haver 2 repositórios distintos, um para os módulos e outra para a infraestrutura que consome esses módulos, mas devido ao tempo restrito, eu juntei ambos em um repositório só.
