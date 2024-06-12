#!/bin/bash

# Caminho para o arquivo domain.yaml
certificates_file="$1"

# Profile AWS
profile="$2"

# Ler cada domínio do arquivo domain.yaml usando yq
for domain_name in $(yq -e '.certificates[].name' $certificates_file); do

    domain_name="$(echo $domain_name | tr -d \")"

    echo "Processando o domínio: $domain_name"

    # Usar AWS CLI para listar todos os certificados e filtrar pelo nome do domínio
    certificate_arn=$(aws acm list-certificates --profile "$profile" | jq -r --arg domain_name "$domain_name" '.CertificateSummaryList[] | select(.DomainName==$domain_name) | .CertificateArn')

    # Verificar se o ARN foi encontrado
    if [ -z "$certificate_arn" ]; then
        echo "Nenhum certificado encontrado para o domínio $domain_name."
    else
        echo "O ARN do certificado para o domínio $domain_name é: $certificate_arn"

        # Usar AWS CLI para obter informações sobre o certificado
        cert_status=$(aws acm describe-certificate --certificate-arn $certificate_arn --profile "$profile" | jq -r '.Certificate.Status')

        # Verificar o status do certificado
        if [ "$cert_status" == "ISSUED" ]; then
            echo "O certificado com ARN $certificate_arn está aprovado."
        else
            echo "O certificado com ARN $certificate_arn não está aprovado. Status atual: $cert_status"
        fi

    fi

    echo "-----------------------------------"

done
