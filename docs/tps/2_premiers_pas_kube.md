<p class="kicker">TP 2 · Module 02</p>

# Premiers pas sur Kubernetes

<div class="fiche" markdown>
<div markdown>
Objectifs

- Déployer une application sur Kubernetes
- Comprendre la syntaxe des objets Kubernetes
- Utiliser l'outil `kubectl`
</div>
<div markdown>
Livrables

- [ ] Les manifests Kubernetes pour déployer l'application
- [ ] Un compte rendu : difficultés rencontrées et résultats
</div>
<div markdown>
Prérequis

- Un compte SSP Cloud
- L'image de l'API Python publiée sur Docker Hub (TP 1)
</div>
</div>

## Déploiement d'une API Python

Comme présenté dans le cours, l'objectif est de déployer **3 replicas** de notre application « Hello World ».

Vous pouvez réutiliser l'image Docker construite et envoyée sur Docker Hub lors du TP 1.

Vous commenterez brièvement chaque élément de vos manifests afin de montrer votre bonne compréhension.

Bonne chance !

!!! warning "Pas de Service pour l'instant"

    Votre application n'est pas encore exposée d'un point de vue réseau : il vous faudra trouver un moyen de la tester quand même.

    Si ChatGPT (ou un autre assistant) vous indique de créer un Service, ce n'est pas la solution attendue.
