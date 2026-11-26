<p class="kicker">Debug lab 3 · Module 02</p>

# La disparition silencieuse 

!!! failure "Contexte"

    Votre équipe a déployé une petite API FastAPI qui permet aux utilisateurs de déposer des fichiers. Chaque dépôt renvoie un code `201 Created` et la liste des fichiers déposés est consultable sur `/files`.

    Pourtant, les utilisateurs se plaignent : **après quelques dépôts, leurs fichiers ont disparu**. Aucune erreur ne leur a été renvoyée, l'API répond toujours, et rien d'anormal n'apparaît dans les logs de l'application.

    **Votre mission** : comprendre où sont passés les fichiers et corriger le déploiement.

<div class="fiche" markdown>
<div markdown>
Livrables

- [ ] Un compte rendu : diagnostic, commandes utilisées et captures d'écran illustrant votre démarche de debug
- [ ] Le manifest corrigé
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- Avoir suivi les TP 1, 2, 3 et 4
- Le code de l'API : [:material-folder-zip-outline: upload-api.zip](../ressources/upload-api.zip)
</div>
</div>

## Étape 1 : construction de l'image

Récupérez l'archive `upload-api.zip`. Elle contient le code de l'API et un `Dockerfile` prêt à l'emploi.

Construisez l'image et poussez-la sur votre registry, comme au TP 1.

L'API expose trois routes :

| Route | Description |
|---|---|
| `GET /health` | Vérifie que l'API répond |
| `POST /upload` | Dépose un fichier (champ de formulaire `file`) dans le répertoire `UPLOAD_DIR` |
| `GET /files` | Liste les fichiers déposés et leur taille |

## Étape 2 : déploiement

Créez un fichier `debug-lab-stockage.yaml` avec le contenu suivant, en remplaçant `<votre-image>` par l'image construite à l'étape précédente, et appliquez-le dans votre namespace :

```yaml title="debug-lab-stockage.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: upload-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: upload-api
  template:
    metadata:
      labels:
        app: upload-api
    spec:
      containers:
        - name: api
          image: <votre-image>
          ports:
            - containerPort: 8000
          env:
            - name: UPLOAD_DIR
              value: /data/uploads
          volumeMounts:
            - name: uploads
              mountPath: /data/uploads
      volumes:
        - name: uploads
          emptyDir:
            sizeLimit: 50Mi
---
apiVersion: v1
kind: Service
metadata:
  name: upload-api
spec:
  selector:
    app: upload-api
  ports:
    - port: 80
      targetPort: 8000
```

```bash
kubectl apply -f debug-lab-stockage.yaml
```

Vérifiez que le pod est à l'état `Running` avant de passer à la suite.

## Étape 3 : reproduire le problème

Depuis le terminal de votre service VSCode SSP Cloud (qui tourne dans le même namespace que l'API), créez un script `upload.sh` qui :

1. génère quatre fichiers de test de 20 Mo ;
2. les dépose un par un en laissant quelques secondes entre chaque dépôt, puis affiche la liste des fichiers ;
3. affiche à nouveau la liste des fichiers trois minutes plus tard.

```bash title="upload.sh"
#!/bin/bash

# 1. Génération des fichiers de test
for i in 1 2 3 4; do
  dd if=/dev/urandom of=fichier-$i.bin bs=1M count=20
done

# 2. Dépôt des fichiers, puis consultation de la liste
for i in 1 2 3 4; do
  curl -s -F "file=@fichier-$i.bin" http://upload-api/upload
  echo
  sleep 20
done

curl -s http://upload-api/files
echo

# 3. Nouvelle consultation de la liste quelques minutes plus tard
sleep 180
curl -s http://upload-api/files
```

Rendez le script exécutable et lancez-le :

```bash
chmod +x upload.sh
./upload.sh
```

!!! question "À traiter dans le compte rendu"

    - Quels codes de retour avez-vous obtenus lors des dépôts ?
    - Quels fichiers apparaissent dans `/files` juste après les dépôts, puis trois minutes plus tard ? Est-ce cohérent avec ce qui a été déposé ?

## Étape 4 : diagnostic

Effectuez un diagnostic complet pour comprendre ce qui est arrivé aux fichiers. Votre compte rendu doit expliquer :

- ce qui s'est passé côté Kubernetes, et à quel moment ;
- pourquoi ni l'utilisateur ni les logs de l'application n'ont signalé d'erreur ;
- quel composant de Kubernetes est à l'origine du comportement observé.

## Étape 5 : résolution

Corrigez le manifest pour que les fichiers déposés survivent au remplissage de l'espace de stockage **et** à la suppression du pod. Justifiez vos choix (type de volume, taille, nombre de réplicas).

Rejouez le scénario de l'étape 3 et incluez une capture d'écran montrant que tous les fichiers sont présents.

!!! question "Pour aller plus loin"

    Avec votre correction, que se passe-t-il si l'on dépose plus de fichiers que la capacité du volume ? Quelle réponse reçoit l'utilisateur, et dans quel état le dernier fichier est-il laissé sur le disque ? Que faudrait-il modifier dans le code de l'API pour mieux gérer ce cas ?
