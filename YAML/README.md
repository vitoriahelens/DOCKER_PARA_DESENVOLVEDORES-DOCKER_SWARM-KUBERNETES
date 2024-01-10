# YAML (YAML ain’t a Markup Language)

.yml ou .yaml

> Usada para arquivos de configuração, como Docker Compose e Kubernetes

### estrutura

```
nomedachave: valor
```

### Espaçamento e identação

- O fim de uma linha indica o fim de uma instrução, não há ponto e vírgula
- A identação deve conter um ou mais espaços e não deve utilizar tab
- Cada linha define um novo bloco
- O espaço é obrigatório após a declaração da chave se não ele não vai entender o valor

```
python3 app.py
```

O que deve sair da execução do python:
```
nome : Vitoria
idade : 22
objeto : {'versao': 2, 'arquivo': 'teste.txt'}
inteiro : 12
float : 12.4
sem_aspas : este eh um texto valido
com_aspas : e este tambem
nulo : None
nulo_2 : None
verdadeiro_1 : True
verdadeiro_2 : True
falso_1 : False
falso_2 : False
lista_1 : [1, 2, 3, 'vivi', False]
lista_2 : [1, 2, 3, 'vivi', True]
obj : {'a': 1, 'b': 'vivi', 3: False}
obj_2 : {'a': 1, 'b': 2, 'objeto_interno': {'x': 2}}
```