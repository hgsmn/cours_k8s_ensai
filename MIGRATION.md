# Intégrer cette archive au dépôt

L'archive reprend l'arborescence du dépôt `formation_kube_ensai` : décompressez-la à la racine du dépôt en acceptant le remplacement des fichiers existants.

## Ce qui est remplacé

- `intro.md`, `docker.md`, `kubernetes.md`, `helm.md`, `kube_maj.md`, `kube_hd.md`, `postgresql.md` : cours migrés vers le thème `cours`
- `assets/theme-cours.css` : thème complété (classes `tp`, `code-sm`, `demo`, `reveal-N`, coloration du code sur fond sombre)
- `README.md`

## Ce qui est ajouté

- `docs/` : le site (accueil, page des cours, TP, debug labs, ressources, style)
- `mkdocs.yml`, `requirements-docs.txt`, `build.sh`, `.gitignore`
- `.github/workflows/pages.yml` : publication sur GitHub Pages
- `.vscode/settings.json` : aperçu Marp avec le thème dans VS Code

## À faire après la copie

1. **Supprimer les anciens énoncés** `tps/*.md` : ils ont été déplacés et mis en forme dans `docs/tps/` (le dossier `tps/` garde `3tier/` et `tp_correction/`). Le TP 6 s'appelle désormais `6_amelioration_application.md` (sans accent, pour des URL propres).
2. **Optionnel** : supprimer `assets/global.css`, `assets/theme-dsfr.css` et `assets/dark.css`, qui ne sont plus utilisés par aucun cours.
3. **Image manquante** : `docker.md` référence `assets/registry.jpg`, absent du projet. Ajoutez l'image ou retirez la ligne `![bg right:38%](assets/registry.jpg)`.
4. **Activer GitHub Pages** : *Settings → Pages → Source : GitHub Actions*. Le workflow suppose que ce dossier est la racine du dépôt.

`kubesec.md` (vide) n'a pas été modifié.
