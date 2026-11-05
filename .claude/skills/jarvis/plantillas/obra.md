# Ficha de la remota: <obra> / <remota>

Plantilla de `espec/obra.md` (convencion en obra.md de la skill jarvis). Mantener los apartados y sus nombres;
el contenido puede ser breve. Fechar las decisiones.

## Tunel

- Tubos: 2 (TUBE1 = <sentido/boca>, TUBE2 = <sentido/boca>), <n> carriles por tubo.
- Zonas por tubo: <n> (criterio: <ventiladores / detectores / longitud>).
- Bocas y nombres usados en campo: <Leon / Asturias>.
- Edificios y armarios: <CT, cuadro BT, cuadro SAI, galerias>.

## Cabeceras

| Id | Modelo | IP | wago[n] | Armario | Listado |
| --- | --- | --- | --- | --- | --- |
| upd1 | WAGO 750-862 | 192.168.x.x | 0 | Cuadro BT | señales_upd1.csv |
| upd_sai | WAGO 750-862 | 192.168.x.x | 1 | Cuadro SAI | señales_upd_sai.csv |
| icp_t1 | ICP (jetio/modbus) | 192.168.x.x | 2 | <donde> | señales_icp_t1.csv |

El Id manda sobre todos los nombres: `señales_<id>.csv`, `mb_<id>.dev`, `IP_<ID>`, trazas `mb_e_<id>`/`mb_s_<id>`.

## Equipos por cabecera

Por sistema, lo que hay conectado a E/S y a que cabecera (los detalles canal a canal estan en los listados):

- Ventilacion: <n> ventiladores por tubo, CO/NO/OPA/ANE y donde se leen.
- Señalizacion: semaforos (tipo: RAV, AA, RR), barreras, aspa-flecha.
- Iluminacion: circuitos (soleado, nublado, nocturno, permanente, exterior) y celulas.
- Incendio / PCI: central (zonas, alarma general, averia), BIE, pulsadores.
- CT / unifilar: estados de cuadro, conmutacion red/grupo, bateria de condensadores.
- Otros: <galibos, galerias, meteo...>

## Equipos por protocolo

| Equipo | Fabricante / modelo | Protocolo | IP:puerto | Documentacion | Modulo (catalogo) |
| --- | --- | --- | --- | --- | --- |
| Analizador de red | <...> | Modbus TCP (Nport RS485) | 192.168.x.x:502 | doc/protocolos/<...>.pdf | ana_<...>.prg |
| Grupo electrogeno | <...> | Modbus TCP | | | |
| SAI | <...> | Modbus TCP / SNMP | | | sai_<...>.prg |
| Postes SOS (<n>) | <...> | <...> | | | sos_<...>.prg |
| Paneles / aspa-flecha | <...> | DGT (BDU completo) | | | panel_dgt.prg |

## Hecho

- <fecha>: <modulo> (<ficheros tocados, E/S, tipos>). Revisado y compilado.

## Decisiones

- <fecha>: <decision y motivo>. Ejemplo: iluminacion no se integra, sigue en la UPD antigua.

## Pendientes

- <lo que se deja para una fase posterior>
