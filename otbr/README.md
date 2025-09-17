# OpenThread Border Router (OTBR) Deployment

Este directorio contiene los manifiestos de Kubernetes para desplegar OpenThread Border Router (OTBR) en el namespace `domotica2`.

## Archivos

- `configmap.yaml` - Variables de entorno para la configuración de OTBR
- `deployment.yaml` - Deployment principal con contenedor OTBR y sidecar helper
- `pvc.yaml` - PersistentVolumeClaim para almacenamiento persistente
- `service.yaml` - Service LoadBalancer para acceso externo

## Configuración

### Dispositivo RCP Remoto
- **IP del dispositivo**: 192.168.50.18
- **Puerto**: 6638
- **Baudrate**: 460800
- **Protocolo**: spinel+hdlc+socket

### Acceso Externo
- **IP LoadBalancer**: 192.169.2.15
- **Interfaz Web**: http://192.169.2.15
- **Puertos UDP**: 49191 (Commissioner), 49192 (Joiner), 5683 (CoAP)

## Sidecar Container

El deployment incluye un contenedor sidecar (`config-helper`) para troubleshooting y configuración:

### Características del Sidecar
- **Imagen**: alpine:latest
- **Herramientas instaladas**: nano, vim, curl, wget, netcat, tcpdump, bind-tools
- **Acceso**: Mismo volumen de datos que el contenedor principal
- **Variables de entorno**: Mismas que el contenedor OTBR

### Uso del Sidecar

#### Acceder al sidecar cuando OTBR está en crashloop:
```bash
kubectl exec -it -n domotica2 deployment/otbr -c config-helper -- /bin/sh
```

#### Verificar conectividad al dispositivo RCP:
```bash
kubectl exec -it -n domotica2 deployment/otbr -c config-helper -- nc -zv 192.168.50.18 6638
```

#### Verificar variables de entorno:
```bash
kubectl exec -it -n domotica2 deployment/otbr -c config-helper -- env | grep OT_
```

#### Editar archivos de configuración en /data:
```bash
kubectl exec -it -n domotica2 deployment/otbr -c config-helper -- nano /data/otbr-agent.conf
```

#### Verificar logs del contenedor principal:
```bash
kubectl logs -n domotica2 deployment/otbr -c otbr
```

## Despliegue

```bash
kubectl apply -f /home/juanjocop/Documentos/Proyectos/k3s-local-apps-manifests/otbr/
```

## Troubleshooting

### Si OTBR no se conecta al RCP:
1. Verificar conectividad desde el sidecar
2. Comprobar que el dispositivo esté accesible en 192.168.50.18:6638
3. Revisar logs del contenedor principal

### Si el pod no inicia:
1. Verificar que el PVC esté bound
2. Comprobar que la IP del LoadBalancer esté disponible
3. Usar el sidecar para investigar problemas de configuración

### Modificar configuración:
1. Editar el ConfigMap: `kubectl edit configmap otbr-config -n domotica2`
2. Reiniciar el deployment: `kubectl rollout restart deployment/otbr -n domotica2`
