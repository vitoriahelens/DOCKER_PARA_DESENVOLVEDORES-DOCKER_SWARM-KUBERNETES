### **O que é Kubernetes?**

O Kubernetes é uma ferramenta de orquestração de containers que permite a criação de múltiplos containers em diferentes máquinas (nodes/nós). Ele escala projetos formando um cluster e gerencia serviços garantindo que as aplicações sejam executadas sempre da mesma forma.

**CONCEITOS FUNDAMENTAIS:**

**Control Plane:** Onde é gerenciado o controle dos processos dos Nodes

**Nodes**: Máquinas que são gerenciadas pelo Control Plane

**Deployment**: A execução de uma imagem/projeto em um Pod

**Pod**: Um ou mais containers que estão em um Node

**Services**: Serviços que expõe os Pods ao mundo externo

**kubectl**: Cliente da linha de comando para o Kubernetes

**DEPENDENCIAS NECESSÁRIAS:**

**Client:** kubectl

**Minikube:** simulador de Kubernetes (várias máquinas em uma só)

```docker
###CONFIGURAÇÕES DO KUBERNETES

kubectl config view
```

**MINIKUBE:**

É uma ferramenta que permite realizar operações básicas de inicialização para trabalhar com Kubernetes localmente. *Não recomendado para produção.*

Possíveis drivers: virtualbox, hyperv e docker

*Obs.: Sempre que o computador for reiniciado, deveremos iniciar o minikube.*

```docker
###INICIANDO O MINIKUBE
minikube start --driver=<driver>

###VERIFICANDO O STATUS
minikube status

###PARANDO O MINIKUBE
minkube stop

###VERIFICANDO O DASHBOARD
minikube dashboard --url
```

- **Possíveis erros:**
    
    ```docker
    ##O docker não está startado ou não possui permissão
    systemctl start docker
    sudo usermod -aG docker $USER && newgrp docker
    ```
    

**FLUXO:**

```docker
1. Cria a aplicação 
2. Builda a Imagem
3. Disponibiliza no Hub
4. Cria um deployment baseado na imagem
5. Cria um service

```

> Os comandos a seguir estão relacionados ao uso do kubernetes em modo imperativo, onde a aplicação é iniciado com comandos.

### [MODO IMPERATIVO](/KUBERNETES/modo-imperativo/modo-imperativo.sh)

**DEPLOYMENT:**

Com o Deployment criamos nosso serviço que vai rodar nos **Pods,** definimos uma imagem e um nome, para que posteriormente seja replicado entre os servidores, e daí a partir dessa criação teremos containers rodando. 

Ao deletar um deployment, o container não estará mais executando, pois os Pods foram parados. Assim, caso queira acessar algum projeto é necessário criar-los novamente.

```docker
###CRIANDO UM DEPLOYMENT
kubectl create deployment <nome> --image=<contadohub>/<repos>

###VERIFICANDO O DEPLOYMENT
kubectl get deployments

###MAIS DETALHES
kubectl describe deployments

###DELETANDO UM DEPLOYMENT
kubectl delete deployment <nome>
```

**PODS:**

Ao criar um Deployment, os Pods são criados automaticamente. São onde os containers são realmente executados.

```docker
###VERIFICANDO OS PODS
kubectl get pods

###MAIS DETALHES
kubectl describe pods
```

**SERVICES:**

As aplicações do Kubernetes não tem conexão com o mundo externo, e por isso é necessário criar um service, que é o que possibilita expor os pods. Isso acontece pois os Pods são criados para serem destruídos e perderem tudo, ou seja, os dados gerados neles também são apagados. 

Então o *service é uma entidade separada dos pods que expõem eles a uma rede*.

Existem vários tipos de service mas o mais utilizado é o LoadBalancer.

Quando um service é deletado, os Pods não tem mais conexão externa.

```docker
###CRIANDO O SERVICE
kubectl expose deployment <nomedodeploymentcriado> --type=<tipo> --port=<porta>

###GERANDO O IP DE ACESSO
minikube service <nome>

###VERIFICANDO OS SERVICES
kubectl get services

###MAIS DETALHES
kuctl describe services/<nomedoservico>

###REPLICANDO A APLICAÇÃO
kubectl scale deployment/<nome> --replicas=<numero>

###CONSULTANDO O STATUS DAS REPLICAS
kubectl get rs

###DIMINUINDO AS REPLICAS
kubectl scale deployment/<nome> --replicas<numero-menor>

###DELETANDO UM SERVICE
kubectl delete service <nome>
```

**ATUALIZAÇÃO DE IMAGEM:**

Para isso, é necessário o nome do container, que é dado na Dashboard dentro do Pod. 

A outra imagem deve ser uma outra versão da atual, ou seja, é necessário subir uma nova tag no hub.

```docker
###ATUALIZANDO A IMAGEM
kubectl set image deploymente/<nomedodeployment> <nome_container>=<nova_imagem>
```

**ROLLBACK NA ALTERAÇÃO:**

É possível voltar uma alteração que foi feita em uma imagem, para isso utilizamos os seguintes comandos:

```docker
###VERIFICANDO UMA ALTERAÇÃO
kubectl rollout status deployment/<nome>

###VOLTANDO A ALTERAÇÃO
kubectl rollout undo deployment/<nome>
```

---

### [MODO DECLARATIVO](/KUBERNETES/modo-declarativo/modo-declarativo.sh)

O modo declarativo no Kubernetes envolve o uso de um arquivo .YAML, onde deixamos as configurações mais simples e centralizamos tudo em um comando.

**CHAVES MAIS UTILIZADAS**

**apiVersion**: versão utilizada da ferramenta(necessário ver a que mais se adequa ao projeto)

**kind**: tipo do arquivo (Deployment, Service)

**metadata**: descrever algum objeto, inserindo chaves como name

**replicas**: número de réplicas de Nodes/Pods

**containers**: definir as especificações de containers como: nome e imagem

**ARQUIVO DE DEPLOYMENT:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: 
  name: flask-app-deployment #nome do aplicativo referente a esse deployment
spec: #especificações da aplicação
  replicas: 4
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec: #especificações do container
      containers:
        - name: flask
          image: vitoriahelens/flask-kub:2
```

**EXECUTANDO O KUBERNETES PELO ARQUIVO:**

```yaml
#INICIANDO O DEPLOYMENT
kubectl apply -f <nome_do_arquivo>

#PARANDO O DEPLOYMENTE
kubectl delete -f <nome_do_arquivo>
```

Obs.: Ao chamar o comando para parar, ele vai parar todos os que estiverem nesse yaml.

**ARQUIVO DE SERVICE:**

```yaml
apiVersion: v1
kind: Service
metadata: 
  name: flask-service
spec:
  selector:
    app: flask-app #link entre o service e o deployment
  ports:
    - protocol: 'TCP'
      port: 5000
      targetPort: 5000
  type: LoadBalancer
```

Obs.: O nome do app deve ser o mesmo especificado no arquivo de deployment.

**EXECUTANDO O KUBERNETES PELO ARQUIVO:**

```yaml
#INICIANDO O SERVICE
kubectl apply -f <nome_do_arquivo>

## GERANDO O IP DO SERIVCE
minikube service <nome_do_servico>

#PARANDO O SERVICE
kubectl delete -f <nome_do_arquivo>
```

Obs.: É necessário gerar o ip de acesso do service.

**ATUALIZANDO O PROJETO NO MODO DECLARATIVO**

Criada uma nova versão da imagem do projeto, faz o push para o Hub, depois altera a tag no arquivo de Deployment, reaplica o comando apply.

```yaml
docker build -t vitoriahelens/flask-kub:3 . 
docker push vitoriahelens/flask-kub:3
# No arquivo deployment.yaml altera a imagem
kubectl apply -f deployment.yaml
```

Obs.: Não é necessário parar nada, apenas da um apply novamente.

**FAZENDO TUDO EM UM ÚNICO ARQUIVO**

Basta adicionar o conteúdo de ambos com um separador ‘---’

```yaml
---
apiVersion: v1
kind: Service
metadata: 
  name: flask-service
spec:
  selector:
    app: flask-app #link entre o service e o deployment
  ports:
    - protocol: 'TCP'
      port: 5000
      targetPort: 5000
  type: LoadBalancer

---
apiVersion: apps/v1
kind: Deployment
metadata: 
  name: flask-app-deployment #nome do aplicativo referente a esse deployment
spec: #especificações da aplicação
  replicas: 4
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec: #especificações do container
      containers:
        - name: flask
          image: vitoriahelens/flask-kub:3
```

Obs.: É uma boa prática adicionar o Service antes do Deployment.

```yaml
#INICIANDO TUDO
kubectl apply -f <nome_do_arquivo>

#PARANDO TUDO
kubectl delete -f <nome_do_arquivo>
```
