# A rede (VPC, subnets privadas e o security group do nó k3s) é criada e
# versionada pelo repositório oficina-infra-k8s. Em vez de duplicar esses
# recursos aqui — o que criaria duas fontes de verdade e um conflito na hora
# do destroy — lemos o state dele em modo somente leitura.
#
# Consequência de ordem: oficina-infra-k8s precisa ter dado apply pelo menos
# uma vez antes do primeiro apply deste repositório. O pipeline falha com uma
# mensagem clara se o state ainda não existir.
data "terraform_remote_state" "k8s" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "k8s/terraform.tfstate"
    region = var.aws_region
    # Sem profile: o data source herda as credenciais do ambiente, que é o
    # que vale tanto localmente (AWS_PROFILE exportado) quanto no CI.
  }
}

locals {
  vpc_id             = data.terraform_remote_state.k8s.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.k8s.outputs.private_subnet_ids
  k3s_node_sg_id     = data.terraform_remote_state.k8s.outputs.k3s_node_security_group_id
}
