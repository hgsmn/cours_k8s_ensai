---
marp: true
theme: cours
paginate: true
footer: 'ENSAI · Kubernetes · 2026'
---

<!-- _class: lead -->
<!-- _paginate: skip -->
<!-- _footer: '' -->

# Kubernetes : déployer ses applications facilement et de manière fiable

Formation ENSAI · 2026
Hugo Simon

`$ kubectl apply -f formation.yaml`

---

<!-- header: 'Présentation' -->

## Qui suis-je ?

- **Hugo Simon** · *Architecte IA*
- Parcours : *ML Engineer - Architecte applicatif*
- Au quotidien : *LLMOps, Kubernetes*
- Contact : *hugo.simon@insee.fr*

---

<!-- _class: cards -->

## Objectifs de la formation

- **Conteneuriser**\
  Packager une application et ses dépendances dans une image Docker.
- **Comprendre**\
  L'architecture de Kubernetes et le rôle de chacun de ses composants.
- **Déployer**\
  Mettre une application en production sur Kubernetes et tirer parti de ses atouts.

---

<!-- _class: checklist -->

## Prérequis techniques

- Disposer d'un compte sur le **SSP Cloud**
- Avoir **Docker** ou **Podman** installé sur son poste personnel

> Vérifiez ces deux points **avant le premier TP** : `docker run hello-world` doit fonctionner.

---

## Organisation du cours

Le cours est découpé en **modules**, chacun accompagné de **TP** pour pratiquer directement les notions abordées.

- Théorie courte, pratique longue
- Un **compte rendu** à rédiger pour chaque TP

> Les comptes rendus de TP constituent votre **base d'évaluation** sur ce module.

---

<!-- _class: steps -->

## Programme

1. **Conteneurisation**\
   Rappels sur Docker et les images
   `TP 1`
2. **Déploiement simple**\
   Pods, services, persistance
   `TP 2 → 4`
3. **Résilience**\
   Mises à jour, montée en charge
   `TP 5, 6, 8`
4. **Packaging**\
   Industrialiser avec Helm
   `TP 7`

---

<!-- _class: divider -->
<!-- header: '' -->

`01`

# Introduction

Pourquoi déployer sur un cluster ?

---

<!-- _class: centered -->
<!-- header: 'Introduction' -->

## Comment déployer son application ?

Votre application fonctionne en local. Et maintenant ?

---

<!-- _class: cards reveal-1 -->

## Où faire tourner l'application ?

- **Ordinateur personnel**\
  Fonctionne, mais doit rester allumé 24 h/24, 7 j/7 et n'est pas dimensionné pour un trafic croissant (réseau, matériel).
- **Un serveur**\
  Mieux : disponible en continu. Mais une seule machine ne suffit plus quand le nombre d'utilisateurs augmente.
- **Plusieurs serveurs**\
  Répartition de la charge et tolérance aux pannes… à condition de savoir les orchestrer.

---

<!-- _class: cards reveal-2 -->

## Où faire tourner l'application ?

- **Ordinateur personnel**\
  Fonctionne, mais doit rester allumé 24 h/24, 7 j/7 et n'est pas dimensionné pour un trafic croissant (réseau, matériel).
- **Un serveur**\
  Mieux : disponible en continu. Mais une seule machine ne suffit plus quand le nombre d'utilisateurs augmente.
- **Plusieurs serveurs**\
  Répartition de la charge et tolérance aux pannes… à condition de savoir les orchestrer.

---

<!-- _class: cards reveal-3 -->

## Où faire tourner l'application ?

- **Ordinateur personnel**\
  Fonctionne, mais doit rester allumé 24 h/24, 7 j/7 et n'est pas dimensionné pour un trafic croissant (réseau, matériel).
- **Un serveur**\
  Mieux : disponible en continu. Mais une seule machine ne suffit plus quand le nombre d'utilisateurs augmente.
- **Plusieurs serveurs**\
  Répartition de la charge et tolérance aux pannes… à condition de savoir les orchestrer.

---

<!-- _class: centered -->

# Sur plusieurs serveurs !

Reste à savoir *comment* y faire tourner nos applications.

---

<!-- _class: compact -->

## Plusieurs méthodes de déploiement

| Méthode | Principe | Points forts | Limites |
|---|---|---|---|
| Bare metal | Exécution directe sur le serveur physique | Performances maximales | Complexe à gérer, peu flexible |
| Machine virtuelle | Un hyperviseur (VMware, KVM…) isole plusieurs OS sur une même machine | Isolation forte | OS complet par VM : lourd, démarrage lent |
| Conteneur | Applications isolées partageant le noyau de l'hôte (Docker, Podman…) | Léger, démarrage rapide, reproductible | Isolation plus faible qu'une VM |

---

## Conteneurs vs machines virtuelles

![h:330 center](assets/container_vm.png)

> Le conteneur embarque **l'application et ses dépendances**, pas un système d'exploitation complet.

---

<!-- _class: cards -->

## Pourquoi Kubernetes devient la norme ?

- **Scalabilité**\
  Les conteneurs démarrent en quelques secondes : on ajuste le nombre d'instances à la charge.
- **Reproductibilité**\
  La même image et la même configuration déclarative, du poste du développeur à la production.
- **Standard du cloud**\
  Disponible chez tous les fournisseurs : souvent présenté comme « l'OS du cloud ».

---

<!-- _class: grid-4 -->

## Les Twelve-Factor Apps

12 principes pour construire des applications **modernes**, **scalables** et **maintenables**.

1. Base de code unique
2. Dépendances déclarées
3. Configuration *→ ConfigMap*
4. Services externes
5. Build, release, run
6. Processus sans état *→ Pod*
7. Exposition par port *→ Service*
8. Concurrence *→ réplicas*
9. Jetable *→ redémarrage*
10. Parité dev / prod
11. Logs en flux *→ stdout*
12. Tâches d'admin *→ Job*

---

<!-- _class: centered -->

## Pour aller plus loin

Les 12 principes détaillés : [12factor.net](https://12factor.net/)

> Les principes surlignés sont ceux que Kubernetes outille directement : nous les retrouverons en TP.
