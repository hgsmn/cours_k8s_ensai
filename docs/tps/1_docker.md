<p class="kicker">TP 1 · Module 01</p>

# Conteneurisation

<div class="fiche" markdown>
<div markdown>
Objectifs

- Maîtriser la construction d'images Docker
- Comprendre et utiliser les multi-stage builds
- Optimiser le processus de build et la taille des images
- Savoir exécuter et débugger des conteneurs
</div>
<div markdown>
Livrables

- [ ] Un Dockerfile pour chacun des deux exercices
- [ ] Un compte rendu : difficultés rencontrées et résultats de chaque exercice
</div>
<div markdown>
Prérequis

- Docker ou Podman installé
- Un compte Docker Hub pour pousser les images
</div>
</div>

## Exercice 1 : construire et exécuter une API Python

Dans cet exercice, vous allez conteneuriser et lancer une API Python en suivant le protocole suivant :

1. Récupérer le code de l'application Python : [:material-folder-zip-outline: python-api.zip](../ressources/python-api.zip)
2. Rédiger le Dockerfile associé
3. Documenter ce dernier en indiquant les layers importantes
4. Construire l'image avec Docker
5. Exécuter cette dernière
6. Faire un appel sur l'API
7. Consulter les logs de l'API
8. Pousser son image sur Docker Hub

## Exercice 2 : API Java, optimisation et multi-stage build

Dans ce second exercice, vous suivrez la même procédure que pour l'exercice précédent, avec le code de l'API Java : [:material-folder-zip-outline: java-api.zip](../ressources/java-api.zip).

Vous devrez cette fois mettre en place **deux stages** :

- le **build** de l'application avec un JDK,
- le **run** de l'application avec un JRE.

!!! tip "Pour comparer"

    Comparez la taille de l'image obtenue avec celle d'une image construite en un seul stage (`docker images`), et commentez l'écart dans votre compte rendu.
