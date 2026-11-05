#!/bin/bash
# gl.sh - cliente minimo de la API v4 del GitLab de Tunelia
#
# Uso: gl.sh [-X METODO] [-a] RUTA [args extra de curl...]
#   RUTA   ruta bajo /api/v4 (p. ej. "projects/9/issues?state=opened")
#   -X     metodo HTTP (GET por defecto)
#   -a     pagina automaticamente (solo GET) y une los arrays en uno
#
# El token se lee de ~/.config/gitlab.cred y nunca se imprime.
# Los proyectos pueden indicarse por id o por ruta codificada
# (scada-shield%2Fshield); usa "gl.sh -p grupo/proyecto" para codificarla.

set -euo pipefail

BASE="${GITLAB_URL:-http://git.tunelia.com}/api/v4"
CRED="$HOME/.config/gitlab.cred"

if [ "${1:-}" = "-p" ]; then
    printf '%s\n' "${2//\//%2F}"
    exit 0
fi

metodo=GET
todas=0
while getopts "X:a" o; do
    case $o in
        X) metodo=$OPTARG ;;
        a) todas=1 ;;
        *) echo "uso: gl.sh [-X METODO] [-a] RUTA [args curl]" >&2; exit 2 ;;
    esac
done
shift $((OPTIND - 1))
ruta=${1:?falta la ruta}
shift

[ -r "$CRED" ] || { echo "no se puede leer $CRED" >&2; exit 1; }
TOKEN=$(head -n1 "$CRED")

peticion() {
    curl -sS --fail-with-body --max-time 30 -X "$metodo" \
        -H "PRIVATE-TOKEN: $TOKEN" "$@"
}

if [ $todas -eq 0 ]; then
    peticion "$BASE/$ruta" "$@"
    echo
    exit 0
fi

# Paginacion: se recorren las paginas hasta que X-Next-Page venga vacio
sep='?'; case $ruta in *\?*) sep='&' ;; esac
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
pag=1
while [ -n "$pag" ]; do
    peticion -D "$tmp/h" -o "$tmp/p$pag.json" \
        "$BASE/$ruta${sep}per_page=100&page=$pag" "$@"
    pag=$(tr -d '\r' < "$tmp/h" | awk -F': ' 'tolower($1)=="x-next-page"{print $2}')
done
jq -s 'add' "$tmp"/p*.json
