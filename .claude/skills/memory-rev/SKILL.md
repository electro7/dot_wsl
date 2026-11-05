---
name: memory-rev
description: Revisa y pone al dia la documentacion de contexto de Claude (CLAUDE.md global, AGENTS.md de proyecto, memoria del proyecto y skills propias) con lo aprendido en la sesion, borrando lo obsoleto y condensando. Usar solo cuando el usuario lo pida (/memory-rev, "revisa la memoria", "pon al dia el contexto"); "/memory-rev todo" revisa tambien las skills y agentes no usados en la sesion.
disable-model-invocation: true
---

# memory-rev

Objetivo: que lo que se carga como contexto sea correcto, escueto y rapido de
leer. Menos texto, mismo contenido util. Lanzarla antes de `/handoff`.

## Alcance (revisar solo lo que exista)

1. `~/.claude/CLAUDE.md` y los `AGENTS.md` del proyecto actual (cwd y padres
   hasta `/mnt/c/work`). Un AGENTS.md de carpeta padre (p. ej.
   `/mnt/c/work/obras/AGENTS.md`) es compartido por varios proyectos: avisarlo
   en el informe antes de tocarlo.
2. Memoria del proyecto: `MEMORY.md` y sus ficheros (carpeta "persistent
   file-based memory"). `handoff.md` no es memoria: no se revisa ni condensa;
   solo se borra si esta obsoleto.
3. Skills de `~/.claude/skills/*` (SKILL.md y auxiliares como
   `aprendizajes.md`, `catalogo.md`) y agentes de `~/.claude/agents`.
   Por defecto, solo las usadas o afectadas en la sesion; todas con
   `/memory-rev todo`.
4. Fuera de alcance: `~/.claude/skills/synced` (sincronizada externamente),
   codigo del proyecto, `settings*.json`, hooks (salvo que una nota los
   describa mal).

## Proceso

1. **Inventario**: lista los ficheros del alcance y su tamano (`wc -l`). Leelos.
2. **Contraste con la sesion**: lo aprendido que no esta registrado
   (decisiones, trampas, preferencias, correcciones del usuario, rutas nuevas)
   y lo registrado que la sesion ha contradicho. Si el contexto de la sesion
   ya se ha resumido, dilo en el informe y limita este paso a lo que conste
   en el resumen.
3. **Verifica** antes de conservar: rutas, ficheros, funciones, flags y
   comandos citados deben existir (`ls`, `grep`). Lo que ya no exista, fuera.
4. **Aplica estas reglas**:
   - Borrar: obsoleto, duplicado, derivable del codigo/git/otro AGENTS.md o
     del CLAUDE.md global (siempre cargado), historia de lo hecho, cosas
     validas solo para una conversacion.
   - Fusionar: entradas que tratan lo mismo; una idea, un sitio.
   - Condensar: frases cortas, listas en vez de parrafos, sin adjetivos ni
     explicaciones que el modelo deduce solo. Conservar el *por que* si no es
     evidente.
   - Mover: lo que aplique a un solo proyecto, fuera del CLAUDE.md global; lo
     de una skill, a la skill.
   - Bandejas de entrada (`aprendizajes.md` de jarvis y equivalentes):
     promover cada entrada al fichero tematico que le corresponda y quitarla
     de la bandeja; dejar solo lo que aun no tenga sitio.
   - Memoria: un hecho por fichero con frontmatter (name, description,
     metadata.type); `MEMORY.md` = una linea por entrada, sin contenido.
     Convierte fechas relativas a absolutas.
   - Nada de credenciales ni datos de la wiki.
5. **Aplicar**. Cambio pequeno (hasta unas 5 lineas por fichero, o un fichero
   de memoria nuevo): editalo directamente. Cambio grande (reescritura,
   borrado de ficheros, cualquier cambio en una instruccion explicita del
   usuario): por vimdiff (ver "Cuidado"). Nunca suavices ni borres una
   instruccion del usuario sin avisar; si dudas, preguntalo en el informe.
6. **Informe** final (max. ~10 lineas): por fichero, que se anadio / borro /
   condenso, y el ahorro aproximado de lineas. Lista aparte las dudas que
   requieren decision del usuario (no las resuelvas por tu cuenta).

## Cuidado

- No toques fuentes del proyecto ni compiles.
- Propuestas por vimdiff segun el CLAUDE.md global (`propuesta.sh`, una
  llamada por tanda, titulo `"memoria · <tarea>"`). Destino: config de
  `~/.claude` en `~/.claude/propuestas/` sin subcarpeta (si hay colision,
  ruta relativa: `nuevo_skills_jarvis_SKILL.md`); un AGENTS.md de proyecto en
  `~/.claude/propuestas/<proyecto>/`. Con varios ficheros, indica al usuario
  `:tabn` / `:tabp` (su `gt` esta remapeado). Los ficheros a borrar
  enumeralos en el informe, no en vimdiff.
- Commits solo si el usuario lo pide (repo `~/.claude` o `/mnt/c/work/home`).
