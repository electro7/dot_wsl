---
name: wiki
description: Registra en la wiki MediaWiki de Tunelia (wiki.tunelia.com) informacion que Claude considere importante conservar: decisiones tecnicas, procedimientos, configuraciones, trampas conocidas y resultados de investigaciones. Usar cuando el usuario pida anotar, documentar o actualizar algo en la wiki, o cuando al terminar un trabajo haya algo que merezca quedar registrado (en ese caso, proponerlo antes de escribir nada).
argument-hint: [<tema o pagina>]
---

# wiki

Redacta y edita paginas de la wiki "Wiki Tunelia Ingenieros" (MediaWiki 1.41)
usando su API. Si en `$ARGUMENTS` hay un tema o titulo de pagina, parte de el;
si no, deduce del contexto que merece registrarse y propon el titulo.

## Conexion

- Credenciales en `~/.config/wiki.cred` (permisos 600). Cargalas con
  `. ~/.config/wiki.cred`; define `WIKI_API`, `WIKI_USER` y `WIKI_PASS`.
- La API es `http://wiki.tunelia.com/api.php` (solo HTTP, intranet).
- NUNCA imprimas, registres ni copies la contrasena (ni a la memoria, ni a
  ficheros del proyecto, ni a la salida de comandos). Si un comando pudiera
  mostrarla, filtra la salida.
- Usa un fichero de cookies temporal (`mktemp`) y borralo al terminar
  (`trap 'rm -f "$cj"' EXIT`).
- Login: pide `meta=tokens&type=login`, luego `action=login` con
  `lgname`, `lgpassword`, `lgtoken` (usa `--data-urlencode`). Comprueba
  `"result":"Success"`.

## Que merece registrarse

- Decisiones tecnicas y su motivo (por que se eligio A y no B).
- Procedimientos reproducibles (instalacion, despliegue, recuperacion).
- Configuraciones no evidentes y su ubicacion.
- Trampas y errores conocidos, con sintoma y solucion.
- Resultados de investigaciones o pruebas que costaron tiempo.

No registres: credenciales, claves, tokens, datos personales de terceros,
nada que solo importe a la conversacion en curso, ni lo que ya este claro en
el propio codigo o en el historial de git. Ante la duda, pregunta.

## Flujo de trabajo (obligatorio)

1. Busca antes de crear: `action=query&list=search&srsearch=<tema>` y, si hay
   una pagina adecuada, amplia esa en vez de duplicar. Respeta el estilo,
   plantillas y categorias de las paginas vecinas (lee alguna).
2. Descarga la version actual (si existe) con
   `action=query&prop=revisions&rvprop=content|timestamp&rvslots=main&titles=<titulo>&format=json`
   y guardala como original local, conservando el `timestamp`.
3. NUNCA publiques directamente. Prepara la propuesta en
   `~/.claude/propuestas/` como `nuevo_<pagina>.wiki` (el original descargado
   como `<pagina>.wiki`; sustituye `/` y espacios del titulo por `_`).
   Contenido en wikitext, UTF-8, finales LF. En la wiki SI se escriben acentos
   y enes con normalidad; solo se evitan en comentarios de ficheros de codigo.
4. Abre la comparacion con
   `~/.claude/bin/propuesta.sh "wiki · <pagina>" <original> <propuesta>`
   (nunca `wt.exe -w new` ni vimdiff directamente; si la pagina es nueva,
   crea un original vacio). Guarda el timestamp en `<pagina>.timestamp`. Indica al usuario que
   revise y espera su visto bueno explicito. Si pide cambios, itera.
5. Publica solo tras la aprobacion, con `action=edit`:
   - `title`, `text` (via `--data-urlencode "text@<propuesta>"`), `token`
     CSRF (`meta=tokens`), `summary` breve y descriptivo.
   - `basetimestamp` con el timestamp del paso 2, para detectar conflictos de
     edicion; si hay conflicto, descarga de nuevo y vuelve al paso 3.
   - `createonly=1` si la pagina es nueva, `nocreate=1` si ya existia.
6. Comprueba que `"result":"Success"` y vuelve a leer la pagina para
   confirmar. Informa al usuario del titulo y la URL
   (`http://wiki.tunelia.com/index.php/<titulo>`).

## Limites

- Solo contenido de articulos (y tu espacio de usuario para pruebas). El
  usuario de la API tiene mas permisos (interfaz, JS/CSS global, mover,
  subir), pero NO los uses: no toques `MediaWiki:`, `*.css`, `*.js`, ni
  muevas, borres, protejas o subas ficheros salvo peticion expresa.
- Una edicion por pagina y aprobacion; no encadenes ediciones masivas sin
  confirmar el conjunto.
- Si la API falla (login, token, captcha), muestra el error tal cual y no
  reintentes en bucle.
- Para pruebas, usa `Usuario:Vgimeno/pruebas`.
