---
name: memory-rev
description: Revisa y pone al dia la documentacion de contexto de Claude (CLAUDE.md global, AGENTS.md de proyecto, memoria del proyecto y skills propias) con lo aprendido en la sesion, borrando lo obsoleto y condensando. Usar solo cuando el usuario lo pida (/memory-rev, "revisa la memoria", "pon al dia el contexto").
disable-model-invocation: true
---

# memory-rev

Objetivo: que lo que se carga como contexto sea correcto, escueto y rapido de
leer. Menos texto, mismo contenido util.

## Alcance (revisar solo lo que exista)

1. `~/.claude/CLAUDE.md` (el global conserva ese nombre) y los `AGENTS.md` del
   proyecto actual (cwd y padres hasta `/mnt/c/work`; desde noviembre de 2026
   los de proyecto se llaman AGENTS.md, no CLAUDE.md).
2. Memoria del proyecto: `MEMORY.md` y sus ficheros (carpeta indicada por el
   sistema como "persistent file-based memory"). Incluye `handoff.md`.
3. Skills propias de `~/.claude/skills/*` (SKILL.md y auxiliares como
   `aprendizajes.md`, `catalogo.md`) y agentes de `~/.claude/agents`.
4. Fuera de alcance: codigo del proyecto, `settings*.json`, hooks (salvo que
   una nota los describa mal).

## Proceso

1. **Inventario**: lista los ficheros y su tamano (`wc -l`). Lee todos.
2. **Contraste con la sesion**: busca lo aprendido que no esta registrado
   (decisiones, trampas, preferencias, correcciones del usuario, rutas nuevas)
   y lo registrado que la sesion ha contradicho.
3. **Verifica** antes de conservar: rutas, ficheros, funciones, flags y
   comandos citados deben existir (`ls`, `grep`). Lo que ya no exista, fuera.
4. **Aplica estas reglas**:
   - Borrar: obsoleto, duplicado, derivable del codigo/git/otro AGENTS.md,
     historia de lo hecho, cosas validas solo para una conversacion.
   - Fusionar: entradas que tratan lo mismo; una idea, un sitio.
   - Condensar: frases cortas, listas en vez de parrafos, sin adjetivos ni
     explicaciones que el modelo deduce solo. Conservar el *por que* si no es
     evidente.
   - Mover: lo que aplique a un solo proyecto, fuera del CLAUDE.md global; lo
     de una skill, a la skill.
   - Memoria: un hecho por fichero con frontmatter (name, description,
     metadata.type); `MEMORY.md` = una linea por entrada, sin contenido.
     Convierte fechas relativas a absolutas.
   - Nada de credenciales ni datos de la wiki.
5. **Aplicar**: tu configuracion (CLAUDE.md global, AGENTS.md, memoria, skills, agentes) se edita
   directamente los cambios pequenos; los grandes van por vimdiff (ver
   "Cuidado"). Respeta lo que ya sea una
   instruccion explicita del usuario: no la suavices ni la borres sin avisar;
   si dudas, preguntalo en el informe.
6. **Informe** final (max. ~10 lineas): por fichero, que se anadio / borro /
   condenso, y el ahorro aproximado de lineas. Lista aparte las dudas que
   requieren decision del usuario (no las resuelvas por tu cuenta).

## Cuidado

- No toques fuentes del proyecto ni compiles.
- Si el cambio es grande (reescribir un AGENTS.md entero, borrar varios
  ficheros), no lo apliques ni lo vuelques en consola: prepara la propuesta
  como `nuevo_<fichero>` en `~/.claude/propuestas/` (sin subcarpeta de
  proyecto, es config de `~/.claude`; si hay colision de nombres, anade la
  ruta relativa: `nuevo_skills_jarvis_SKILL.md`; un AGENTS.md de proyecto va
  en `~/.claude/propuestas/<proyecto>/`) y abre tu mismo la comparacion,
  todos los ficheros de la tanda en UNA llamada:
  `~/.claude/bin/propuesta.sh "memoria · <tarea>" orig1 nuevo1 [orig2 nuevo2 ...]`
  (nunca `wt.exe -w new` ni vimdiff directo). Con varios ficheros, indica al
  usuario `:tabn` / `:tabp` para cambiar de pestana (su `gt` esta remapeado).
  El usuario aplica los cambios; cuando lo haga, borra la propuesta. Los ficheros a
  borrar enumeralos en el informe, no en vimdiff.
- Commits solo si el usuario lo pide (repo `~/.claude` o `/mnt/c/work/home`),
  sin lineas de atribucion.
