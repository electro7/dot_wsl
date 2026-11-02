# Tarea COMPLETADA (2026-11-02): documentación oficial de Jarvis

Propuesta aceptada por Vicente el 2026-11-01. Se retoma en la siguiente sesión.
**Antes de empezar, pedirle respuesta a las preguntas pendientes del final.**

- Web: http://gitdoc.tunelia.com/jarvis/intro/ (mkdocs + material).
- Fuente: `/mnt/c/work/soft/jarvis/docs/` + `mkdocs.yml` (repo gitlab.tunelia.com/scada-shield/jarvis).
- Objetivo: documentación fiable verificada contra el kernel, sin bloquear indefinidamente
  el desarrollo de autómatas: priorizar lo de uso diario.

## Plan

**0. Inventario (sin tocar nada)**
- Comparar el `nav` de mkdocs.yml con los ficheros reales (ya visto: el nav apunta a
  `fileother.md`, el fichero es `filemore.md`).
- Cruzar los drivers del kernel (action, autolink, cas, cgi, csnmp, dlmod, ethraw, jetio,
  lontcp, modbus, mqtt, serial, smodbus, sunrise, timetab, varcli, varser, webser, xgi,
  xscada) con los documentados y con los usados en las obras (`.dev` de /mnt/c/work/obras).
- Leer lo que aún no se ha leído: index.md, install.md, dev/.
- Entregable: lista de huecos y erratas para que Vicente decida el alcance.

**1. Corregir lo existente**
- Erratas confirmadas en el kernel: `string` = 64 caracteres (DEFAULT_STRING, ucsHead.h);
  struct = 256 campos (MAX_STRUCT_FIELDS, typedef.h).
- Numeración rota (p. ej. `7.3.3` dentro de `7.2`, falta 7.6), nav, ortografía.

**2. Completar lang.md (verificado en kernel/jarvis/lex.cpp y grammar.y)**
- Funciones: sunrise/sunset, format, file_*, pow, hostname, cpu, mem_used, cpu_temp, stamp,
  devcode, type, settype, diginp/digoutp.
- Modificadores dindesc, file, virtual; palabra clave `this`.
- Dudas: `return` en funciones void, semántica de format/stamp/file_open. Lo que el código no
  resuelva, preguntarlo a Vicente en bloque.

**3. Drivers que faltan, por uso en obras**
1. cas (con todos los flags `<...>` de type.dev / cas.dev; fuente: PDF de Shield 8.3.1 y
   /mnt/c/work/soft/shd/docs/AutoCreateFlags.md).
2. ethraw (uso real: integrar equipos por TCP/UDP con protocolos programados en el .prg).
3. autolink, serial.
4. csnmp, timetab.
5. Resto (webser, lontcp, sunrise, cgi...) solo si se usan; si no, una línea en el apéndice.
- Fuentes: kernel/help/*.txt, `Manual desarrollo Shield.pdf`, código de cada driver.

**4. (Opcional) Capítulo de patrones de obra**
- Autómata de equipo, protocolo sobre ethraw, estructura de una obra; sale de la skill y la
  skill pasaría a remitir a la documentación oficial.

**5. Revisión final**
- Repaso con Vicente capítulo a capítulo.
- Comprobar que el sitio genera sin enlaces rotos: necesita mkdocs + mkdocs-material; si no
  están instalados, pedir a Vicente que los instale (no buscar alternativas).

## Respuestas de Vicente (2026-11-02)

- Entrega: rama local `docs` en soft/jarvis, creada desde master (origin/mkdoc ya estaba
  fusionada). Él revisa con git diff/GitLab y fusiona. Sin push sin permiso.
- Destinatario: se incluye la fase 4 (patrones de túneles), pero en una tanda posterior.
- Alcance: fases 0-3 primero; después se deciden la 4 y el resto de drivers.

## Preguntas que se le hicieron (ya respondidas)

1. **Entrega de cambios:** `soft/jarvis` es su repo de fuentes; la regla general es propuesta
   `nuevo_*.md` + vimdiff, pesado para ficheros nuevos de documentación. Propuesta: trabajar
   en una rama `docs` del repo y que él revise con `git diff` / GitLab antes de fusionar.
   ¿Le vale o prefiere vimdiff fichero a fichero?
2. **Destinatario:** ¿documentación solo de Jarvis genérico, o incluye buenas prácticas de
   túneles (fase 4)? Afecta a lo que ve un cliente (el código se entrega con las
   instalaciones).
3. **Alcance:** ¿fases 0-3 primero y luego decidir la 4 y el resto de drivers?

## Fase 0: inventario (2026-11-02, rama `docs` creada, sin commits)

Nav/estructura:
- nav: `fileother.md` → `filemore.md`; títulos "Introdución", "Otros archicos", "Desarrolo".
- index.md (portada) también se numera "1. Introducción", igual que intro.md.
- Los capítulos 1-9 están en un fichero cada uno; tuto.md mezcla `#` sin numerar.

Erratas (confirmadas en el kernel):
- lang.md 4.2.5: string "128 caracteres" → 64 (DEFAULT_STRING, ucsHead.h:40).
- lang.md 4.2.3: dice "256 elementos si se usa en una matriz": cuadra con MAX_STRUCT_FIELDS=256
  (typedef.h:13), pero la condición "en una matriz" hay que verificarla; anex.md dice 64.
- lang.md 4.2.1: `int"` (comilla de más), "int [0...9]", "1 decimale".
- lang.md: "4.3.4Mensajes", "4.3.6Instrucciones" (sin espacio).
- driver.md: 7.2 Modbus sigue con 7.3.3-7.3.5; falta 7.3 y 7.6; salta de smodbus (7.5) a varcli (7.7).

Drivers: uso en obras (nº de obras con módulo `.drv` en .dev / líneas #driver) frente a documentación:
- Documentados: action, modbus, jetio, smodbus, varcli, varser, mqtt.
- Sin documentar y usados: **ethraw (9 obras), cas (10), serial (4), autolink (3), csnmp (3)**,
  timetab (1), lontcp, drvgen (en #driver pero no en kernel/help).
- Sin uso en obras: webser, sunrise, cgi, xgi, dlmod, xscada → una línea en el apéndice.
- Orden de la fase 3: cas, ethraw, serial, autolink, csnmp, timetab.

mkdocs y mkdocs-material NO están instalados: hacen falta para la fase 5.

## Fase 1 hecha (2026-11-02): commit 1d8a76a en `docs`
- Pendiente de verificar en una fase posterior: anex.md dice "Reloj: centésimas", pero dev_driver.md
  y tick_t hablan de milésimas.
- Siguiente: fase 2 (lang.md).

## Fase 2 hecha (2026-11-02): commit 9e76e39 (y a1d8f43: reloj en milésimas, confirmado por Vicente)
Dudas resueltas por Vicente: `virtual` se ignora (no se documenta); diginp true = entrada activa;
sunrise/sunset devuelven horas; substr(pos, num) = num caracteres desde pos (base 0). Commit 8bb75fb.
Siguiente: fase 3 (drivers: cas, ethraw, serial, autolink, csnmp, timetab).

## Fase 3 hecha (2026-11-02) — rama `docs`, sin push
- driver.md: 7.8 cas (f67f262), 7.9 ethraw (90cce8b), 7.10 serial (f264097), 7.11 autolink
  (0ffc878), 7.12 csnmp (62b9f5e), 7.13 timetab (6d832a3); anex 9.2 otros drivers (a652db6);
  filemore 6.3 (e5ccbe7).
- Errores encontrados en kernel/help (no corregidos allí, solo en la doc):
  cas.txt puertos cambiados (-p Jarvis = 14017, -x Shield = 14016); serial.txt ejemplo con
  read/write (son input/output); timetab.txt sintaxis 'tipo: franjas' (es 'tipo = franjas').
- Pendiente de decidir con Vicente: fase 4 (patrones de túneles), fase 5 (mkdocs build --strict:
  falta instalar mkdocs + mkdocs-material), y si se corrigen también los kernel/help/*.txt.
- 2026-11-02: Vicente pidió quitar xscada, dlmod, drvgen y sunrise del apéndice (ad7267d). No mencionarlos en la doc.

## Fase 4 hecha (2026-11-02): commit cea264f
- docs/patterns.md, capítulo 9 "Patrones de desarrollo" (Vicente no quiere "patrones de túneles";
  la intro dice que se usa sobre todo en túneles de carretera). El apéndice pasa a ser el 10.
- Sale de patrones.md, obra.md y plantillas/ de la skill, sin nombres de obras ni datos internos.
- Ojo: el ejemplo ANA_FILTER/A_CO de 9.4 es una simplificación escrita para la doc (no está
  copiado de una obra): Vicente debe revisarlo.
- Queda: fase 5 (mkdocs build --strict) y decidir si la skill pasa a remitir a la doc oficial.

## Fase 5 (2026-11-02): `mkdocs build --strict` limpio (de281c3)
- mkdocs 1.6.1 + material instalados. Comprobar con:
  `cd /mnt/c/work/soft/jarvis && mkdocs build --strict -d <scratchpad>/site`
- Corregido: `font` estaba fuera de `theme`; `T*n*` en una tabla salía literal (usar texto plano).
- index.md fuera del nav es intencionado (portada con el menú oculto): solo da un INFO.
- Queda la revisión capítulo a capítulo con Vicente y la fusión de `docs` en master (la hace él).

## Repaso ortográfico (2026-11-02): commit f986b55
- hunspell + hunspell-es instalados. Método: quitar bloques ```...```, `código` y URLs de los .md,
  `hunspell -d es_ES -l`, revisar a mano las desconocidas (casi todas son términos técnicos).
- hunspell no detecta tildes que dan otra palabra válida: buscar aparte "por que" (causal = porque),
  continua/continúa, si/sí, linea, unicamente...
- Revisado también el código de tuto.md (faltaba ';' y sobraban '*').

## kernel/help corregido (2026-11-02): commit dd65a17 de Vicente (cas, serial, timetab)
Tarea de documentación completa (fases 0-5) en la rama `docs`. Pendiente: revisión final y fusión
(la hace Vicente). Después, decidir si la skill se adelgaza para remitir a la doc oficial.

## Cierre (2026-11-02)
Fusionado en master y publicado por Vicente; el CI usa `--strict` (90ac312). Rama docs borrada.
Opcional, sin decidir: adelgazar la skill para que remita a la doc oficial; nota en la wiki.
- 2026-11-02: skill adelgazada (38 KB → 25 KB en los .md temáticos): lenguaje.md y dispositivos.md
  pasan a chuletas con mapa de apartados; patrones.md solo con lo específico de las obras.
  Copia previa en ~/.claude/backups/jarvis-skill-20261102.tar.gz.
- 2026-11-02: enlace a la doc añadido en la página Jarvis de la wiki (sección Documentación). Tarea cerrada.
- 2026-11-02: Vicente añadió la portada con tarjetas (681823a) y eliminó kernel/help (4e97a66).
  Pendiente: anex.md 10.2 aún remite a kernel/help. Lista completa de pendientes en la memoria
  del proyecto (estado-jarvis.md).
