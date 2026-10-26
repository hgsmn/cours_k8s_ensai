# formation_kube_ensai

Ressources de la formation ENSAI « Kubernetes : déployer ses applications facilement et de manière fiable » : cours (diapositives Marp), TP et code associé.

Le tout est publié sous forme de site web (MkDocs Material + diapositives Marp) via GitHub Pages.

## Organisation du dépôt

```
.
├── intro.md, docker.md, …      # Cours : diapositives Marp (thème « cours »)
├── assets/
│   ├── theme-cours.css         # Thème Marp commun à tous les cours
│   └── *.png, *.svg, *.html    # Schémas et animations des cours
├── docs/                       # Site MkDocs
│   ├── index.md                # Page d'accueil (sommaire par module)
│   ├── cours.md                # Liens vers les diapositives HTML / PDF
│   ├── tps/                    # Énoncés des TP et debug labs
│   ├── ressources/             # Archives de code distribuées aux étudiants
│   └── stylesheets/extra.css   # Style du site, aligné sur le thème Marp
├── mkdocs.yml                  # Configuration du site
├── build.sh                    # Construit le site complet dans site/
└── .github/workflows/pages.yml # Publication automatique sur GitHub Pages
```

## Modifier les cours

Les diapositives sont de simples fichiers Markdown. Avec l'extension VS Code **Marp for VS Code**, l'aperçu utilise directement le thème grâce à `.vscode/settings.json`.

Classes de mise en page disponibles (`<!-- _class: … -->` en haut d'une diapo) :

| Classe | Effet |
|---|---|
| `lead` | Page de titre |
| `divider` | Intercalaire de chapitre (fond sombre) |
| `centered` | Question ou phrase clé, centrée |
| `cards` | La liste devient une grille de cartes (`- **Titre**\` puis le texte) |
| `cards reveal-1`, `reveal-2`… | Révèle les cartes une à une (dupliquer la diapo) |
| `steps` | La liste numérotée devient une frise d'étapes |
| `grid-4` | Liste en grille de 4 colonnes |
| `checklist` | Liste à cocher |
| `compact` | Texte légèrement réduit |
| `code-sm` | Blocs de code réduits pour les longs manifests |
| `tp` | Diapo « à vous de jouer » renvoyant vers un TP |
| `demo` | Animation HTML en iframe (export HTML uniquement) |

Une citation `>` s'affiche comme un encadré « à retenir ».

Export ponctuel d'un cours :

```bash
npx @marp-team/marp-cli@4 kubernetes.md --theme-set assets/theme-cours.css --html --pdf --allow-local-files
```

## Modifier les TP

Les énoncés sont dans `docs/tps/`. Chaque TP commence par une « fiche » (objectifs, livrables, prérequis), puis utilise les encadrés MkDocs Material (`!!! warning`, `!!! tip`, `!!! question`…).

Prévisualisation du site en direct :

```bash
pip install -r requirements-docs.txt
mkdocs serve        # http://127.0.0.1:8000 (sans les diapositives)
```

## Construire et publier

```bash
./build.sh            # site complet dans site/ (pages + diapos HTML + PDF)
./build.sh --no-pdf   # plus rapide
```

La publication est automatique : chaque push sur `main` déclenche le workflow `.github/workflows/pages.yml`. À activer une seule fois dans *Settings → Pages → Source : GitHub Actions*.
