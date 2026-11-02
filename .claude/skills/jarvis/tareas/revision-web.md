# Revisión de legibilidad de la web de documentación (2026-11-02)

Informe del agente `revisor-docs` (~/.claude/agents/revisor-docs.md) sobre
`/mnt/c/work/soft/jarvis/docs` y `mkdocs.yml`. Alcance: capítulos principales e
`index.md`; `docs/dev/` quedó fuera. Quejas de Vicente: páginas larguísimas, nav con
demasiadas entradas, listas que serían tablas y al revés, y poco conocimiento de lo
que ofrece Material para una web de consulta.

Método de captura: `mkdocs build --site-dir /mnt/c/Windows/Temp/...` +
`msedge.exe --headless --screenshot` (Windows solo ve rutas bajo /mnt/c; usar `wslpath`).
Las propuestas de cambio van a `~/.claude/propuestas/jarvis/` (nunca dentro del repo).

## Hallazgos (por impacto/esfuerzo)

1. **H1 (bajo). `toc.integrate` es la causa del nav de ~90 entradas** (mete el índice de
   cada página en el menú izquierdo y quita el de la derecha). Quitarlo; `toc_depth: 3`;
   añadir `navigation.indexes`, `toc.follow` (y `navigation.prune` opcional). No usar
   `navigation.expand`.
2. **H2 (medio). Dividir `driver.md` (1305 líneas)** en `docs/driver/<driver>.md` (13
   drivers: action, modbus, jetio, smodbus, varcli, varser, mqtt, cas, ethraw, serial,
   autolink, csnmp, timetab) + `driver/index.md` con tabla resumen (nombre enlazado, para
   qué, medio, cliente/servidor, opciones principales). Mismos `##` en todos: Llamada,
   Opciones, Mensaje, Módulos, Dispositivos, Ejemplo. Quitar la numeración manual 7.x.y.
3. **H3 (medio). Dividir `lang.md` (1588)** en `docs/lang/`: index, precompilador (4.1),
   dispositivos y tipos (4.2), sentencias (4.3), funciones (4.4), procedimientos (4.5),
   redundancia (4.6). **Las 79 funciones de 4.4/4.5 son líneas en negrita sin título**:
   convertirlas en títulos y poner tabla resumen; `toc_depth: 2` en esas páginas.
4. **H4. `patterns.md` (602)** por capítulos 9.x en `docs/patrones/`; `filedev.md` (216) y
   los demás se quedan.
5. **H5 (bajo-medio, mecánico). Opciones de driver a tabla** `| Opción | Argumento |
   Descripción |` (unas 14 listas en driver.md); alfabetizar y escribirlas como `-x`.
   También candidatas: mensajes 7.2.2, CONFIG de `.modbus`, tipos de memoria/dato,
   valores de `dupstat`.
6. **H6. Tablas a definiciones**: `anex.md` 10.2 (celdas largas), cabecera en 10.1.
   Flags CAS 7.8.5 podrían ir en pestañas.
7. **H7. Enlaces cruzados** (hay 16 "Véase..." y ningún enlace), glosario con `abbr` +
   `pymdownx.snippets auto_append`, página "Empieza aquí", `index.md` fuera del nav
   (añadir "Inicio"), unificar mayúsculas de títulos, solape entre index.md e intro.md.
8. **H8. Visual**: escritorio correcto; móvil (400 px) sale recortado por la derecha
   (puede ser límite de Edge headless: comprobar en un móvil); CSS opcional
   `extra.css` para tablas anchas.

## Capacidades de Material recomendadas aquí

Tarjetas (`grid cards`) en portadas de capítulo e índice de drivers; admoniciones para
"Nota:"/trampas; pestañas `pymdownx.tabbed` (falta activar) para variantes
Windows/Linux; desplegables `???` para ejemplos largos; anotaciones de código
(`content.code.annotate`); `title=`/`hl_lines=` en bloques de código; Mermaid
(superfences `custom_fences`) para la máquina de estados de redundancia; `def_list`;
`abbr` y tooltips; botones `.md-button`. No recomendado ahora: tags.

## Nav propuesto (con pestañas)

Inicio · Empezar (intro, install, tuto) · Lenguaje (`lang/*`) · Archivos (filedev,
filemore, commandline) · Drivers (`driver/*`) · Patrones (`patrones/*`) · Referencia
(anex) · Avanzado (dev/*). Con `navigation.indexes` el primer fichero de cada sección es
su portada.

## Sin comprobar

Móvil real; capturas de patterns/commandline; enlaces entrantes desde `docs/dev/`;
anclas actuales al dividir (`mkdocs build --strict`); plugins (no hay sección `plugins`;
`mkdocs-redirects` conservaría las URLs viejas pero habría que instalarlo). Las cifras
(14 listas, 79 funciones, 16 "Véase") son aproximadas.

## Fases acordadas

1. mkdocs.yml (sin mover ficheros) y nuevo nav.  2. Opciones de drivers a tablas.
3. Dividir driver.md.  4. Dividir lang.md y funciones a títulos.
5. Admoniciones, tarjetas, enlaces cruzados.
Pendiente de decidir por Vicente: mantener o no la numeración de capítulos (la doc y la
skill se citan como "4.4", "7.8.5").

## Estado

- Fase 1: aplicada (mkdocs.yml). Rama docs_reformat para el resto; edicion directa.
- Fase 2 hecha en docs_reformat (opciones de drivers y tablas de mensajes/tipos en driver.md), sin commitear.
- Fase 2 commiteada (03006db). Fase 3 hecha en docs_reformat sin commitear: driver.md dividido en
  docs/driver/{index,action,modbus,jetio,smodbus,varcli,varser,mqtt,cas,ethraw,serial,autolink,csnmp,
  timetab}.md; se MANTIENE la numeracion 7.x.y en los titulos (decision por defecto, reversible;
  pendiente de confirmar con Vicente). Enlaces actualizados: nav, index.md, lang.md (7.8.8),
  patterns.md (7.8.4). El slug de ancla se conserva (#788-version...), pero la ruta pasa de
  /driver/#... a /driver/<driver>/#... (no hay mkdocs-redirects).
- Fase 3 commiteada (3b15508). Fase 4 hecha en docs_reformat sin commitear: lang.md dividido en
  docs/lang/{index,precompilador,dispositivos,sentencias,funciones,procedimientos,redundancia}.md;
  funciones (53 entradas, no 79) y procedimientos fijos pasan de **negrita** a `## nombre` con tabla
  resumen (funcion | declaracion | descripcion) generada del propio texto. SKILL.md avisa de las rutas nuevas.
- Fase 4 commiteada (6b72cfb). DECISIONES de Vicente (2026-11-02): (1) se QUITA la numeracion de capitulos
  (titulos sin 4.4/7.8.5; citas por fichero y titulo; referencias del texto convertidas en enlaces);
  (2) SIN redirecciones de URLs viejas (la documentacion es nueva, nadie enlaza desde fuera).
  Numeracion quitada en docs_reformat (sin commitear): 138 titulos, tarjetas de index.md, tablas de
  driver/index.md y lang/index.md, ancla de anex #otros-drivers. Comprobado: build --strict OK, 0 anclas rotas.
  Skill actualizada a rutas lang/ y driver/. Pendiente: fase 5 (admoniciones, tarjetas, enlaces cruzados).
- Numeracion quitada commiteada (7c4da9d). Fase 5 hecha en docs_reformat sin commitear: 17 admoniciones
  (note/warning/tip) en lugar de "Nota:", pestanas Windows/Linux en install.md, desplegable en el ejemplo de
  timetab, glosario con tooltips (includes/abreviaturas.md via pymdownx.snippets auto_append; solo siglas:
  SCADA, PLC, CAS, SNMP, OID, MQTT), mas enlaces cruzados. NO hecho a proposito: tarjetas en portadas de
  capitulo (las tablas resumen sirven mejor), mermaid de redundancia (el texto no define bien las transiciones),
  anotaciones/titulos en bloques de codigo (revisar patterns.md caso por caso si se quiere).
- Convenciones de la doc (2026-11-02, Vicente): nombres de driver SIEMPRE en minusculas (action, modbus, ...,
  timetab) y, al nombrarlos en prosa, en codigo en linea (`cas`) para que salgan con fondo gris. Los
  protocolos (Modbus, MQTT, SNMP) conservan sus mayusculas. Titulos y menu no llevan codigo en linea.
- Capitulo lang/redundancia.md reescrito por Vicente (2026-11-02) a partir de dupctrl.cpp y redun.prg, con 3
  esquemas SVG en linea (includes/redundancia_{comunicacion,estados,conmutacion}.svg, incluidos con
  `--8<--` de snippets dentro de <div markdown="0">). Se eligio SVG y NO mermaid: Material carga mermaid desde
  unpkg.com en tiempo de ejecucion (dependeria de internet), el SVG con currentColor va offline y sigue
  el tema claro/oscuro. Hechos del kernel anotados: orden de #dup = prioridad e indice; intervalo por omision
  15 s (precompilador.md dice 5: corregir); dupstat devuelve 0 arranque..5 finalizando (funciones.md lista
  0-4 sin arranque: corregir); no hay vuelta automatica al recuperarse la principal.
- ESTADO FINAL 2026-11-02: todo commiteado en docs_reformat (ultimo 207138e, 9 commits sobre master, sin fusionar ni
  pushear). Siguiente: revision con `mkdocs serve`, fusion con master y quitar el aviso de rama de SKILL.md.
- Revision de la skill tras los cambios (2026-11-02): SKILL.md (patrones.md, seccion "Si hay que tocar la
  documentacion"), lenguaje.md (bucle del kernel), dispositivos.md (tabla de drivers con mqtt/varser/timetab y
  mensajes de estado por driver), patrones.md (redun.prg), obra.md (redun.prg, referencia a patterns.md) y
  aprendizajes.md (depurada: lo ya corregido en la doc se quito; quedan fallos de codigo y herramientas).
