#!/usr/bin/env bash
# Construit le site complet dans site/ :
#   - les pages (accueil, TP, ressources) avec MkDocs Material ;
#   - les diapositives Marp en HTML et en PDF dans site/slides/.
#
# Prérequis : Python 3 (pip install -r requirements-docs.txt), Node.js 18+,
# et Google Chrome / Chromium pour l'export PDF.
#
# Usage : ./build.sh            (site + diapos HTML + PDF)
#         ./build.sh --no-pdf   (plus rapide, sans les PDF)
set -euo pipefail
cd "$(dirname "$0")"

DECKS="intro docker kubernetes helm kube_maj kube_hd postgresql"
MARP="${MARP:-npx --yes @marp-team/marp-cli@4}"
OPTS="--theme-set assets/theme-cours.css --html --allow-local-files"

echo "▸ Pages MkDocs"
mkdocs build --clean

echo "▸ Diapositives Marp"
mkdir -p site/slides
for deck in $DECKS; do
  echo "  - $deck"
  $MARP "$deck.md" $OPTS -o "site/slides/$deck.html"
  if [ "${1:-}" != "--no-pdf" ]; then
    $MARP "$deck.md" $OPTS --pdf -o "site/slides/$deck.pdf"
  fi
done

# Images et animations référencées par les diapos (chemins relatifs « assets/… »)
cp -r assets site/slides/

echo "✔ Site prêt dans site/ (ouvrir site/index.html)"
