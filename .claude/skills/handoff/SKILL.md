---
name: handoff
description: Cierra la sesion dejando un handoff conciso para retomar la tarea en la siguiente. Usar solo cuando el usuario lo pida (/handoff, "recapitula", "cierra sesion", "deja el handoff").
disable-model-invocation: true
---

# handoff

Escribe `handoff.md` en la carpeta de memoria del proyecto (la que indica el
sistema como "persistent file-based memory"). El hook `SessionStart`
`~/.claude/hooks/handoff-inicio.sh` lo inyecta al abrir la siguiente sesion,
con las instrucciones para retomar; la skill no interviene al retomar.

La carpeta de memoria depende del directorio donde se abre la sesion, no del
proyecto: el handoff solo se recupera si la siguiente sesion se abre en el
mismo directorio. Si la tarea es de una subcarpeta (p. ej. una obra dentro de
`obras`), dilo en la linea "Estado" para que el usuario sepa donde abrirla.

## Antes de escribir

- Si en la sesion ha habido aprendizajes, decisiones o correcciones del
  usuario sin registrar, sugiere `/memory-rev` primero. El handoff no es el
  sitio para eso.
- Propuestas pendientes: sacalas de `~/.claude/propuestas/.pendientes`
  (una tanda por linea: titulo, tab, ficheros), filtrando por el proyecto, no
  de memoria.

## Reglas

- Sobrescribe el fichero entero: un solo handoff por carpeta, nunca acumules.
- Maximo unas 15 lineas, una idea por linea y sin pasar de ~100 columnas.
  Solo lo necesario para seguir la tarea; nada de historia de lo hecho ni de
  lo que ya recogen git, CLAUDE.md o la memoria.
- Si no hay tarea abierta, no escribas nada: dilo, y borra el handoff previo
  si existe y esta obsoleto.
- No lo anotes en MEMORY.md (no es memoria duradera) ni en el arbol del proyecto.
- No incluyas credenciales ni datos de la wiki.

## Formato

```
# Handoff <AAAA-MM-DD>
Tarea: <una linea>
Punto exacto: <donde nos quedamos>
Siguiente paso: <accion concreta que me toca a mi>
Esperando de ti: <lo que depende del usuario: revisar propuesta, build, decision>
Estado: <ficheros tocados; propuestas pendientes (de .pendientes); vimdiff sin aplicar>
Contexto clave: <solo decisiones o trampas que no se deducen del codigo ni de git>
```

Omite las lineas que no apliquen. Rutas absolutas para los ficheros.

## Al terminar

Muestra el contenido escrito y la ruta, en 3-4 lineas.
