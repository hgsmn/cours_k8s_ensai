<p class="kicker">TP 5 · Module 03</p>

# Mettons à jour nos applications

<div class="fiche" markdown>
<div markdown>
Objectifs

- Comprendre et mettre en place une stratégie de RollingUpdate
- Configurer des readiness et liveness probes
- Observer le comportement d'une mise à jour progressive
- Effectuer un rollback
</div>
<div markdown>
Livrables

- [ ] Les manifests Kubernetes mis à jour
- [ ] Un compte rendu : difficultés rencontrées et résultats de chaque exercice
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- L'API Python du TP 2 déployée avec son Service et son Ingress (TP 3)
</div>
</div>

## Exercice 1 : ajout des probes

Notre application Python expose une route `/hello`. Cependant, elle ne dispose d'aucune route dédiée au health check. Nous allons y remédier.

### Étape 1 : ajouter un endpoint de health check

Modifiez votre application Python pour ajouter une route `/health` qui retourne un statut 200 :

```python
@app.get("/health")
def health():
    return {"status": "ok"}
```

Construisez une nouvelle image Docker avec ce changement et poussez-la sur Docker Hub avec le tag **v2** (en conservant votre image précédente en **v1**).

### Étape 2 : configurer les probes dans le Deployment

Mettez à jour votre manifest de Deployment pour ajouter les probes suivantes :

| Probe | Route | Port | `initialDelaySeconds` | `periodSeconds` |
|---|---|---|---|---|
| `readinessProbe` | `/health` | 8000 | 5 | 5 |
| `livenessProbe` | `/health` | 8000 | 10 | 10 |

Appliquez votre manifest et vérifiez que les probes fonctionnent correctement.

### Étape 3 : observer le comportement des probes

!!! question "À traiter dans le compte rendu"

    - Que se passe-t-il si la readiness probe échoue ?
    - Que se passe-t-il si la liveness probe échoue ?
    - Pourquoi l'`initialDelaySeconds` de la liveness probe est-il plus grand que celui de la readiness probe ?

## Exercice 2 : RollingUpdate

L'objectif de cet exercice est de comprendre et d'utiliser le mécanisme de RollingUpdate.

Vous devrez donc :

- mettre en place ce mécanisme afin d'ajouter un endpoint `/ensai`,
- tester les différentes commandes autour de la mise à jour (`kubectl rollout`).
