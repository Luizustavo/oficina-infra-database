#!/usr/bin/env bash
#
# Confere se o state da rede (repositorio oficina-infra-k8s) ja existe no S3.
#
# O RDS daqui e construido sobre a VPC, as subnets privadas e o security
# group do no k3s, todos lidos via terraform_remote_state. Sem aquele state,
# o Terraform falha com "Unable to find remote state", que nao diz o que
# fazer.
#
# Sai com 0 se a dependencia esta pronta, 1 se nao. Quem chama decide o que
# fazer com isso: o job de plan trata como "pular", o de apply como erro.

set -uo pipefail

BUCKET="${STATE_BUCKET:-oficina-backend-tfstate-765465309229}"
KEY="k8s/terraform.tfstate"

if aws s3api head-object --bucket "$BUCKET" --key "$KEY" >/dev/null 2>&1; then
  echo "ok: state de rede encontrado em s3://$BUCKET/$KEY"
  exit 0
fi

echo "state de rede ausente em s3://$BUCKET/$KEY"
echo "Rode o apply de oficina-infra-k8s antes deste repositorio."
exit 1
