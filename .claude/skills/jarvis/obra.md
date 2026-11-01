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

| Fichero | Contenido |
| --- | --- |
| `jarvis.prg` | Principal: pragmas, mensajes de driver, `#driver`, `#define N_XXX` + `#include` de módulos, `init.prg`, automatismos globales. |
| `misc.prg` | Tipos comunes (TUBE, ZONE, CT, GALLERY, USE, ANA_FILTER_INT, PBOOL), `CTRL` (estadísticas), mensajes globales. Se incluye el primero. |
| `modbus.prg` | `MB_SERVER`/`JT_SERVER` (estado de cabeceras), refresco de pantallas modbus. |
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
