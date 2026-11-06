---
name: ToDo
description: Gestiona la lista de tareas del usuario en Todoist (conector MCP de claude.ai) - apuntar, consultar, reprogramar y completar tareas, y resumir lo pendiente. Usar siempre que el usuario diga "mira las tareas", "consulta las tareas", "las tareas", "pendientes", "recordatorios", "apunta", "recuérdame", "qué tengo hoy/esta semana", o hable de Todoist, o cuando durante un trabajo surja algo que convenga dejar anotado (en ese caso, proponerlo, no crearlo).
argument-hint: [<tarea o consulta>]
---

# ToDo

Las tareas del usuario viven en Todoist (plan Free, zona Europe/Madrid, la
semana empieza en lunes). Las consulta desde el móvil y desde casa, así que
todo lo que se apunte debe entenderse sin el contexto de la sesión.

## Herramientas

Las herramientas son `mcp__claude_ai_Todoist__*` y están diferidas: cárgalas
con `ToolSearch` (`select:mcp__claude_ai_Todoist__add-tasks,...`) antes de
llamarlas. Las habituales:

| Acción                         | Herramienta                      |
|--------------------------------|----------------------------------|
| Estructura de proyectos        | `get-overview` (sin projectId)   |
| Tareas de un proyecto          | `get-overview` con projectId     |
| Hoy / semana / vencidas        | `find-tasks-by-date`             |
| Buscar por texto o etiqueta    | `find-tasks`                     |
| Crear                          | `add-tasks` (varias en una llamada) |
| Cambiar fecha u hora           | `reschedule-tasks` (nunca `update-tasks`) |
| Cambiar texto, prioridad, etiquetas | `update-tasks`              |
| Completar / reabrir            | `complete-tasks` / `uncomplete-tasks` |
| Borrar                         | `delete-object`                  |
| Comentarios                    | `add-comments` / `find-comments` |

Trampas conocidas:
- `update-tasks` trata `projectId`, `sectionId` y `parentId` como un
  movimiento: no los reenvíes salvo que quieras mover la tarea.
- Las duraciones de un día o más no se muestran en las apps: no las pongas
  salvo petición expresa.
- `reschedule-tasks` falla si la tarea no tiene fecha ("Rescheduling requires
  an existing due date"): para poner la primera fecha usa `update-tasks`
  con `dueString`.
- Las fechas se pueden dar en lenguaje natural ("viernes", "mañana 9:00",
  "cada lunes"); Todoist las interpreta en la zona del usuario.

## Proyectos

| Proyecto   | ID                | Qué va aquí                                            |
|------------|-------------------|--------------------------------------------------------|
| Obras      | 6hwR7vfJv4fwMRm7  | PLC Jarvis y BD Shield de las obras (/mnt/c/work/obras) |
| Desarrollo | 6hwR7vXp3Qh3jQRg  | Software de /mnt/c/work/soft (jarvis, shd, timap, titime...) |
| Gestión    | 6hwR7vfV7qXhF5Rj  | Dirección de la empresa (Tunelia): clientes, personal, ofertas, administración |
| Personal   | 6hwR7vcGCV9CQ6qM  | Cosas personales                                       |
| Ofimática  | 6hwR98R7mGPW8Xq8  | Equipos, PCs, licencias y herramientas de oficina      |
| Inbox      | 6hvgqHvPPg8rj6G2  | Lo que no encaje claramente; preguntar después dónde va |

Secciones de Obras (una por obra, con el nombre de su carpeta en
/mnt/c/work/obras):

| Sección      | ID                |
|--------------|-------------------|
| tenerife_cic | 6hwRg5QgjrcxPvx7  |
| yebenes      | 6hwW7wq6hJj7f2hf  |

Si el usuario crea o pide crear proyectos, secciones o etiquetas nuevos,
actualiza esta tabla en la propia skill (la configuración de Claude se
edita directamente, sin propuesta).

## Convenciones al crear tareas

- Título corto, en infinitivo, con el objeto concreto: "Revisar temporizador
  de ventiladores en túnel X", no "ventiladores".
- Si procede del trabajo en curso, pon en la descripción el fichero o la
  ruta (`/mnt/c/work/obras/...`), la issue de GitLab o el dato que haga
  falta para retomarlo sin la sesión.
- Proyecto según la tabla; ante la duda, Inbox y dilo en la respuesta.
- Prioridad solo si el usuario la indica (urgente = p1).
- Fecha solo si el usuario la da o es evidente ("para el viernes").
- Etiquetas: de momento no hay ninguna definida; no inventes etiquetas,
  propónlas si ves un patrón repetido.

## Reglas de conducta

- **Preguntar no es ordenar.** Crear, completar, reprogramar o borrar solo
  con un imperativo claro ("apunta", "crea", "marca hecha", "pasa al
  lunes"). Ante "¿puedes apuntar...?" explica qué harías y espera.
- **Consultas, directo.** "¿Qué tengo hoy?" se responde leyendo Todoist, sin
  pedir permiso.
- **Al terminar un trabajo**, si queda algo pendiente que no se hizo (una
  prueba por hacer, una compilación que el usuario debe lanzar, un fichero
  por revisar), propón apuntarlo con el título que le pondrías; no lo crees.
- **Confirma lo creado** en una línea por tarea: título, proyecto y fecha.
- **Borrar**: confirma antes salvo que el usuario haya nombrado la tarea
  concreta en la misma orden.

## Formato de los resúmenes

Lista agrupada por proyecto, cada tarea en una línea con fecha si la tiene;
primero las vencidas, luego hoy, luego el resto. Sin IDs ni ruido técnico.
Si no hay nada, dilo en una frase.
