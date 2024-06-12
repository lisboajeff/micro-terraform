#!/bin/bash

# Caminho para o arquivo domain.yaml
domain_file="$1"

# Profile AWS
profile="$2"

# Ler cada domínio do arquivo domain.yaml usando yq
for domain_name in $(yq -e '.domains[].name' $domain_file); do

    domain_name="$(echo $domain_name | tr -d \")"

    # Recuperar o ID da zona usando AWS CLI
    zone_id=$(aws route53 list-hosted-zones --profile "$profile" | jq -r --arg domain_name "$domain_name." '.HostedZones[] | select(.Name==$domain_name) | .Id' | cut -d '/' -f 3)

    echo "zone id : $zone_id"

    # Verificar se o ID da zona foi encontrado
    if [ -z "$zone_id" ]; then
        echo "Nenhuma zona encontrada para o domínio $domain_name"
    else
        echo "ID da zona para o domínio $domain_name: $zone_id"

        # Recuperar os servidores DNS para o ID da zona encontrado
        name_servers_route53=$(aws route53 get-hosted-zone --id $zone_id --profile "$profile" | jq -r '.DelegationSet.NameServers[]')
        echo -e "Servidores DNS para o domínio $domain_name:\n------------------\n$name_servers_route53"

        rm zone

        for ns in $name_servers_route53; do
            # echo $ns
            echo $ns >>zone
        done

        name_servers_dig=$(dig $domain_name NS +short)

        echo -e "------------------\nVerificando resolução de Name Servers para $domain_name:\n------------------\n$name_servers_dig"

        echo -e "------------------\n"

        # Verifica se a saída está vazia
        if [ -z "$name_servers_dig" ]; then
            echo "Os Name Servers para $domain_name ainda não foram resolvidos.Aguarde"
            exit 1
        else
            ns_route53="$(echo "$name_servers_route53" | tr '\n' ',' | sed 's/,$//')"
            ns_dig="$(echo "$name_servers_dig" | tr '\n' ',' | sed 's/,$//')"
            python3 scripts/ns.py "$ns_route53" "$ns_dig"
            exit_code=$?
            # Verificar o código de saída do script Python
            if [ $exit_code -eq 0 ]; then
                echo "Sucesso: As listas de Name Servers são iguais."
            else
                echo "Erro: As listas de Name Servers não são iguais."
                exit 1
            fi
        fi

    fi
done

echo "Execute o próximo módulo"

echo "-----------------------------------"
