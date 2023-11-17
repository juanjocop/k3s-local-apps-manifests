# Usa una imagen base de Debian
FROM debian:latest

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Descargar e instalar Bitcoin Core 25.0 para ARM64
RUN wget https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-aarch64-linux-gnu.tar.gz && \
    tar -xzvf bitcoin-25.0-aarch64-linux-gnu.tar.gz -C /opt && \
    ln -s /opt/bitcoin-25.0/bin/bitcoind /usr/local/bin/bitcoind && \
    ln -s /opt/bitcoin-25.0/bin/bitcoin-cli /usr/local/bin/bitcoin-cli && \
    rm bitcoin-25.0-aarch64-linux-gnu.tar.gz

# Copiar el archivo de configuración de Bitcoin
COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

# Exponer el puerto (cambia esto según tu configuración)
EXPOSE 8333

# Ejecutar bitcoind
CMD ["bitcoind"]
