#/bin/bash

#Eh possivel ver os arquivos acessando o localhost, mas nao na pasta, entao se eu excluir o container, eu perco as mensagens
docker build -t phpmessages .
docker run -d -p 80:80 --name phpmessages_container phpmessages

#VOLUME ANONIMO


