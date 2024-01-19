<img src="icon.png" alt="150" width="150"/>

# Docker Swarm

**O que é Orquestração de Containers:**
É o ato de conseguir gerenciar e escalar os containers da nossa aplicação. Um serviço que rege sobre outros serviços (um container que gerencia os demais containers), verificando se eles estão funcionando como deveriam, assim conseguimos garantir uma aplicação saudável e tambem que esteja sempre disponível.

**O que é o Docker Swarm:**

Uma ferramenta do Docker para orquestrar containers, podendo escalar horizontalmente nossos projetos de maneira simples, o famoso **************cluster**************. 

**CONCEITOS FUNDAMENTAIS**

- **Nodes**: uma instancia (maquina) que participa do Swarm;
- **Manager Node:** Node principal que gerencia os demais (node pai);
- **Worker Node:** Nodes que trabalham em função do Manager (nodes filhos, replicam o manager em suas máquinas);
- **Service:** Conjunto de Tasks que o Manager Node manda o Work Node executar (containers como serviços);
- **Task:** comandos que são executados nos Nodes (o manager executa tarefas para os workers).

*Obs.:* Ao usar o docker swarm leave, a instância não é contada mais como um Node para o swarm. Caso so tenha uma máquina, é necessário utilizar a flag -f.

```docker
##INICIA O SWARM
docker swarm init
docker swarm init --advertise-addr #caso seja necessario declarar o IP da maquina

##PARA O SWARM
docker swarm leave -f

##CHECANDO O SWARM
docker info
```

******************************NODES******************************

Ao criar um novo Node, as duas máquinas se conectam.

A segunda máquina entra na hierarquia como um worker, e todas as tasks são replicadas em nodes que são adicionadas com *****join.*****

Para fazer um determinado node não receba mais Tasks, mudamos o status dele para *drain*, e para que ele volte ao normal, mudamos para *****active*****. Quando fazemos isso, uma instância que não está em drain recebe dois containers da mesma imagem para rodar, desse modo ela vai continuar executando a mesma quantidade. 

```docker
##LISTANDO NODES ATIVOS
docker node ls

##CHECANDO O TOKEN DO SWARM
docker swarm join-token manager

###ADICIONANDO NOVO NODE 
docker swarm join --token <token> <ip>:<porta>

##REMOVENDO UM NODE
docker node rm <id>

##FAZER COM QUE UM SERVIÇO NÃO RECEBA MAIS ATUALIZAÇÃO
docker node update --availability drain <***iddoservidor>***

##FAZER COM QUE UM SERVIÇO VOLTE A RECEBER ATUALIZAÇÃO
docker node update --availability active <***iddoservidor>***
```

**********************************SERVIÇOS (dentro do node)**********************************

Um novo container é adicionado ao Manager, e este serviço é gerenciado pelo swarm. 

Ao remover um container de um node worker, o swarm reinicia o container (sobe uma replica nova) pois o serviço ainda está rodando no manager, desse modo ele garante que os serviços estejam sempre disponíveis. 

*******Obs.: Os comandos devem ser executados dentro da instância Manager.*******

```docker
###SUBINDO UM NOVO SERVIÇO
docker service create --name <nome> -p 80:80 <imagem>

###LISTANDO SERVIÇOS EM EXECUÇÃO
docker service ls

###REMOVENDO UM SERVIÇO
docker service rm <nome>

###REPLICANDO SERVIÇOS
docker service create --name <nome> --replicas <numero> -p 80:80 <imagem>

###REMOVENDO UM CONTAINER 
docker container rm *id* -f

###INSPECIONANDO SERVIÇO
docker service inspect <id>

###VERIFICANDO QUAIS CONTAINERS ESTAO RODANDO
docker service ps <iddoserviço>

###ATUALIZAÇÃO PARÂMETRO
docker service update --image <imagem> <servico>
```

**COMPOSE COM SWARM**

```docker
docker stack deploy -c <arquivo.yaml> <nome>
```

Podemos criar novas réplicas nos Worker Nodes, desta forma as outras máquinas receberão as tasks a serem executads.

```docker
docker service scale <nome>=<num_replicas>
```

**NETWORK**

Serve para isolar serviços. Usa um driver chamado overlay.

```docker
###CRIANDO REDE PARA O SWARM
docker network create --driver overlay swarm
docker service create --name <nome> --replicas <nº> -p 80:80 --network swarm <imagem>

###CONECTAR SERVIÇO A UMA REDE EXISTENTE
docker service update --network-add <rede> <nome>
```