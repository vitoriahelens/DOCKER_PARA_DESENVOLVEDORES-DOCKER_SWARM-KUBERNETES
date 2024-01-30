###EXECUTANDO O PROJETO COM O DOCKER
docker build -t vitoriahelens/flask-kub .
docker run -d -p 5000:5000 --name flask-kube --rm vitoriahelens/flask-kub
docker ps
######################################################################################################################################################################################################################################################################
# CONTAINER ID   IMAGE                                 COMMAND                  CREATED          STATUS          PORTS                                                                                                                                  NAMES        #
# 29b5ed4d4f2d   vitoriahelens/flask-kub               "python3 ./app.py"       4 minutes ago    Up 4 minutes    0.0.0.0:5000->5000/tcp, :::5000->5000/tcp                                                                                              flask-kube   #
# 79c986897a5e   gcr.io/k8s-minikube/kicbase:v0.0.42   "/usr/local/bin/entr…"   37 minutes ago   Up 37 minutes   127.0.0.1:32777->22/tcp, 127.0.0.1:32776->2376/tcp, 127.0.0.1:32775->5000/tcp, 127.0.0.1:32774->8443/tcp, 127.0.0.1:32773->32443/tcp   minikube     #
######################################################################################################################################################################################################################################################################

###ENVIANDO A IMAGEM PRO HUB
docker login -u vitoriahelens
docker push vitoriahelens/flask-kub

###CRIANDO O DEPLOYMENT
kubectl create deployment flask-deployment --image=vitoriahelens/flask-kub
minikube dashboard --url #Abre a URL

kubectl get deployments
###########################################################
# NAME               READY   UP-TO-DATE   AVAILABLE   AGE #
# flask-deployment   1/1     1            1           6m  #
###########################################################

kubectl describe deployments
#####################################################################################################################
# Name:                   flask-deployment                                                                          #
# Namespace:              default                                                                                   #
# CreationTimestamp:      Tue, 23 Jan 2024 09:48:00 -0300                                                           #       
# [...]                                                                                                             #
# Events:                                                                                                           #
#   Type    Reason             Age    From                   Message                                                #
#   ----    ------             ----   ----                   -------                                                #
#   Normal  ScalingReplicaSet  6m23s  deployment-controller  Scaled up replica set flask-deployment-59568d4d54 to 1 #
#####################################################################################################################

kubectl get pods
##########################################################################
# NAME                                READY   STATUS    RESTARTS   AGE   #
# flask-deployment-59568d4d54-m7zb8   1/1     Running   0          9m11s # 
##########################################################################

kubectl describe pods
###############################################################################################################################################
# Name:             flask-deployment-59568d4d54-m7zb8                                                                                         #
# Namespace:        default                                                                                                                   #
# Priority:         0                                                                                                                         #
# [...]                                                                                                                                       #
# Events:                                                                                                                                     #
#   Type    Reason     Age    From               Message                                                                                      #
#   ----    ------     ----   ----               -------                                                                                      #
#   Normal  Scheduled  9m18s  default-scheduler  Successfully assigned default/flask-deployment-59568d4d54-m7zb8 to minikube                  #
#   Normal  Pulling    9m17s  kubelet            Pulling image "vitoriahelens/flask-kub"                                                      #
#   Normal  Pulled     8m55s  kubelet            Successfully pulled image "vitoriahelens/flask-kub" in 22.512s (22.512s including waiting)   #
#   Normal  Created    8m55s  kubelet            Created container flask-kub                                                                  #
#   Normal  Started    8m55s  kubelet            Started container flask-kub                                                                  #
###############################################################################################################################################

###CRIANDO UM SERVICE
kubectl expose deployment flask-deployment --type=LoadBalancer --port=5000
minikube service flask-deployment
##############################################################################
# |-----------|------------------|-------------|---------------------------| #
# | NAMESPACE |       NAME       | TARGET PORT |            URL            | #
# |-----------|------------------|-------------|---------------------------| #
# | default   | flask-deployment |        5000 | http://000.000.00.0:31441 | #
# |-----------|------------------|-------------|---------------------------| #
# 🎉  Opening service default/flask-deployment in default browser...         #
##############################################################################

kubectl get services
##########################################################################################
# NAME               TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   #
# flask-deployment   LoadBalancer   00.000.000.00   <pending>     5000:31441/TCP   17m   #
# kubernetes         ClusterIP      00.00.0.0       <none>        443/TCP          3d18h #
##########################################################################################

kubectl describe services/flask-deployment
##################################################
# Name:                     flask-deployment     #
# Namespace:                default              #
# Labels:                   app=flask-deployment #
# [...]                                          #
# External Traffic Policy:  Cluster              #
# Events:                   <none>               #
##################################################

###REPLICANDO A APLICAÇÃO
kubectl scale deployment/flask-deployment --replicas=3
kubectl get pods
########################################################################
# NAME                                READY   STATUS    RESTARTS   AGE #
# flask-deployment-59568d4d54-2rqrx   1/1     Running   0          12s #
# flask-deployment-59568d4d54-m7zb8   1/1     Running   0          67m #
# flask-deployment-59568d4d54-vmp5l   1/1     Running   0          12s #
########################################################################

kubectl get rs
#################################################################
# NAME                          DESIRED   CURRENT   READY   AGE #
# flask-deployment-59568d4d54   3         3         3       69m #
#################################################################

###DIMINUINDO AS REPLICAS
kubectl scale deployment/flask-deployment --replicas=2

###ATUALIZANDO A IMAGEM
docker build -t vitoriahelens/flask-kub:2 .
docker push vitoriahelens/flask-kub:2
# dashboard > pods > clica na pod mais antiga > containers > copia o nome
kubectl set image deployment/flask-deployment flask-kub=vitoriahelens/flask-kub:2 
