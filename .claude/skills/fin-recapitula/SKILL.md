---
name: fin-recapitula
description: Cierra la sesion dejando un handoff conciso para retomar la tarea en la siguiente. Usar solo cuando el usuario lo pida (/fin-recapitula, "recapitula", "cierra sesion", "deja el handoff").
disable-model-invocation: true
---

# fin-recapitula

Escribe `handoff.md` en la carpeta de memoria del proyecto (la que indica el
sistema como "persistent file-based memory"; normalmente
`~/.claude/projects/<cwd con / -> ->/memory/handoff.md`). Un hook
`SessionStart` (`~/.claude/hooks/handoff-inicio.sh`) lo inyecta al abrir la
siguiente sesion.

## Reglas

- Sobrescribe el fichero entero: un solo handoff por proyecto, nunca acumules.
- Maximo unas 15 lineas. Solo lo necesario para seguir la tarea; nada de
  historia de lo hecho ni de lo que ya recogen git, CLAUDE.md o la memoria.
- Si no hay tarea abierta, no escribas nada: dilo, y borra el handoff previo
  si existe y esta obsoleto.
- No lo anotes en MEMORY.md (no es memoria duradera) ni en el arbol del proyecto.
- No incluyas credenciales ni datos de la wiki.

## Formato

```
# Handoff <AAAA-MM-DD>
Tarea: <una linea>
Punto exacto: <donde nos quedamos>
Siguiente paso: <accion concreta>
Estado: <ficheros tocados; propuestas pendientes en ~/.claude/propuestas/<proyecto>/; vimdiff sin aplicar>
Contexto clave: <solo decisiones o trampas que no se deducen del codigo ni de git>
```

Omite las lineas que no apliquen. Rutas absolutas para los ficheros.

## Al terminar

Muestra el contenido escrito y la ruta, en 3-4 lineas.

## Al retomar (cuando el hook lo inyecte)

Resume en una linea donde estabamos y propone continuar. Cuando la tarea
termine, borra `handoff.md` (o reescribelo si queda trabajo).
