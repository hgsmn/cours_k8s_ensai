<p class="kicker">TP 3 · Module 02</p>

# Exposons notre application sur Internet

<div class="fiche" markdown>
<div markdown>
Objectifs

- Exposer notre application sur le réseau du cluster
- Exposer notre application sur Internet
- Déployer une application 3 tiers complète
</div>
<div markdown>
Livrables

- [ ] Les manifests Kubernetes pour déployer les applications
- [ ] Un compte rendu : difficultés rencontrées et résultats de chaque exercice
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- L'application du TP 2 déployée
</div>
</div>

## Exposition sur le réseau du cluster

Votre objectif est maintenant d'exposer votre application sur le réseau interne au cluster.

Au précédent TP, il fallait entrer à l'intérieur du pod pour tester notre application. Ici, nous voulons que l'application soit accessible depuis notre namespace.

Dans le compte rendu de cet exercice, incluez les captures d'écran des commandes permettant :

- d'afficher l'adresse réseau de notre application,
- de montrer un test fonctionnel de notre application.

## Exposition sur Internet

Nous allons plus loin : vous voulez désormais offrir les services de votre magnifique application au monde entier en l'exposant sur Internet.

Dans le compte rendu de cet exercice, incluez les captures d'écran des commandes permettant :

- de lister les objets Ingress,
- de montrer un test fonctionnel de notre application depuis votre poste de travail.

!!! warning "Nom de domaine"

    Les URL doivent toujours se terminer par `.lab.sspcloud.fr`.

## Déploiement d'une application 3 tiers

L'idée est de déployer une application complète avec un **frontend**, un **backend** et une **base de données**. Il faut donc refaire les différentes étapes des TP 2 et 3 afin d'exposer l'application.

Les images à utiliser :

| Composant | Image |
|---|---|
| Frontend | `hugosmn5/frontend-3-tier:1.1` |
| Backend | `hugosmn5/backend-3-tier:1.1` |
| Base de données | `postgres:13` |

Les variables d'environnement à définir dans le **backend** :

```yaml
env:
  - name: DB_USER
    value: "admin"
  - name: DB_PASS
    value: "password"
  - name: DB
    value: "reviews"
  - name: DB_HOST
    value: "<nom du service postgresql>"
```

Et pour la **base PostgreSQL** :

```yaml
env:
  - name: POSTGRES_USER
    value: "admin"
  - name: POSTGRES_PASSWORD
    value: "password"
  - name: POSTGRES_DB
    value: "reviews"
```

!!! info "Bon à savoir"

    - Le port d'une base de données PostgreSQL est `5432`.
    - L'application frontend s'appuie entièrement sur le nom de service `backend`.
