#!/bin/sh

# Variables de entorno necesarias:
# - CF_API_KEY: Tu API key de Cloudflare
# - CF_ZONE_ID: El Zone ID de tu dominio en Cloudflare
# - CF_RECORD_NAME: El nombre del registro DNS que quieres actualizar (por ejemplo, tu-dominio.com)
# - CF_RECORD_TYPE: El tipo de registro DNS (probablemente A para IPv4 o AAAA para IPv6)
# - CF_PROXIED: Si queremos que este protegida bajo proxy o que apunte directamente a nuestra ip

# Obtener la dirección IP externa actual
IP=$(curl -s http://ipinfo.io/ip)

# Obtener el ID del registro DNS que se actualizará
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?name=$CF_RECORD_NAME&type=$CF_RECORD_TYPE" \
     -H "Authorization: Bearer $CF_API_KEY" \
     -H "Content-Type: application/json" | jq -r '.result[0].id')

# Actualizar el registro DNS con la nueva IP
RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
     -H "Authorization: Bearer $CF_API_KEY" \
     -H "Content-Type: application/json" \
     --data '{"type":"'"$CF_RECORD_TYPE"'","name":"'"$CF_RECORD_NAME"'","content":"'"$IP"'","proxied":"'"$CF_PROXIED"'"}')

echo $RESPONSE
