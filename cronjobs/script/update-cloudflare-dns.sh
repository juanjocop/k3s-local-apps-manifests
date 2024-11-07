#!/bin/sh

# Variables de entorno necesarias:
# - CF_API_KEY: Tu API key de Cloudflare
# - CF_ZONE_ID: El Zone ID de tu dominio en Cloudflare
# - CF_RECORD_NAME: El nombre del registro DNS que quieres actualizar (por ejemplo, tu-dominio.com)
# - CF_RECORD_TYPE: El tipo de registro DNS (probablemente A para IPv4 o AAAA para IPv6)
# - CF_PROXIED: Si quieres que esté protegido bajo proxy (true) o apunte directamente a la IP (false)

# Obtener la dirección IP externa actual
IP=$(curl -s http://ipinfo.io/ip)

# Convertir CF_PROXIED en un booleano real
if [ "$CF_PROXIED" = "true" ]; then
  PROXIED=true
else
  PROXIED=false
fi

# Obtener la información del registro DNS actual en Cloudflare
RECORD_INFO=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?name=$CF_RECORD_NAME&type=$CF_RECORD_TYPE" \
     -H "Authorization: Bearer $CF_API_KEY" \
     -H "Content-Type: application/json")

# Obtener el ID del registro DNS y la IP actual de Cloudflare
RECORD_ID=$(echo "$RECORD_INFO" | jq -r '.result[0].id')
echo $IP
CURRENT_CF_IP=$(echo "$RECORD_INFO" | jq -r '.result[0].content')
echo $CURRENT_CF_IP

# Comparar la IP actual con la IP en Cloudflare
if [ "$IP" = "$CURRENT_CF_IP" ]; then
  echo "La IP actual ($IP) coincide con la IP en Cloudflare. No se necesita actualización."
else
  # Crear el JSON de datos para actualizar, usando jq y el valor booleano de PROXIED
  DATA=$(jq -n --arg type "$CF_RECORD_TYPE" --arg name "$CF_RECORD_NAME" --arg content "$IP" --argjson proxied "$PROXIED" \
      '{type: $type, name: $name, content: $content, proxied: $proxied}')
  # Mostrar el JSON para depuración
  echo "Datos de solicitud: $DATA"
  # Actualizar el registro DNS con la nueva IP
  RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
       -H "Authorization: Bearer $CF_API_KEY" \
       -H "Content-Type: application/json" \
       --data "$DATA")
  
  echo "IP actualizada en Cloudflare. Respuesta: $RESPONSE"
fi
