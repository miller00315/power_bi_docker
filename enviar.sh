#!/usr/bin/env bash
# Envia arquivos para o Windows do Power BI, pela pasta compartilhada ./shared
# Uso: ./enviar.sh arquivo.zip planilha.xlsx pasta/ ...
#   .zip    -> extraído dentro de shared/
#   outros  -> copiados para shared/ (pastas inclusive)
set -euo pipefail
DEST="$(cd "$(dirname "$0")" && pwd)/shared"

[ $# -gt 0 ] || { echo 'Uso: ./enviar.sh "arquivo.zip" "planilha.xlsx" ...'; exit 1; }

for f in "$@"; do
  [ -e "$f" ] || { echo "Não encontrado: $f" >&2; exit 1; }
  case "${f,,}" in
    *.zip) unzip -oq "$f" -d "$DEST"; echo "Extraído: $f" ;;
    *)     cp -r "$f" "$DEST/";       echo "Copiado:  $f" ;;
  esac
done

echo
echo 'No Windows/Power BI, use:  \\host.lan\Data\'
