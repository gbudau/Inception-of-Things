# Instrucciones

Hay 3 scripts:
- install.sh -> Instala todas las dependencias necesarias para correr K3d (necesario correrlo en equipos nuevos)
- startup.sh -> Inicia el cluster y despliega ArgoCD
- stop.sh -> Destruye el cluster

## Apuntes

Differencia entre K3s y K3d:
- k3s: kubernetes ligero
- k3d: kubernetes dockerizado para simular despliegues de nodos

Basicamente k3s seria un cluster de kubernetes mas ligero mientras que k3d sirve para simular un cluster mas complejo con k3s y dentro de contenedores.

Comandos necesarios:
install k3d

```
sudo apt install curl
sudo apt install wget
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

install docker

1 step
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

2 step
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
