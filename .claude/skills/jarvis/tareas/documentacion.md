# Tarea en curso: completar la documentación oficial de Jarvis

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
