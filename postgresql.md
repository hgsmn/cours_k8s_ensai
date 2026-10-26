---
marp: true
theme: cours
paginate: true
title: "PostgreSQL : les fondamentaux"
footer: 'ENSAI · PostgreSQL · 2026-2027'
---

<!-- _class: lead -->
<!-- _paginate: skip -->
<!-- _footer: '' -->

# PostgreSQL : les fondamentaux

*Formation ENSAI 2026-2027*

`psql -h localhost -U admin -d appdb`

---

<!-- header: 'PostgreSQL' -->

## PostgreSQL en bref

PostgreSQL est un système de gestion de bases de données **relationnelles** open source.

- Très utilisé en production (finance, statistique, web…)
- Support du SQL standard et des transactions ACID
- Extensible : types personnalisés, extensions (PostGIS, pgvector…)

---

## Image Docker officielle

Image : `postgres:<version>`

Variables d'environnement essentielles :

| Variable | Rôle |
|----------|------|
| `POSTGRES_USER` | Nom de l'utilisateur administrateur |
| `POSTGRES_PASSWORD` | Mot de passe de cet utilisateur |
| `POSTGRES_DB` | Nom de la base créée au démarrage |

**Port par défaut** : `5432`

---

## Arborescence des données

```
/var/lib/postgresql/data/       # Répertoire des données (PGDATA)
├── base/                       # Données des bases
└── pg_wal/                     # Journaux de transactions (WAL)
```

> C'est ce répertoire qu'il faudra **persister avec un volume** dans Kubernetes pour ne pas perdre les données au redémarrage du pod.

---

## Fichiers de configuration

```
/var/lib/postgresql/data/
├── postgresql.conf
└── pg_hba.conf
```

| Fichier | Rôle |
|---------|------|
| `postgresql.conf` | Configuration du serveur : port, mémoire, connexions max, logs |
| `pg_hba.conf` | Contrôle d'accès : quels utilisateurs, depuis quelles IP, avec quelle méthode d'authentification |
