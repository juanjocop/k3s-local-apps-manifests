# Utiliza una imagen base ligera, en este caso Alpine
FROM alpine:latest

# Instala curl y jq, que son necesarios para tu script
RUN apk add --no-cache curl jq

# Crea un directorio de trabajo
WORKDIR /app

# Copia tu script al contenedor
COPY update-cloudflare-dns.sh /app/

# Otorga permisos de ejecución al script
RUN chmod +x /app/update-cloudflare-dns.sh

# Configura el contenedor para ejecutar tu script cuando inicie
CMD ["/app/update-cloudflare-dns.sh"]
