#!/usr/bin/env bash
#
# Confere se a rede (repositorio oficina-infra-k8s) esta de fato provisionada.
#
# O RDS deste repositorio e construido sobre a VPC, as subnets privadas e o
# security group do no k3s, todos lidos via terraform_remote_state.
#
# Nao basta o arquivo de state existir: depois de um `terraform destroy` ele
# continua no bucket, porem com zero recursos e zero outputs. Checar so a
# existencia daria falso positivo e o Terraform quebraria adiante com um
# "Unable to find remote state output", que e exatamente o erro obscuro que
# esta checagem existe para evitar. Por isso validamos os outputs que este
# repositorio realmente consome.
#
# Sai 0 se pronto, 1 se nao. Quem chama decide a severidade: o job de plan
# trata ausencia como "pular", o de apply como erro.

set -uo pipefail

BUCKET="${STATE_BUCKET:-oficina-backend-tfstate-765465309229}"
KEY="k8s/terraform.tfstate"
OUTPUTS_NECESSARIOS=(vpc_id private_subnet_ids k3s_node_security_group_id)

estado=$(aws s3 cp "s3://${BUCKET}/${KEY}" - 2>/dev/null) || {
  echo "ausente: nenhum state de rede em s3://${BUCKET}/${KEY}"
  echo "Rode o apply de oficina-infra-k8s antes deste repositorio."
  exit 1
}

for saida in "${OUTPUTS_NECESSARIOS[@]}"; do
  if ! printf '%s' "$estado" | jq -e --arg o "$saida" '.outputs[$o] // empty' >/dev/null 2>&1; then
    echo "incompleto: o state de rede existe mas nao expoe o output '${saida}'."
    echo "A infraestrutura provavelmente foi destruida — rode o apply de oficina-infra-k8s."
    exit 1
  fi
done

echo "ok: rede provisionada, com os ${#OUTPUTS_NECESSARIOS[@]} outputs necessarios"
