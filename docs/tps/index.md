# Travaux pratiques

Les TP s'enchaînent : chacun réutilise ce qui a été construit au précédent. Gardez vos manifests d'un TP à l'autre.

| TP | Sujet | Notions | Module |
|---|---|---|---|
| [TP 1](1_docker.md) | Conteneurisation | Dockerfile, multi-stage, registry | 01 |
| [TP 2](2_premiers_pas_kube.md) | Premiers pas sur Kubernetes | Deployment, kubectl | 02 |
| [TP 3](3_exposition_application.md) | Exposer son application | Service, Ingress, application 3 tiers | 02 |
| [TP 4](4_gestion_de_la_persistance.md) | Gestion de la persistance | StatefulSet, PVC, emptyDir | 02 |
| [TP 5](5_mise_a_jour_application.md) | Mettre à jour ses applications | Probes, RollingUpdate, rollback | 03 |
| [TP 6](6_amelioration_application.md) | Améliorer l'application 3 tiers | Secrets, init containers, QoS | 03 |
| [TP 7](7_helm.md) | Packager avec Helm | Chart, dépendances, CloudNativePG | 04 |
| [TP 8](8_hpa.md) | Autoscaling | requests/limits, HPA | 03 |

## Debug labs

Deux exercices de diagnostic, à partir d'une situation cassée :

- [Lab 1 · Le Service qui perd des requêtes](debug_lab_1_service.md)
- [Lab 2 · Changement de mot de passe invalide](debug_lab_2_postgresql.md)

!!! abstract "Compte rendu"

    Chaque TP donne lieu à un compte rendu : démarche suivie, commandes utilisées, captures d'écran demandées, difficultés rencontrées et résultats. Ces comptes rendus constituent la base de l'évaluation.
