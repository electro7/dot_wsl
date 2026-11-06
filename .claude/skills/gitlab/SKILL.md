---
name: gitlab
description: Consulta y gestiona las issues del GitLab autoalojado de Tunelia (git.tunelia.com) mediante su API REST: listar issues abiertas de un proyecto o de todos, ver una issue con sus comentarios, filtrar por etiqueta, autor o asignado y, con visto bueno del usuario, comentar, cerrar o etiquetar. Usar cuando el usuario pregunte por issues, incidencias o tickets de GitLab, o por el estado de un proyecto de git.tunelia.com.
argument-hint: [<proyecto> [#issue]]
---

# gitlab

GitLab 19.5 (Community Edition) en `http://git.tunelia.com` (solo HTTP,
intranet). Si en `$ARGUMENTS` hay un proyecto o una issue, parte de ahi.

## Conexion

- Token personal (usuario `vgimeno`, scope `api`, caduca 2027-11-05) en
  `~/.config/gitlab.cred`, permisos 600, una sola linea.
- NUNCA imprimas, copies ni registres el token. Usa siempre el script
  `~/.claude/skills/gitlab/gl.sh`, que lo lee y lo manda en la cabecera
  `PRIVATE-TOKEN` sin mostrarlo.
- `gl.sh RUTA` hace un GET a `/api/v4/RUTA`; `-a` pagina y une los
  resultados; `-X POST|PUT` para escribir; los argumentos extra van a curl
  (`--data-urlencode "body@fichero"`).
- Proyecto por id o por ruta codificada: `gl.sh -p scada-shield/shield`
  devuelve `scada-shield%2Fshield`.
- Existe tambien `glab` instalado (el usuario lo usa a mano); la skill usa
  la API con curl para no depender de su configuracion.

## Grupos y proyectos

- `scada-shield/*`: software propio (shield id 9, vtun 39, timap 10,
  jarvis 2). Ahi es donde los companeros abren issues.
- `obras/*`: una por obra (coincide con /mnt/c/work/obras). Grupo id 4,
  visibilidad `internal`, rama `main` en los nuevos. Crear uno (solo con un
  si explicito de Vicente): `gl.sh -X POST projects --data-urlencode name=X
  --data-urlencode namespace_id=4 --data-urlencode visibility=internal
  --data-urlencode initialize_with_readme=false`; luego `git remote add origin
  http://git.tunelia.com/obras/X.git` (credenciales ya en el store de git).
- `gl.sh -p` solo codifica la ruta: la llamada es `gl.sh projects/$(gl.sh -p ...)`.
- `misc/*`: varios.
- Lista actualizada: `gl.sh -a 'projects?membership=true&simple=true' |
  jq -r '.[] | "\(.id)\t\(.path_with_namespace)"'`

## Consultas habituales

```bash
GL=~/.claude/skills/gitlab/gl.sh
# Issues abiertas de todos los proyectos
$GL -a 'issues?scope=all&state=opened' | jq -r '.[] |
  "\(.references.full)\t\(.author.username)\t\(.updated_at[:10])\t\(.labels|join(","))\t\(.title)"'
# Issues de un proyecto (state=opened|closed|all; labels=a,b; assignee_username=; author_username=; search=)
$GL -a "projects/$($GL -p scada-shield/shield)/issues?state=opened"
# Una issue: descripcion y comentarios (system=true son eventos automaticos)
$GL projects/9/issues/3 | jq -r '"\(.title)\n\(.web_url)\n\(.state) · \(.author.name) · \(.created_at[:10])\n\n\(.description)"'
$GL -a 'projects/9/issues/3/notes?sort=asc' | jq -r '.[] | select(.system|not) |
  "--- \(.author.name) \(.created_at[:16])\n\(.body)\n"'
# Etiquetas e hitos de un proyecto
$GL -a projects/9/labels | jq -r '.[].name'
$GL projects/9/milestones?state=active
```

- Las fechas vienen en UTC (ISO 8601).
- Adjuntos (`[f.txt](/uploads/<secreto>/f.txt)`, imagenes `![](/uploads/...)`):
  la URL web redirige a sign_in aunque lleve el token. Descargar con
  `gl.sh projects/<id>/uploads/<secreto>/<fichero> > destino` (API 17+) y
  abrir con Read. Las issues nuevas salen con web_url `/-/work_items/N`.

## Presentacion

- Listados: tabla breve con referencia (`proyecto#iid`), titulo, autor,
  fecha de ultima actualizacion y etiquetas. Ordena por actualizacion.
- Al resumir una issue, relacionala con el codigo si el proyecto esta en
  local (p. ej. scada-shield/jarvis -> /mnt/c/work/soft/jarvis) y propon
  donde mirar, pero sin tocar fuentes (las propuestas van por
  ~/.claude/propuestas, segun CLAUDE.md).

## Escritura (solo con visto bueno)

Comentar, cerrar, reabrir, asignar o etiquetar publica algo visible para
los companeros: ensena antes el texto exacto y espera confirmacion.

```bash
# Comentar (texto en fichero para no pelear con comillas)
$GL -X POST projects/9/issues/3/notes --data-urlencode "body@$f"
# Cerrar / reabrir
$GL -X PUT 'projects/9/issues/3?state_event=close'
# Etiquetas
$GL -X PUT projects/9/issues/3 --data-urlencode 'add_labels=bug'
```

Sin abreviaturas en los textos para terceros (ver CLAUDE.md).
