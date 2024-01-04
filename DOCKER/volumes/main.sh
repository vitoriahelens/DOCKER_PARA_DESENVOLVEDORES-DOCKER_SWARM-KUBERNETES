#/bin/bash

#Eh possivel ver os arquivos acessando o localhost, mas nao na pasta, entao se eu excluir o container, eu perco as mensagens
docker build -t phpmessages .
docker run -d -p 80:80 --name phpmessages_container phpmessages

#VOLUME ANONIMO
docker run -d -p 80:80 --name phpmessages_container --rm -v /data phpmessages
docker inspect phpmessages_container

#VOLUME NOMEADO
##Ao exluir o container e criar novamente com o mesmo comando, o volume irá persistir, inclusive para o mesmo container em outra porta
docker run -d -p 80:80 --name phpmessages_container -v phpvolume:/var/www/html/messages --rm phpmessages #Diretorio do volume deve ser igual ao workdir
docker volume ls

#VOLUME BIND MOUNT
##Executa o container, e o que for inserido no formulário será salvo no diretório passado
docker run -d -p 80:80 --name phpmessages_container -v caminhodapasta\messages:/var/www/html/messages --rm phpmessages
docker volume ls