# Estructura de una obra

Ruta: `/mnt/c/work/obras/<obra>/` (un repositorio git por obra en gitlab.tunelia.com/obras).

```
<obra>/
├── README.md            # contactos, IPs, accesos remotos (anydesk, VPN)
├── CHANGELOG
├── jarvis/              # una remota, o subcarpetas por remota/túnel (islares/jarvis/{hoz,limpias,gibaja})
└── shd/                 # base de datos / sinópticos de Shield (bd/, *.svi)
```

## Ficheros de una remota

Versión genérica (para cliente) en la documentación oficial, `patterns.md` («Estructura de un proyecto»). Aquí, la realidad de las obras.

| Fichero | Contenido |
| --- | --- |
| `jarvis.prg` | Principal: pragmas, mensajes de driver, `#driver`, `#define N_XXX` + `#include` de módulos, `init.prg`, automatismos globales. |
| `misc.prg` | Tipos comunes (TUBE, ZONE, CT, GALLERY, USE, ANA_FILTER_INT, PBOOL), `CTRL` (estadísticas), mensajes globales. Se incluye el primero. |
| `modbus.prg` | `MB_SERVER`/`JT_SERVER` (estado de cabeceras), refresco de pantallas modbus. |
| `redun.prg` | Autómata `A_DUP` de redundancia (27 copias); ver `patrones.md`. |
| `<equipo>.prg` | Un módulo por equipo/fabricante. |
| `init.prg` | Instancias (`A_FAN fan[N_FAN];`) y su configuración: tube, zone_ini/fin, inv, tp, `settype`. |
| `fan_ctrl.prg` | Automatismo de ventilación `FANCTRL` (uno por tubo: `fctrl_ta.tube = TUBE1;`). |
| `sim.prg`, `schemas.prg` | Simulación y escenarios (formación). |
| `jarvis.dev` | Incluye type.dev, misc.dev, cas.dev, autolink.dev; grupos `.action`; IPs y `mb_*.dev`; parámetros `@`. |
| `type.dev` | Presentación de tipos en Shield. |
| `cas.dev` | Carpetas y dispositivos visibles en Shield. |
| `mb_<cabecera>.dev` | E/S de cada cabecera WAGO. |
| `jarvis.act` | Secuencias de acciones. |
| `jarvis.cas` / `jarvis.cat` / `jarvis.cio` | Config. driver cas / categorías / descripciones de E/S. |
| `jarvis.pst` / `.psk` | Persistencias (las escribe Jarvis; no tocar). |

## jarvis.prg tipo (orden importa)

```c
//#define SIM
#pragma option "t"
#pragma vers "LHOZ"
#pragma size dev 16000
#pragma size string 65000
#pragma size code 96000
#pragma size log 1024000
#define AUTOM_VERSION "1a"
string ver = "08 May 2026 - Hoz";
#define NAME "Remota Hoz"
#pragma desc NAME

#define INTERVAL_STADISTICS 10
#define INTERVAL_IO         5
#define INTERVAL_ANALOG     3
#define INTERVAL_CHECK      2

msg_t MSG_MODBUS; msg_t MSG_JETIO; msg_t MSG_ETHRAW;

#driver "cas"
#driver "modbus -n -p -t 100 -m MSG_MODBUS"
#driver "ethraw -m MSG_ETHRAW"
#driver "action -w 10"

#pragma debug
? "# Arranque JARVIS ", NAME, ", PRG: ", AUTOM_VERSION, "\n";
#pragma silent

#include "misc.prg"
CTRL ctrl;
#include "modbus.prg"
#define N_FAN 14
#include "fan.prg"
...
#include "init.prg"
#include "fan_ctrl.prg"
FANCTRL fctrl_t1;  fctrl_t1.tube = TUBE1;
#include "tend.prg"
```

## Dominio: túneles

- Tubos (`TUBE1..4`) y zonas (`ZONE`), sentido de circulación por tubo; los ventiladores
  cubren un rango de zonas e `inv = true` si pueden invertir ante incendio en el otro tubo.
- Automatismo de ventilación (`FANCTRL`): estados rest, prefire (pendiente de confirmar),
  fire (evacuación fluida/atasco), fire_exp (expulsión), copa (CO/opacidad), fire_other,
  block; opciones desde Shield `opt_fack`, `opt_fnack`, `opt_block`, `opt_fire_exp`.
- Acciones por tubo: apertura, precaución, cierre total/carril, meteo... mueven señales
  (semáforos RAV/AA, aspa-flecha, PLV/velocidad, barreras, PMV).
- Sistemas habituales: CO/OPA/anemómetros, incendio (detectores, cable lineal AP Sensing/
  Listec), DAI (Citilog, Traficon, Bosch), SOS (DGT, Ipefono, Barix, Equitel), CCTV,
  megafonía (Optimux, EVAC), PMV/paneles DGT, aforos por espiras, iluminación (circuitos,
  DALI, células), PCI/BIE, galerías, CT/unifilares/analizadores, SAI y grupos electrógenos,
  meteorológicas, gálibos, redundancia (`#dup`).

# Especificación de una obra: carpeta `espec/` (convención acordada con Vicente, 2026-11-03)

Toda la información que Vicente me da para entender una remota va en `<obra>/jarvis/<remota>/espec/`,
versionada en git con la obra (es por remota porque las cabeceras pertenecen a una remota). Lo voluminoso que no
proceso (planos, xls originales, PDF de protocolos) sigue en `<obra>/doc/`. No usar `.claude/` para datos de obra.

```
espec/
├── obra.md                 # ficha de la remota (plantilla: plantillas/obra.md de esta skill)
├── señales_<cabecera>.csv  # listado del integrador, exportado tal cual del xls/ods, uno por cabecera
├── mapa.csv                # tabla normalizada, uno por remota: la genero yo, la valida Vicente
└── protocolos/             # opcional: PDF/capturas de protocolos de fabricante de esta remota
```

| Fichero | Quién lo escribe | Papel |
| --- | --- | --- |
| `obra.md` | Vicente (yo la actualizo al cerrar cada módulo y al confirmar datos) | Ficha con apartados fijos: Túnel, Cabeceras, Equipos por cabecera, Equipos por protocolo, Hecho, Decisiones (fechadas), Pendientes. |
| `señales_<cabecera>.csv` | Integrador (Vicente exporta) | **No se retoca**: las correcciones van al mapa. Solo exijo dos columnas: dirección Modbus y descripción; el resto (modelo de tarjeta, canal, tag, comentarios) lo aprovecho si está. Separador `;`, Latin-1 habitual. Una revisión nueva del listado sustituye el fichero; el historial lo guarda git. |
| `mapa.csv` | Yo (propuesta), Vicente valida | Contrato entre el listado y los fuentes. De él salen `mb_<cabecera>.dev`, trazas y cuentas de `init.prg`, `#define IP_*` de `jarvis.dev` y esqueleto de `cas.dev`. Cuando cambia un listado se regenera y se comparan solo las diferencias. |

## Regla de nombres

El identificador de cabecera de la tabla «Cabeceras» de la ficha (`upd1`, `upd_sai`, `icp_t1`) es el mismo en todo:
`señales_upd1.csv`, `mb_upd1.dev`, `IP_UPD1`, `wago[n]` (índice en la ficha), trazas `mb_e_upd1`/`mb_s_upd1`.

Las tablas markdown de la ficha van **con las columnas alineadas** (relleno de espacios, como deja `:TableFormat` de
vim): Vicente las lee en vim sin renderizar (2026-11-04).

## Formato de `mapa.csv`

Separador `;`, Latin-1 (como los fuentes), una fila por canal del listado, cabecera por cabecera y en orden de dirección:

```
cabecera;direccion;dispositivo;descripcion;estado;nota
upd1;%IX000.0;uni_ip[0].in;Acometida Red;ok;
upd1;%IX002.1;;OUT 1 (conmutacion automatica);dudosa;A_UNI_CRG solo tiene in/in_fail
upd_sai;%IX002.1;;;ignorar;listado pone %IX2.X1 (error de la hoja), canal vacio
```

- `direccion`: normalizada a la forma de Jarvis (`%IX000.0`, no `%IX0000.0`). Retornos propios de salidas WAGO (`%IX512.x`) y
  trazas (`%IW000`, `%IW512`) los añado yo al generar el .dev, no van en el mapa.
- `dispositivo`: dispositivo Jarvis completo (`fan[2].in_on`); vacío si `estado` no es `ok`.
- `estado`: `ok` (asignado), `nueva` (señal sin módulo o sin señal en el módulo: hay que decidir), `dudosa` (interpretación
  insegura), `ignorar` (reserva, vacío o no se integra). Vicente resuelve `nueva`/`dudosa` editando el mapa.

## Flujo por fases (revisión de Vicente en cada una)

1. Vicente rellena la ficha y exporta los CSV.
2. Genero `mapa.csv` (propuesta en `~/.claude/propuestas/<obra>/`) y se discuten las filas `nueva`/`dudosa`.
   Contrastar el listado con los módulos de la remota (señales que declara cada `autom`) y con `cas.dev` antes de proponer índices.
3. Del mapa validado salen `mb_*.dev`, `init.prg`, `jarvis.dev`, `cas.dev`. **Los escribe Vicente**: me pide
   propuestas solo para listados largos (un `mb_*.dev` entero) o cuando duda de qué módulo/protocolo aplicar.
4. Equipos por protocolo: módulo más reciente del catálogo por cada fila de la tabla de la ficha; módulo nuevo solo si no existe.
5. Prueba con `probar.sh` y un `jarvis.prg` reducido.

Reparto (2026-11-03): yo hago la ficha inicial y el mapa (fases 1-2) y respondo dudas de catálogo y protocolos; Vicente
hace los fuentes y no quiere un túnel entero sin supervisión. Posibles herramientas si hacen falta para listados largos:
`mapa2dev.py` (mapa → ficheros de cabecera) y un diccionario descripción del integrador → señal Jarvis.
Primer caso: aucalsa-ap66/jarvis/vegaviesga/espec/ (ficha y mapa desde 2026-11-03).
