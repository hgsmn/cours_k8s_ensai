<p class="kicker">Debug lab 2 · Module 02</p>

# Changement de mot de passe invalide

!!! failure "Contexte"

    Votre équipe exploite une application composée d'une API Python et d'une base PostgreSQL sur Kubernetes. Suite à un audit de sécurité, il a été demandé de changer le mot de passe de la base de données.

    Un collègue a modifié les variables d'environnement dans les manifests Kubernetes et a redéployé l'ensemble. Depuis, **l'API n'arrive plus à se connecter à la base de données**.

    **Votre mission** : comprendre pourquoi et rétablir la connexion.

<div class="fiche" markdown>
<div markdown>
Livrables

- [ ] Un compte rendu : diagnostic, commandes utilisées et méthode de résolution proposée
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- Avoir suivi les TP 2, 3 et 4
</div>
</div>

## Étape 1 : déploiement

### Phase 1 : déploiement initial

Créez un fichier `debug-lab-pgsql.yaml` avec le contenu suivant et appliquez-le :

```yaml title="debug-lab-pgsql.yaml"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
          env:
            - name: POSTGRES_USER
              value: "admin"
            - name: POSTGRES_PASSWORD
              value: "password123"
            - name: POSTGRES_DB
              value: "appdb"
          ports:
            - containerPort: 5432
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: postgres-data
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
```

```bash
kubectl apply -f debug-lab-pgsql.yaml
```

Attendez que le pod PostgreSQL soit `Running`, puis vérifiez que la connexion fonctionne :

```bash
kubectl run pg-check --image=postgres:16 --rm -it -- \
  psql -h postgres-service -U admin -d appdb -c "SELECT 1;"
```

Quand le mot de passe est demandé, entrez `password123`. Vous devriez voir un résultat `SELECT 1`.

### Phase 2 : un collègue change le mot de passe

Votre collègue modifie le manifest pour changer le mot de passe. Appliquez cette nouvelle version :

```yaml title="debug-lab-pgsql-v2.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:16
          env:
            - name: POSTGRES_USER
              value: "admin"
            - name: POSTGRES_PASSWORD
              value: "secure_password_2026"
            - name: POSTGRES_DB
              value: "appdb"
          ports:
            - containerPort: 5432
          volumeMounts:
            - name: data
              mountPath: /var/lib/postgresql/data
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: postgres-data
```

```bash
kubectl apply -f debug-lab-pgsql-v2.yaml
```

Attendez que le nouveau pod soit `Running`, puis testez la connexion avec le **nouveau** mot de passe :

```bash
kubectl run pg-check2 --image=postgres:16 --rm -it -- \
  psql -h postgres-service -U admin -d appdb -c "SELECT 1;"
```

Quand le mot de passe est demandé, entrez `secure_password_2026`.

## Étape 2 : diagnostic

La connexion échoue avec le nouveau mot de passe. Effectuez un diagnostic complet pour comprendre pourquoi le changement de mot de passe n'a pas fonctionné.

## Étape 3 : résolution

Sans supprimer le PVC, proposez une méthode permettant de changer le mot de passe de la base PostgreSQL.
