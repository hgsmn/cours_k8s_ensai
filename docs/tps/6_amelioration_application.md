<p class="kicker">TP 6 · Module 03</p>

# Amélioration de notre application 3 tiers

<div class="fiche" markdown>
<div markdown>
Objectifs

- Reprendre l'application 3 tiers pour la rendre plus robuste
- Mobiliser de nouveaux objets Kubernetes
</div>
<div markdown>
Livrables

- [ ] Les manifests Kubernetes améliorés
- [ ] Un compte rendu explicitant la démarche
</div>
<div markdown>
Prérequis

- L'application 3 tiers des TP 3 et 4 : [:material-folder-zip-outline: 3tier.zip](../ressources/3tier.zip)
</div>
</div>

## Axes d'amélioration

L'idée de ce TP est de reprendre notre application 3 tiers afin de l'améliorer en ajoutant des objets Kubernetes. Voici des axes que vous pouvez explorer :

- [ ] Créer un objet **Secret** pour stocker les informations sensibles (username / password)
- [ ] Mettre en place un **init container** pour alimenter la base de données de l'application
- [ ] Mettre en place des **probes** pour assurer la disponibilité de l'application
- [ ] Définir des **ressources** afin d'implémenter une QoS `Guaranteed`
- [ ] Mettre en place un **headless service** pour la base de données

## Pour les plus motivés

!!! example "Clustering PostgreSQL"

    Mettre en place du clustering sur les bases de données PostgreSQL. Cette partie peut être assez longue à réaliser, mais peut constituer un petit projet annexe pour découvrir le monde des bases de données et leur déploiement dans le cloud.
