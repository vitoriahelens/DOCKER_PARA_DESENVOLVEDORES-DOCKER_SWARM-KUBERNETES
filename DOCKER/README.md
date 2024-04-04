<img src="docker.png" alt="150" width="150"/>

# Docker

> O Docker é uma plataforma de virtualização de contêineres que permite aos desenvolvedores empacotar e executar aplicativos em qualquer lugar. Com o Docker, é possível criar, implantar e executar aplicativos em contêineres, que são unidades de software leves e portáteis que incluem todas as dependências necessárias para executar um aplicativo.
> 

### **O que é:**

É um software que reduz a complexidade de setup de aplicação, onde configuramos containers, que são como servidores para rodas nossas aplicações, com facilidade, criamos ambientes independente que funcionam em diversos SO’s, e ainda deixa os projetos performáticos.

### **Por que Docker?**

O Docker proporciona mais velocidade na configuração do ambiente de um dev, gasta pouco tempo em manutenção, eles vao ser executados como são configurados, a performance é melhor que VM, no livra da Matrix From Hell (passar pela instalação de todos os componentes em diferentes maquinas/servidores/ambiente cloud). 

### **O que são containers:**

É um pacote de código que pode executar uma ação, como por exemplo, rodar uma aplicação de Node.js, Python e etc;

Container == Isolamento

Você isola toda a aplicação dentro da máquina, de modo que várias aplicações podem rodar na mesma máquina, e o ideal é que outras aplicações não dividam o recurso, ou não se enxerguem.

- **namespaces (Módulo do Kernel Linux):** Responsável por fazer o isolamento de todos os recursos da aplicação. Ex.: Filesystem, Processos, Network, Usuários e etc.
- **cgroups (Módulo do Kernel Linux):** Responsável por fazer o isolamento/limitação dos recursos da máquina. Ex.: CPU, memória e etc.
- **chroot:** é uma operação que altera o diretório raiz aparente para o processo atual de execução e seus filhos.

### **Para construir a imagem do container que será executado é necessário um Dockerfile**
#### [Dockerfile](/DOCKER/Dockerfile) 

**CONCEITOS**

- **CONTAINER x IMAGEM**
    - **Imagem**: projeto que será executado pelo container, toda as instruções estão declaradas nela
    - **Container**: é o docker rodando alguma imagem, consequentemente, executando algum código proposto por ela
- **CONTAINER x VM**
    - **Container** é uma aplicação que serve para um determinado fim, não possui sistema operacional, seu tamanho é de alguns mbs
    - **VM** possui sistema operacional próprio, pode executar diversas funções ao mesmo tempo
    
    *Quando estamos utilizando máquinas virtuais, nós emulamos um novo sistema operacional e virtualizamos todo o seu hardware utilizando mais recursos da máquina host, o que não ocorre quando utilizamos containers, pois os recursos são compartilhados. O ganho óbvio disso é a capacidade de rodar mais containers em um único host, se comparado com a quantidade que se conseguiria com máquinas virtuais.*

```docker
##EXECUTANDO UM CONTAINER
docker run nome_da_imagem cowsay hello_world

###EXECUTANDO EM BACKGROUND COM UMA PORTA ESPECIFICA
docker run -d -p 80:80 nginx //a primeira porta é a que eu quero expor no pc, a outra é a do container

##LISTANDO CONTAINERS
docker ps 
docker ps -a //mostra todos os container que ja rodaram na maquina

##STARTANDO UM CONTAINER
docker start name_ou_id

##PARANDO UM CONTAINER
docker stop name_ou_id

##ENTRANDO NO CONTAINER
docker exec -it id bash

###NOMEANDO UM CONTAINER
docker run -d -p 80:80 --name testenginx nginx
docker rename CONTAINER NEW_NAME

###APAGANDO UM CONTAINER
docker rm id
```

```docker
##EXECUTANDO UM CONTAINER COM ENVS ESPECIFICAS
docker pull dpage/pgadmin4
docker run -p 80:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    -d dpage/pgadmin4
```

```docker
##COPIANDO ARQUIVOS DO CONTAINET PARA A MAQUINA
docker cp container:/diretorionocontainer/arquivo ./pastadestino/
```

- **OBSERVABILIDADE NO CONTAINER**
    
    ```docker
    ###VERIFICANDO LOGS DO CONTAINER
    docker logs id
    docker logs -f id //atualiza automaticante os logs quando vc mexe no container, por ex, dando f5 na pagina
    
    ###VERIFICANDO O PROCESSAMENTO DO CONTAINER
    docker stats
    
    ###VERIFICANDO OS DADOS DE UM CONTAINER
    docker inspect nomedocontainer
    
    ###VERIFICANDO INFORMAÇÕES DE PROCESSAMENTO
    docker top nomedocontainer
    ```
    
- **VOLUMES**
    
    Uma forma prática de persistir dados em aplicações e não depender de containers para isso, visto que todo dado criado por um container é salvo nele, quando o caontainer é removido perdermos os dados, então precisamos de volumes para gerenciar esses dados e fazer backups de forma simples.
    
    Tipos de volume:
    
    - Anonymous: Criados pela flag -v, com um nome aleatório
    
    ```jsx
    docker run -d -p 80:80 --name phpmessages_container --rm -v /data phpmessages
    ```
    
    - Named: Volumes com nomes que podem ser referenciados facilmente
    
    ```jsx
    docker run -d -p 80:80 --name phpmessages_container -v phpvolume:/var/www/html/messages --rm phpmessages
    ```
    
    - Bind Mounts: Salva dados na nossa máquina sem gerenciamento do docker
        
        Com o Bind Mount é possível persistir os dados e ainda fazer alterações no projeto. 
        
    
    ```jsx
    docker run -d -p 80:80 --name phpmessages_container -v caminhodapasta\messages:/var/www/html/messages --rm phpmessages
    ```
    
    ```docker
    ###LISTANDO VOLUMES
    docker volume ls
    ```
    
    ```docker
    ###INSPECIONANDO VOLUMES
    docker inspect volume nomedovolume
    ```
    
    ```docker
    ###REMOVENDO VOLUMES
    docker volume rm nomedovolume
    docker volume prune
    ```
    
- **NETWORKS**
    - uma forma de gerenciar a conexão do docker com outras plataformas ou até mesmo entre containers
    - São criadas separadas do container
    
    Tipos de conexão:
    
    - Externa: com uma api de um servidor remoto
    - Com o host: comunicação com a máquina q executa o docker
    - Entre container: conexão que utiliza o driver bridge e permite a comunicação entre dois ou mais containers
    DRIVERS:
    - Bridge: Utilizados quando os containers precisam se conectar
    - Host: permite a conexão entre um container e a máquina que está hosteando o docker
    - Macvlan: permite a conexão a um container por um mac address
    - None: remove todas conexões de rede de um container
    - Plugins: Permite extensões de terceiros para criar outras redes
    
    ```jsx
    docker network ls //verificar todas as redes do ambiente
    
    docker network create name //cria como rede bridge
    docker network create -d macvlan name //cria uma rede com outro drive
    
    docker network rm name //remove uma rede
    docker network prune //remove todas as redes nao utilizadas
    ```
    
    ```jsx
    docker network connect *rede container*
    docker network disconnect *rede container*
    
    docker network inspect name
    ```

### **Para criar um ambiente de desenvolvimento subindo banco de dados e a aplicação é utilizado o Docker Compose**
#### [Docker Compose](/DOCKER/DockerCompose) 

### **Para orquestrar containers a nível de Infraestrutura, é utilizado o Docker Swarm**
#### [Docker Swarm](/DOCKER/DockerSwarm) 
