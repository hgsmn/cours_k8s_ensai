---
marp: true
theme: cours
paginate: true
title: "Haute disponibilité dans Kubernetes"
footer: 'ENSAI · Haute disponibilité · 2025-2026'
---

<!-- _class: lead -->
<!-- _paginate: skip -->
<!-- _footer: '' -->

# Haute disponibilité dans Kubernetes

Scaling, placement et résilience

`kubectl get hpa --watch`

---

<!-- _class: steps -->

## Plan

1. **HPA, KEDA et VPA**\
   Adapter les ressources à la charge
2. **Affinity / Anti-affinity**\
   Distribuer les pods intelligemment
3. **QoS et PDB**\
   Résister aux perturbations

---

<!-- _class: divider -->

`01`

# HPA, KEDA et VPA

Objectif : adapter automatiquement les ressources de nos applications en fonction de la charge.

---

<!-- header: 'Autoscaling' -->

## Pourquoi l'autoscaling ?

Un nombre fixe de replicas pose problème :
- **trop peu** : l'application sature sous la charge,
- **trop** : gaspillage de ressources et de coûts.

Kubernetes propose plusieurs mécanismes pour adapter automatiquement la capacité.

---

## Les 3 approches de scaling

| Approche | Mécanisme | Quoi ? |
|----------|-----------|--------|
| **HPA** | Horizontal Pod Autoscaler | Ajuste le nombre de pods |
| **VPA** | Vertical Pod Autoscaler | Ajuste les ressources (CPU/RAM) d'un pod |
| **KEDA** | Event-driven Autoscaler | Scale sur des événements externes |

---

<!-- _class: centered -->
<!-- header: 'HPA' -->

## HPA : Horizontal Pod Autoscaler

---

## HPA : principe

Le HPA ajuste automatiquement le nombre de replicas d'un Deployment ou StatefulSet en fonction de métriques observées.

**Boucle de contrôle** :
1. Le HPA interroge le Metrics Server (toutes les 15 s par défaut)
2. Compare la valeur actuelle à la valeur cible
3. Calcule le nombre de replicas nécessaires
4. Ajuste le Deployment

---

## HPA : prérequis

Pour que le HPA fonctionne, il faut :

- le **Metrics Server** installé dans le cluster (ou un équivalent comme Prometheus Adapter),
- des **requests** définies sur les conteneurs (pour le scaling CPU/mémoire).

```bash
# Vérifier que le Metrics Server est installé
kubectl top nodes
kubectl top pods
```

---

## HPA : formule de calcul

```
replicas = ceil(current_replicas * (current_metric / target_metric))
```

**Exemple** :
- 3 replicas actuels, CPU moyen = 80 %, cible = 50 %
- `ceil(3 * (80/50))` = `ceil(4.8)` = **5 replicas**

---

<!-- _class: code-sm -->

## HPA : exemple basique (CPU)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: mon-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mon-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

<!-- _class: code-sm -->

## HPA : multi-métriques

Quand plusieurs métriques sont définies, le HPA prend le **maximum** des replicas calculés.

```yaml
spec:
  # scaleTargetRef : identique à l'exemple précédent
  minReplicas: 2
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

---

<!-- _class: code-sm -->

## HPA : comportement de scaling

Le HPA permet de contrôler la vitesse du scale-up et du scale-down pour éviter le « flapping » (oscillation).

```yaml
spec:
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Pods
        value: 4
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

---

## HPA : bonnes pratiques

- Toujours définir des **requests** sur les conteneurs
- Définir un **minReplicas >= 2** pour la haute disponibilité
- Utiliser un **stabilizationWindow** pour le scale-down (éviter les oscillations)
- Ne **pas combiner HPA et VPA** sur la même métrique (CPU par exemple)
- Prévoir une marge entre le target et les limits

---

## HPA : commandes utiles

```bash
# Voir l'état du HPA
kubectl get hpa

# Détails du HPA
kubectl describe hpa mon-app-hpa

# Créer un HPA rapidement (impératif)
kubectl autoscale deployment mon-app \
  --min=2 --max=10 --cpu-percent=70
```

---

<!-- _class: centered -->
<!-- header: 'VPA' -->

## VPA : Vertical Pod Autoscaler

---

## VPA : principe

Le VPA ajuste automatiquement les **requests et limits** CPU/mémoire des conteneurs.

**Fonctionnement** :
1. **Recommender** : analyse l'historique de consommation et recommande des valeurs
2. **Updater** : évince les pods dont les ressources sont mal dimensionnées
3. **Admission Controller** : injecte les bonnes valeurs au démarrage du pod

---

## VPA : modes de fonctionnement

| Mode | Comportement |
|------|-------------|
| **Off** | Calcule les recommandations mais ne les applique pas |
| **Initial** | Applique les recommandations uniquement à la création du pod |
| **Auto** | Applique les recommandations et redémarre les pods si nécessaire |

---

<!-- _class: code-sm -->

## VPA : exemple

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: mon-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: mon-app
  updatePolicy:
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
    - containerName: app
      minAllowed:
        cpu: "100m"
        memory: "128Mi"
      maxAllowed:
        cpu: "2"
        memory: "4Gi"
```

---

## VPA : limites

- **Redémarre les pods** pour appliquer les nouvelles ressources (pas de resize in-place pour le moment)
- Ne doit **pas être utilisé avec le HPA sur la même métrique**
- Le VPA n'est **pas installé par défaut** dans Kubernetes
- Fonctionne mieux pour les applications dont la charge est **stable mais mal dimensionnée**

---

## VPA : cas d'usage

- Applications dont les **besoins en ressources sont difficiles à estimer**
- Optimisation des coûts : identifier les pods **sur-provisionnés**
- Mode **Off** utile pour obtenir des recommandations sans impact

```bash
# Voir les recommandations VPA
kubectl describe vpa mon-app-vpa
```

---

<!-- _class: centered -->
<!-- header: 'KEDA' -->

## KEDA : Kubernetes Event-Driven Autoscaler

---

## KEDA : pourquoi ?

Le HPA est limité aux métriques CPU/mémoire (ou custom metrics avec un adaptateur).

**KEDA** permet de scaler sur des **événements externes** :
- longueur d'une file de messages (RabbitMQ, Kafka, SQS…),
- nombre de requêtes HTTP,
- métriques Prometheus custom,
- tâches en attente dans une base de données,
- et bien d'autres (60+ scalers disponibles).

---

<!-- _class: code-sm -->

## KEDA : architecture

```
                    ┌─────────────┐
                    │   Source    │
                    │ (Kafka,     │
                    │  RabbitMQ,  │
                    │  Prometheus)│
                    └──────┬──────┘
                           │ métriques
                    ┌──────▼──────┐
                    │    KEDA     │
                    │  Operator   │
                    └──────┬──────┘
                           │ scale
                    ┌──────▼──────┐
                    │ Deployment  │
                    │ (0..N pods) │
                    └─────────────┘
```

> KEDA peut même scaler **de 0 à N** (scale-to-zero), contrairement au HPA natif.

---

<!-- _class: code-sm -->

## KEDA : ScaledObject

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: mon-app-scaledobject
spec:
  scaleTargetRef:
    name: mon-app
  minReplicaCount: 0
  maxReplicaCount: 30
  pollingInterval: 15
  triggers:
  - type: rabbitmq
    metadata:
      queueName: tasks
      queueLength: "5"
      host: amqp://rabbitmq.default.svc.cluster.local
```

Ici : 1 pod par tranche de 5 messages dans la queue.

---

<!-- _class: code-sm -->

## KEDA : exemple avec Prometheus

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: api-scaledobject
spec:
  scaleTargetRef:
    name: mon-api
  minReplicaCount: 1
  maxReplicaCount: 20
  triggers:
  - type: prometheus
    metadata:
      serverAddress: http://prometheus.monitoring:9090
      query: sum(rate(http_requests_total{app="mon-api"}[2m]))
      threshold: "100"
```

Scale en fonction du nombre de requêtes HTTP par seconde.

---

## KEDA : scalers populaires

| Scaler | Cas d'usage |
|--------|------------|
| **Kafka** | Consumers d'un topic |
| **RabbitMQ** | Workers de traitement |
| **Prometheus** | Métriques custom |
| **PostgreSQL** | Tâches en base |
| **Cron** | Scaling prévisible (horaires) |
| **HTTP** | Requêtes entrantes |

Liste complète : [keda.sh/docs/scalers](https://keda.sh/docs/scalers/)

---

<!-- header: 'Autoscaling' -->

## HPA vs VPA vs KEDA : résumé

| | HPA | VPA | KEDA |
|---|-----|-----|------|
| **Type** | Horizontal | Vertical | Horizontal |
| **Métriques** | CPU, mémoire, custom | CPU, mémoire | 60+ sources |
| **Scale to 0** | Non | Non | Oui |
| **Natif K8s** | Oui | Non (add-on) | Non (add-on) |
| **Cas d'usage** | Charge web classique | Optimisation ressources | Event-driven |

---

<!-- _class: divider -->
<!-- header: '' -->

`02`

# Affinity / Anti-affinity

Objectif : contrôler le placement des pods sur les nœuds pour améliorer la disponibilité et les performances.

---

<!-- header: 'Placement' -->

## Pourquoi contrôler le placement ?

Par défaut, le scheduler Kubernetes place les pods selon les ressources disponibles. Mais parfois on veut :
- **séparer** les replicas sur différents nœuds (anti-affinity),
- **rapprocher** certains pods pour réduire la latence (affinity),
- **cibler** des nœuds avec du matériel spécifique (GPU, SSD),
- **respecter** des contraintes réglementaires (zone géographique).

---

## Les mécanismes de placement

| Mécanisme | Rôle |
|-----------|------|
| **nodeSelector** | Placement simple par label |
| **Node Affinity** | Placement avancé sur les nœuds |
| **Pod Affinity** | Rapprocher des pods entre eux |
| **Pod Anti-affinity** | Séparer des pods entre eux |
| **Taints & Tolerations** | Réserver des nœuds |
| **Topology Spread** | Répartition équilibrée |

---

<!-- _class: code-sm -->

## nodeSelector : le plus simple

Placement basé sur les labels des nœuds.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  nodeSelector:
    gpu: "true"
    disktype: ssd
  containers:
  - name: ml-training
    image: training:v1
```

```bash
# Labelliser un nœud
kubectl label nodes worker-1 gpu=true disktype=ssd
```

---

<!-- _class: cards -->

## Node Affinity : plus expressif

- **Obligation (hard)**\
  `requiredDuringSchedulingIgnoredDuringExecution`\
  Le pod n'est placé que sur un nœud qui respecte la règle.
- **Préférence (soft)**\
  `preferredDuringSchedulingIgnoredDuringExecution`\
  Le scheduler privilégie les nœuds qui respectent la règle, sans l'imposer.

---

<!-- _class: code-sm -->

## Node Affinity : exemple (1/2)

Règle obligatoire : uniquement dans les zones `eu-west-1a` et `eu-west-1b`.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mon-app
spec:
  template:
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: topology.kubernetes.io/zone
                operator: In
                values:
                - eu-west-1a
                - eu-west-1b
```

---

<!-- _class: code-sm -->

## Node Affinity : exemple (2/2)

Préférence : de préférence sur un nœud `high-memory`.

```yaml
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 80
            preference:
              matchExpressions:
              - key: node-type
                operator: In
                values:
                - high-memory
      containers:
      - name: app
        image: mon-app:v1
```

---

## Node Affinity : opérateurs

| Opérateur | Signification |
|-----------|--------------|
| `In` | La valeur est dans la liste |
| `NotIn` | La valeur n'est pas dans la liste |
| `Exists` | Le label existe (peu importe la valeur) |
| `DoesNotExist` | Le label n'existe pas |
| `Gt` | Supérieur à (numérique) |
| `Lt` | Inférieur à (numérique) |

---

<!-- _class: code-sm -->

## Pod Affinity : rapprocher les pods

Placer des pods **proches** d'autres pods (même nœud, même zone…).

```yaml
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - cache-redis
        topologyKey: kubernetes.io/hostname
```

> Ici : le pod sera placé sur le **même nœud** qu'un pod ayant le label `app=cache-redis`.

---

<!-- _class: code-sm -->

## Pod Anti-affinity : séparer les pods (1/2)

Garantir que les replicas d'une application sont **répartis** sur différents nœuds ou zones.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-server
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: api-server
```

---

<!-- _class: code-sm -->

## Pod Anti-affinity : séparer les pods (2/2)

```yaml
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - api-server
            topologyKey: kubernetes.io/hostname
      containers:
      - name: api
        image: api-server:v1
```

> Chaque replica sera sur un **nœud différent**.

---

## topologyKey : la clé de répartition

Le `topologyKey` définit le périmètre de l'affinité / anti-affinité :

| topologyKey | Périmètre |
|-------------|-----------|
| `kubernetes.io/hostname` | Par nœud |
| `topology.kubernetes.io/zone` | Par zone de disponibilité |
| `topology.kubernetes.io/region` | Par région |

---

<!-- _class: code-sm -->

## Taints & Tolerations

Les **taints** marquent un nœud pour repousser les pods. Les **tolerations** permettent à certains pods d'ignorer ces taints.

```bash
# Ajouter une taint sur un nœud
kubectl taint nodes worker-gpu dedicated=gpu:NoSchedule
```

```yaml
# Pod qui tolère la taint
spec:
  tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoSchedule"
  containers:
  - name: ml-job
    image: ml-training:v1
```

---

## Taints : les effets

| Effet | Comportement |
|-------|-------------|
| **NoSchedule** | Aucun nouveau pod sans toleration |
| **PreferNoSchedule** | Évite le placement si possible |
| **NoExecute** | Expulse les pods existants sans toleration |

---

## Topology Spread Constraints

Répartir les pods de manière **équilibrée** entre les zones/nœuds.

```yaml
spec:
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app: mon-app
```

- **maxSkew** : écart maximum de pods entre deux zones
- **whenUnsatisfiable** : `DoNotSchedule` (hard) ou `ScheduleAnyway` (soft)

---

## Topology Spread : illustration

Avec `maxSkew: 1` sur 3 zones et 6 replicas :

```
Zone A    Zone B    Zone C
🟦 🟦     🟦 🟦     🟦 🟦     (équilibré)

Zone A    Zone B    Zone C
🟦 🟦 🟦  🟦 🟦     🟦        (skew = 2, NON autorisé)
```

---

<!-- _class: compact -->

## Anti-affinity vs Topology Spread

| | Pod Anti-affinity | Topology Spread |
|---|---|---|
| **Granularité** | Binaire (présent ou non) | Équilibrage (maxSkew) |
| **Flexibilité** | Moins flexible | Plus flexible |
| **Cas d'usage** | « Pas 2 pods sur le même nœud » | « Répartir équitablement » |
| **Scalabilité** | Limité au nombre de nœuds | Fonctionne avec beaucoup de pods |

---

## Bonnes pratiques de placement

- Utiliser **Pod Anti-affinity** pour les applications critiques (au minimum `preferred`)
- Préférer **Topology Spread** quand le nombre de replicas > nombre de nœuds
- Combiner **Taints + Node Affinity** pour isoler les workloads spéciaux (GPU, HPC)
- Utiliser les labels standard Kubernetes (`topology.kubernetes.io/zone`, etc.)

---

<!-- _class: divider -->
<!-- header: '' -->

`03`

# QoS et PDB

Objectif : garantir la stabilité des applications face aux perturbations.

---

<!-- header: 'QoS' -->

## QoS : Quality of Service

Kubernetes attribue automatiquement une **classe QoS** à chaque pod en fonction des requests et limits définies.

> Cette classe détermine **l'ordre d'éviction** quand un nœud manque de ressources.

---

<!-- _class: compact -->

## Les 3 classes QoS

| Classe | Condition | Priorité d'éviction |
|--------|-----------|---------------------|
| **Guaranteed** | requests = limits (CPU et mémoire) | Derniers évincés |
| **Burstable** | requests < limits (au moins un request défini) | Évincés après BestEffort |
| **BestEffort** | Aucun request ni limit | Premiers évincés |

---

## QoS Guaranteed

```yaml
containers:
- name: app
  image: mon-app:v1
  resources:
    requests:
      cpu: "500m"
      memory: "256Mi"
    limits:
      cpu: "500m"
      memory: "256Mi"
```

- requests **=** limits pour **tous** les conteneurs du pod
- **Dernier à être évincé** en cas de pression sur le nœud

---

## QoS Burstable

```yaml
containers:
- name: app
  image: mon-app:v1
  resources:
    requests:
      cpu: "250m"
      memory: "128Mi"
    limits:
      cpu: "1"
      memory: "512Mi"
```

- Au moins un request ou limit est défini, requests **<** limits
- Le pod peut utiliser plus de ressources que demandé (burst)

---

## QoS BestEffort

```yaml
containers:
- name: app
  image: mon-app:v1
  # Aucune section resources
```

- Aucun request ni limit défini
- **Premier à être évincé**
- À éviter pour les applications de production

---

## QoS : processus d'éviction

Quand un nœud est sous pression mémoire :

```
1. Éviction des pods BestEffort      (premiers)
2. Éviction des pods Burstable       (ensuite)
3. Éviction des pods Guaranteed      (en dernier recours)
```

Au sein d'une même classe, les pods consommant le plus au-delà de leurs requests sont évincés en premier.

---

## QoS : bonnes pratiques

- **Production** : toujours définir au minimum des requests
- **Applications critiques** : utiliser la classe **Guaranteed**
- **Applications non critiques** : Burstable est acceptable
- Ne jamais déployer en **BestEffort** en production

```bash
# Vérifier la classe QoS d'un pod
kubectl get pod mon-pod -o jsonpath='{.status.qosClass}'
```

---

<!-- _class: centered -->
<!-- header: 'PDB' -->

## PDB : PodDisruptionBudget

---

<!-- _class: cards -->

## Qu'est-ce qu'une perturbation ?

- **Volontaire**\
  Mise à jour d'un nœud (drain), autoscaling du cluster (suppression de nœud), maintenance planifiée.
- **Involontaire**\
  Crash matériel, panne réseau, OOM Kill.

> Le PDB protège contre les **perturbations volontaires**.

---

## PDB : principe

Un PodDisruptionBudget définit le **nombre minimum de pods** qui doivent rester disponibles (ou le nombre maximum indisponibles) pendant une perturbation volontaire.

```
Sans PDB :    🟦 🟦 🟦 → drain → ❌ ❌ ❌  (tous down)

Avec PDB :    🟦 🟦 🟦 → drain → 🟦 🟦 ❌  (min 2 up)
              (minAvailable: 2)
```

---

## PDB : exemple avec minAvailable

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api-server
```

Au moins **2 pods** doivent rester disponibles lors d'un drain de nœud.

---

## PDB : exemple avec maxUnavailable

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      app: api-server
```

Au maximum **1 pod** peut être indisponible à la fois.

---

<!-- _class: compact -->

## PDB : minAvailable vs maxUnavailable

| | minAvailable | maxUnavailable |
|---|---|---|
| **Sémantique** | Nombre minimum de pods up | Nombre maximum de pods down |
| **Avantage** | Garantie forte | S'adapte au nombre de replicas |
| **Inconvénient** | Si replicas = minAvailable, drain bloqué | Moins intuitif |
| **Recommandé** | Pour les petits déploiements | Pour les grands déploiements |

---

## PDB : pourcentage

On peut aussi utiliser des pourcentages :

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  maxUnavailable: "25%"
  selector:
    matchLabels:
      app: api-server
```

Avec 8 replicas : au maximum 2 pods indisponibles simultanément.

---

## PDB : cas pratique, drain d'un nœud

```bash
# Sans PDB : tous les pods du nœud sont évincés d'un coup
kubectl drain worker-2 --ignore-daemonsets

# Avec PDB : Kubernetes respecte le budget
# Il évince les pods un par un en attendant que
# les remplacements soient prêts
kubectl drain worker-2 --ignore-daemonsets
```

> Si le PDB ne peut pas être respecté, le drain **reste bloqué** jusqu'à ce que les conditions soient remplies.

---

<!-- _class: compact -->

## PDB : bonnes pratiques

- Toujours créer un PDB pour les **applications critiques**
- Préférer `maxUnavailable` pour les déploiements avec beaucoup de replicas
- Ne **jamais** mettre `minAvailable` = nombre total de replicas (bloque les drains)
- Combiner PDB + **Pod Anti-affinity** pour une vraie haute disponibilité
- Vérifier les PDB avant une opération de maintenance

```bash
kubectl get pdb                  # Lister les PDB
kubectl describe pdb api-pdb     # Vérifier l'état
```

---

<!-- header: '' -->

## Synthèse : haute disponibilité

Pour une application **vraiment** hautement disponible :

1. **HPA/KEDA** : adapter le nombre de pods à la charge
2. **Pod Anti-affinity** : répartir les pods sur différents nœuds/zones
3. **Topology Spread** : équilibrer la répartition entre les zones
4. **QoS Guaranteed** : protéger contre les évictions
5. **PDB** : protéger contre les perturbations volontaires
6. **Probes** : garantir la santé des pods

---

## Ressources utiles

- **HPA** : [kubernetes.io/docs/…/horizontal-pod-autoscale](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- **VPA** : [github.com/kubernetes/autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
- **KEDA** : [keda.sh](https://keda.sh/)
- **Affinity** : [kubernetes.io/docs/…/assign-pod-node](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- **PDB** : [kubernetes.io/docs/…/configure-pdb](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)

---

<!-- _class: tp -->

`TP 8`

## Autoscaling avec le HPA

Définir requests et limits, créer un HPA et observer le scale-up puis le scale-down.

---

<!-- _class: centered -->

# Questions ?
