# Usa una imagen base compatible con ARM64
FROM arm64v8/debian:latest

# Instala Tor
RUN apt-get update && \
    apt-get install -y tor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copia la configuración de Tor (debes crear este archivo)
COPY torrc /etc/tor/torrc

# Exponer el puerto que Tor usará
EXPOSE 9050

# Ejecutar Tor
CMD ["tor"]
