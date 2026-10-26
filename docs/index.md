---
hide:
  - navigation
  - toc
---

<div class="hero" markdown>

# Kubernetes : Comment déployer facilement ses applications avec fiabilité ? 

Formation ENSAI · Hugo Simon

`$ kubectl apply -f learning-k8s.yaml`

</div>

## Objectifs

<div class="grid cards" markdown>

-   **Conteneuriser**

    ---

    Packager une application et ses dépendances dans une image Docker.

-   **Comprendre**

    ---

    L'architecture de Kubernetes et le rôle de chacun de ses composants.

-   **Déployer**

    ---

    Mettre une application en production sur Kubernetes et tirer parti de ses atouts.

</div>

## Programme

Chaque module associe un cours (diapositives consultables en ligne ou en PDF) et des TP pour pratiquer directement.

<div class="grid cards" markdown>

-   <span class="module-num">00</span> · **Introduction**

    ---

    Pourquoi déployer sur un cluster ? Bare metal, VM, conteneurs, Twelve-Factor Apps.

    <span class="links">[:material-presentation: Diapos](slides/intro.html) · [:material-file-pdf-box: PDF](slides/intro.pdf)</span>

-   <span class="module-num">01</span> · **Conteneurisation**

    ---

    Dockerfile, layers et cache, multi-stage build, registry, bonnes pratiques de sécurité.

    <span class="links">[:material-presentation: Diapos](slides/docker.html) · [:material-file-pdf-box: PDF](slides/docker.pdf) · [:material-flask-outline: TP 1](tps/1_docker.md)</span>

-   <span class="module-num">02</span> · **Déploiement simple**

    ---

    Architecture, Pods, Deployments, Services, Ingress, ConfigMap, persistance, CRD et opérateurs.

    <span class="links">[:material-presentation: Diapos](slides/kubernetes.html) · [:material-file-pdf-box: PDF](slides/kubernetes.pdf) · </span>

    <span class="links">[:material-flask-outline: TP 2](tps/2_premiers_pas_kube.md) · [TP 3](tps/3_exposition_application.md) · [TP 4](tps/4_gestion_de_la_persistance.md) · [:material-bug-outline: Debug labs](tps/debug_lab_1_service.md)</span>

-   <span class="module-num">03</span> · **Résilience**

    ---

    Rolling updates, probes, CD et GitOps ; autoscaling, placement des pods, QoS et PDB.

    <span class="links">[:material-presentation: Mises à jour](slides/kube_maj.html) · [PDF](slides/kube_maj.pdf) · [:material-presentation: Haute dispo](slides/kube_hd.html) · [PDF](slides/kube_hd.pdf)</span>

    <span class="links">[:material-flask-outline: TP 5](tps/5_mise_a_jour_application.md) · [TP 6](tps/6_amelioration_application.md) · [TP 8](tps/8_hpa.md)</span>

-   <span class="module-num">04</span> · **Packaging**

    ---

    Charts, values, templates, dépendances : industrialiser ses déploiements avec Helm.

    <span class="links">[:material-presentation: Diapos](slides/helm.html) · [:material-file-pdf-box: PDF](slides/helm.pdf)  [:material-flask-outline: TP 7](tps/7_helm.md) · [:material-database-outline: Mémo PostgreSQL](slides/postgresql.html) </span>

</div>

## Avant de commencer

<div class="grid" markdown>

!!! info "Prérequis techniques"

    - [ ] Disposer d'un compte sur le **SSP Cloud**
    - [ ] Avoir **Docker** ou **Podman** installé sur son poste personnel

    Vérifiez ces deux points **avant le premier TP** : `docker run hello-world` doit fonctionner.

!!! abstract "Organisation et évaluation"

    Le cours alterne théorie courte et pratique longue. Chaque TP donne lieu à un **compte rendu** (démarche, commandes, difficultés rencontrées, résultats).

    Les comptes rendus de TP constituent votre **base d'évaluation** sur ce module.

</div>
