<p class="kicker">TP 4 · Module 02</p>

# Gestion de la persistance

<div class="fiche" markdown>
<div markdown>
Objectifs

- Comprendre les mécanismes de persistance dans Kubernetes
- Ajouter de la persistance à une application
- Déployer une application stateful
- Mettre en place une bonne pratique de sécurité avec un volume `emptyDir`
</div>
<div markdown>
Livrables

- [ ] Les manifests Kubernetes pour déployer les applications
- [ ] Un compte rendu : difficultés rencontrées et résultats de chaque exercice
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- L'application 3 tiers du TP 3
</div>
</div>

## Activer la persistance sur notre application

Comme vous avez pu le voir lors du précédent TP, notre base de données n'a aucune persistance : dès qu'on la supprime, les données sont perdues.

Votre objectif est donc de passer d'un **Deployment** à un **StatefulSet** pour la base de données, et de vérifier la persistance des données.

Dans le compte rendu, une démonstration de l'intérêt du StatefulSet par rapport au Deployment dans notre cas d'usage est attendue.

## EmptyDir : filesystem read-only et répertoire temporaire

Dans cet exercice, nous allons combiner deux bonnes pratiques de sécurité :

- monter le filesystem du conteneur en **lecture seule** (`readOnlyRootFilesystem: true`),
- fournir un volume `emptyDir` sur `/tmp` pour que l'application puisse continuer à écrire ses fichiers temporaires.

### Étape 1 : observer le problème

Modifiez le Deployment de votre API Python pour ajouter un `securityContext` en lecture seule :

```yaml
containers:
  - name: api
    image: <votre-image>
    securityContext:
      readOnlyRootFilesystem: true
```

Appliquez le manifest et observez l'état du pod. Que se passe-t-il ? Consultez les logs pour comprendre l'erreur.

### Étape 2 : résoudre avec un emptyDir

L'application a besoin d'écrire dans `/tmp` (fichiers temporaires, cache Python, etc.). Ajoutez un volume `emptyDir` monté sur `/tmp` :

```yaml
containers:
  - name: api
    image: <votre-image>
    securityContext:
      readOnlyRootFilesystem: true
    volumeMounts:
      - name: tmp
        mountPath: /tmp
volumes:
  - name: tmp
    emptyDir: {}
```

Appliquez le manifest et vérifiez que le pod démarre correctement.

### Étape 3 : vérification

!!! question "À traiter dans le compte rendu"

    - Pourquoi est-ce une bonne pratique de monter le filesystem en lecture seule ?
    - Que deviennent les données du volume `emptyDir` lorsque le pod est supprimé ?
    - Quelle est la différence entre un `emptyDir` et un `PersistentVolumeClaim` ?
