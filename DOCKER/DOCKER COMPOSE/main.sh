#INSTALAÇÃO DO COMPOSE NO LINUX
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version

#EXECUTANDO O COMPOSE
docker compose up -d #roda em modo detached (background)
localhost:8000 #vai aparecer o wordpress instalado
docker compose down #para o container
docker compose ps #mostra serviços que sobem ao rodar o compose
