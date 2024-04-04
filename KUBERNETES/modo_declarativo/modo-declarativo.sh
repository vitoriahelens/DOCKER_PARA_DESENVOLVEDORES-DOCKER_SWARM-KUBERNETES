### COMANDOS PARA EXECUÇÃO DO KUBERNETES EM MODO DECLARATIVO (USANDO ARQUIVO YAML)
# EXECUTAR APÓS A CRIAÇÃO DO ARQUIVO.YAML

## CRIANDO O DEPLOYMENT
minikube start
kubectl apply -f deployment.yaml
################################################
# deployment.apps/flask-app-deployment created #
################################################

## PARANDO O DEPLOYMENT
kubectl delete -f deployment.yaml
################################################
# deployment.apps/flask-app-deployment deleted #
################################################

## CRIANDO O SERVICE
minikube start
kubectl apply -f service.yaml
#################################
# service/flask-service created #
#################################

## GERANDO O IP DO SERIVCE
minikube service flask-service
#########################################################################
#|-----------|---------------|-------------|---------------------------|#
#| NAMESPACE |     NAME      | TARGET PORT |            URL            |#
#|-----------|---------------|-------------|---------------------------|#
#| default   | flask-service |        5000 | http://192.168.49.2:32093 |#
#|-----------|---------------|-------------|---------------------------|#
#🎉  Opening service default/flask-service in default browser...        #
#########################################################################

## PARANDO O DEPLOYMENT
kubectl delete -f service.yaml
###################################
# service "flask-service" deleted #
###################################

##ATUALIZANDO O PROJETO
#EDITA O CODIGO
docker build -t vitoriahelens/flask-kub:3 . 
docker push vitoriahelens/flask-kub:3
# No arquivo deployment.yaml altera a imagem
kubectl apply -f deployment.yaml
###################################################
# deployment.apps/flask-app-deployment configured #
###################################################

###UNIFICANDO OS ARQUIVOS
# cria um novo arquivo contendo o conteúdo dos dois com separador ---
kubectl apply -f kube.yaml
################################################
# service/flask-service created                #
# deployment.apps/flask-app-deployment created #
################################################
