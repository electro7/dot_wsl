---
name: code-comment-reformat
description: Reformatea los comentarios de ficheros de codigo C/C++ (y similares) al estilo de ~/.vim/doc/estilo_codigo.txt: comentarios tipo /* */, bloques con asterisco alineado, cabecera de fichero y comentario de funcion con linea de guiones. Usar cuando el usuario pida reformatear, normalizar o ajustar los comentarios de uno o varios ficheros fuente.
argument-hint: <fichero> [<fichero>...]
---

# code-comment-reformat

Reformatea SOLO los comentarios de los ficheros indicados en `$ARGUMENTS`
segun el estilo de `~/.vim/doc/estilo_codigo.txt` (seccion "Comentarios").
Si no se indica ningun fichero, pregunta cuales.

No toques el codigo: ni indentacion, ni llaves, ni nombres, ni espacios fuera
de los comentarios. No cambies el texto de los comentarios salvo lo necesario
para reajustar el ancho. No compiles.

## Flujo de trabajo (obligatorio)

1. NUNCA edites el fichero original. Por cada fichero haz una copia llamada
   `nuevo_<fichero>`, conservando la extension (`nuevo_main.c`). Ubicacion:
   - Si el original esta en el home del usuario (~): en `~/.claude/propuestas/`
     (crealo si no existe).
   - Si es de un proyecto (p. ej. bajo /mnt/c/work): junto al original, en su
     mismo directorio.
   Si ya existe una copia con ese nombre, o hay colision entre ficheros con el
   mismo nombre, anade el proyecto: `nuevo_<proyecto>_main.c`.
2. Antes de editar, averigua codificacion y finales de linea del original:
   - `file <fichero>`
   - `grep -c $'\r' <fichero>` (si es mayor que 0, son CRLF)
3. Genera la propuesta con el script incluido en la skill (no modifica el
   original; conserva codificacion UTF-8/Latin-1, CRLF/LF y los bytes):

   `python3 -I ~/.claude/skills/code-comment-reformat/scripts/reformat.py <original> <propuesta>`

   El script aplica las reglas de abajo, imprime los avisos (lineas >80,
   comentarios sin tocar) y el numero de comentarios de funcion. Revisa su
   salida y el diff; si hace falta un retoque manual en la propuesta, hazlo
   con un script Python (`-I`, `newline`/bytes intactos), nunca con Edit/Write
   sobre texto Latin-1 con acentos. Localiza las lineas por contenido.
   Despues comprueba que el codigo no ha cambiado (original y propuesta,
   sin comentarios, deben ser iguales) y que CRLF/bytes se conservan.
   Si el usuario ya conserva a proposito un `//` (p. ej. un comentario al
   final de linea que se pasaria de 80 columnas), respetalo y avisalo.
4. Al terminar, muestra un resumen breve y abre la comparacion tu mismo:
   `wt.exe -w new wsl.exe -d Debian -- vimdiff <original> <propuesta>`
   (rutas absolutas). El usuario aplica los cambios. WinMerge solo si lo pide.
5. No hagas commit ni compiles.

## Reglas de formato

Ancho maximo: 80 columnas por linea (incluida la indentacion del comentario).

### 1. Comentarios tipo C
Convierte `// texto` a `/* texto */`. Una secuencia de lineas `//` consecutivas
pasa a ser un unico bloque multilinea (regla 2). Si el texto no cabe en 80
columnas, usa bloque multilinea.

### 2. Bloque multilinea
Asteriscos alineados con la columna de `/*`, dos espacios tras el `*`:

```
/*
*  Inicio del comentario
*  que concluye en la proxima linea
*/
```

Un comentario de una sola linea que cabe se deja como `/* texto */`.
Comentarios al final de una linea de codigo (`x++; /* texto */`) se dejan en
linea, solo convertidos a `/* */` si eran `//`.

### 3. Cabecera de fichero
Al principio del fichero, con este formato (lineas de asteriscos de la misma
longitud, 73 columnas, y 71 guiones en la linea separadora):

```
/************************************************************************
* NOMBRE DEL PROYECTO
* -----------------------------------------------------------------------
* Descripcion de lo que hace el archivo.
*************************************************************************/
```

Reutiliza el contenido de la cabecera existente (nombre, autor, version,
fecha, copyright, lista de cambios). No inventes datos: si falta algo,
dejalo fuera y mencionalo en el resumen.

### 4. Comentario de funcion (lleva linea de guiones)
Todo comentario que precede a una funcion (definicion de funcion o metodo, con
su `{` en columna 0) se escribe asi: el titulo breve tras `/* `, y la linea de
guiones SIEMPRE al final del comentario, cerrando el comentario en esa misma
linea con `*/` (sin linea aparte para el cierre). La linea de guiones es `*  `
mas 68 guiones mas `*/` (73 columnas en total).

Una sola linea de comentario:

```
/* Ordena la lista de memorias
*  --------------------------------------------------------------------*/
int list_sort(int base, int number)
```

Varias lineas (explicacion de parametros, valor de retorno...): la primera es
el titulo, el resto va debajo con el prefijo `*  `, y los guiones van al final,
despues de todo el texto (NO justo despues del titulo):

```
/* Registro de un control ADC
*  Devuelve:
*  >=0: indice del elemento registrado
*  -1 : si error
*  --------------------------------------------------------------------*/
```

- Si el titulo no cabe en 80 columnas con el `/* `, no lo recortes: ponlo en
  la linea siguiente como texto normal (`/*` solo, texto, guiones) y avisalo en
  el resumen.
- Un banner de `////////` con un titulo que precede a una funcion es un
  comentario de funcion: conviertelo a este formato.
- Es idempotente: si el comentario ya tiene linea de guiones (en este formato
  o en el anterior, con los guiones en linea propia tras el titulo), se quita
  y se vuelve a poner al final.
- Si una funcion no tiene comentario, NO lo inventes: listala en el resumen
  como "sin comentario".

### 5. Otros banners (no preceden a una funcion)
Un banner que no precede a una funcion (seccion, variables globales, tipos,
macros) NO lleva linea de guiones: una linea se convierte en
`/* texto */` y varias en bloque multilinea (regla 2).

## Casos que NO se tocan

- Cualquier `//` o `/*` dentro de cadenas, literales de caracter o URLs.
- Directivas del preprocesador (`#include`, `#define ...`) salvo su comentario
  final.
- Bloques `#if 0 ... #endif`: dejalos como estan.
- Codigo comentado: convierte `//` a `/* */` solo si no hay `*/` dentro; si lo
  hay, dejalo y avisalo en el resumen.
- Ficheros que no sean de codigo con comentarios C (si te pasan otro lenguaje,
  confirma antes cual es la sintaxis a usar).

## Resumen final

Devuelve, en espanol y breve: ficheros procesados, rutas de las propuestas,
numero aproximado de comentarios modificados, funciones sin comentario,
casos dejados sin tocar, y datos que faltan en la cabecera.
