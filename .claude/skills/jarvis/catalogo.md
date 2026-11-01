# Catálogo de módulos

Generado el 2026-11-01 sobre `/mnt/c/work/obras` (sin `old*` ni simuladores). Entre
paréntesis: nº de copias en todas las obras. "Más reciente" = fecha de modificación del
fichero, que puede reflejar un checkout y no un cambio real: comprobar con `git log` de esa obra.

Regenerar:
```bash
cd /mnt/c/work/obras && find . -name '*.prg' -not -path '*/.git/*' -not -path '*/old*' \
  -printf '%TY-%Tm-%Td %f %h\n' | sort -k2,2 -k1,1r | awk '!seen[$2]++'
```

## Base (en todas las obras)
| Módulo | Más reciente |
| --- | --- |
| misc.prg (132), modbus.prg (109) | islares/jarvis/gibaja |
| tend.prg (48) | islares/jarvis/hoz |
| redun.prg (27) | arroes/jarvis/villaviciosa |
| actions2.prg (83) — acciones V2 | islares/jarvis/hoz |
| ct.prg (96) — señales varias del CT | cerrado_calderon/jarvis/ersj |

## Ventilación
| Módulo | Más reciente |
| --- | --- |
| fan.prg (80) | cerrado_calderon/jarvis/ersj |
| fan_ctrl.prg (78), fan_meters.prg (91) | islares/jarvis/hoz |
| fan_cnf.prg (20), fan_ctrl_fuction.prg (18), init_fan_cnf.prg (8) | islares/jarvis/hoz |
| co_duran.prg (6) | cerrado_calderon/jarvis/casabermeja1-2 |
| copa_visic.prg (4) | folgoso/jarvis/folgoso |
| smoke.prg | miravete/jarvis/ppal |

## Incendio y PCI
| Módulo | Más reciente |
| --- | --- |
| fire.prg (65) — detectores por ED | arroes/jarvis/villaviciosa |
| fire_apsensing.prg (12) — cable lineal AP Sensing por modbus TCP sobre ethraw | islares/jarvis/hoz |
| pci.prg (32) | arroes/jarvis/villaviciosa |
| bie.prg (30) | tenerife/jarvis/guincho |

## Señalización y tráfico
| Módulo | Más reciente |
| --- | --- |
| sem.prg (104) | islares/jarvis/gibaja |
| barrier.prg (91) | cerrado_calderon/jarvis/ersj |
| arrow.prg (38), speed.prg (23), galibo.prg (46) | galibo: tenerife/jarvis/3mayo |
| panel.prg (90), panel_dgt.prg (84), panel_sdgt.prg (90) | arroes/jarvis/{villaviciosa,fabares}, islares/jarvis/hoz |
| panel_pmv.prg (89), panel_sp.prg (39), panel_af.prg (51) | islares/jarvis/hoz, cerrado_calderon/jarvis/ersj |
| aforo.prg (52), aforo_stat.prg (52) | islares/jarvis/limpias |

## DAI / CCTV
| Módulo | Más reciente |
| --- | --- |
| dai.prg (34) | tenerife/jarvis/3mayo |
| dai_traficon.prg (25) | tenerife/jarvis/chumberas |
| dai_citilog.prg (20) | audasa-ap9/jarvis/campolongo |
| dai_cascade.prg (10) | arroes/jarvis/cefontes |
| dai_bosch.prg (5) — en Hoz marcado "AUN NO SE HA PREPARADO" | islares/jarvis/hoz |
| cctv_pletac.prg | sanjuan/jarvis/ercc (2020) |
| domo.prg | sanjuan/jarvis/ercc |

## SOS y megafonía
| Módulo | Más reciente |
| --- | --- |
| sos_ipefono.prg (57) | cerrado_calderon/jarvis/casabermeja3 |
| sos_barix.prg (18) | miravete/jarvis/ppal |
| sos_dgt.prg (8) | tenerife/jarvis/3mayo |
| sos_equitel.prg (6) | axarquia/jarvis/ercc |
| optimux_v31.prg (10) | tenerife/jarvis/ercc |
| shmeg.prg (12) | pancorbo_penamaria/jarvis/penamaria/ercc |
| meg_evac.prg (5) | islares/jarvis/hoz |

## Iluminación
| Módulo | Más reciente |
| --- | --- |
| light.prg (90) | cerrado_calderon/jarvis/ersj |
| dali.prg (15) | cerrado_calderon/jarvis/ercc |

## Energía
| Módulo | Más reciente |
| --- | --- |
| unifilo.prg (47) | islares/jarvis/limpias |
| ana_circutor.prg (6) | arroes/jarvis/nievares |
| ana_hager.prg (5) | islares/jarvis/hoz |
| ana_trafo.prg | sanjuan/jarvis/ercc |
| sai_salicru_st.prg (8) | arroes/jarvis/fabares |
| sai_n204_tri.prg (7) | islares/jarvis/limpias |
| sai_zgr.prg (6) | audasa-ap9/jarvis/campolongo |
| sai_newsai.prg (6) | sella/jarvis/arenal |
| grelec_c2lan.prg (9) | islares/jarvis/limpias |

## Otros
| Módulo | Más reciente |
| --- | --- |
| gallery.prg (42) — galerías de evacuación | arroes/jarvis/villaviciosa |
| meteo.prg (8) | tenerife/jarvis/3mayo |
| meteo_dgt.prg (9) | fuentebuena/jarvis/ercc |
| climate.prg (6) | audasa-ap9/jarvis/campolongo |
