<p class="kicker">Debug lab 1 · Module 02</p>

# Le Service qui perd des requêtes

!!! failure "Contexte"

    Vous venez d'arriver dans une équipe qui a déployé une API derrière un Service Kubernetes. L'équipe précédente a mis en place deux Deployments différents derrière un même Service pour assurer la montée en charge.

    Cependant, les utilisateurs remontent un comportement étrange : **une requête sur deux échoue** de manière aléatoire.

    **Votre mission** : identifier et corriger le problème.

<div class="fiche" markdown>
<div markdown>
Livrables

- [ ] Un compte rendu : réponses aux questions, commandes utilisées et captures d'écran illustrant votre démarche de debug
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- Avoir suivi les TP 2 et 3
</div>
</div>

## Étape 1 : déploiement

Créez un fichier `debug-lab-service.yaml` avec le contenu suivant et appliquez-le dans votre namespace :

```yaml title="debug-lab-service.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-alpha
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mon-api
  template:
    metadata:
      labels:
        app: mon-api
    spec:
      containers:
        - name: api
          image: hashicorp/http-echo
          args:
            - "-listen=:5678"
            - "-text=Reponse du deploiement Alpha"
          ports:
            - containerPort: 5678
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-beta
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mon-api
  template:
    metadata:
      labels:
        app: mon-api
    spec:
      containers:
        - name: api
          image: hashicorp/http-echo
          args:
            - "-listen=:8080"
            - "-text=Reponse du deploiement Beta"
          ports:
            - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: mon-api
  ports:
    - port: 80
      targetPort: 5678
```

```bash
kubectl apply -f debug-lab-service.yaml
```

Vérifiez que tous les pods sont à l'état `Running` avant de passer à la suite.

## Étape 2 : diagnostic

Dans cette étape, effectuez un diagnostic complet et exhaustif de l'erreur.

## Étape 3 : résolution

Corrigez le manifest, appliquez-le et relancez la boucle de requêtes. Incluez une capture d'écran montrant que toutes les requêtes aboutissent.
