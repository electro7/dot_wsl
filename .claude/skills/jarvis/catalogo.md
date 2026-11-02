# Catálogo de módulos

Generado el 2026-11-02 sobre `/mnt/c/work/obras` (sin `old*`; los simuladores no cuentan como "más reciente").
Entre paréntesis: nº de copias en todas las obras. "Más reciente" = copia con el **último commit** más reciente
en el repositorio de su obra (entre las 5 con mtime más reciente: el mtime solo puede reflejar un checkout, p. ej. `islares/jarvis/limpias`
tiene mtime del 2026-10-26 en muchos módulos y commits anteriores); entre paréntesis, la fecha de ese commit. Con varios módulos en una fila, la
ruta va por módulo cuando difiere. Aun así, comprobar con `git log` de esa obra antes de copiar.

Regenerar (imprime módulo, copias, fecha y ruta; el catálogo se actualiza a mano):
```bash
python3 ~/.claude/skills/jarvis/regenerar_catalogo.py            # todos los de este catálogo
python3 ~/.claude/skills/jarvis/regenerar_catalogo.py sos.prg    # solo los indicados
```

## Base (en todas las obras)
| Módulo | Más reciente |
| --- | --- |
| misc.prg (132), modbus.prg (109) | misc: audasa-ap9/jarvis/campolongo; modbus: aucalsa-ap66/jarvis/entrerregueras |
| tend.prg (48) | audasa-ap9/jarvis/campolongo (2026-10-13) |
| redun.prg (27) | arroes/jarvis/villaviciosa (2026-10-26) |
| actions2.prg (83) — acciones V2 | aucalsa-ap66/jarvis/entrerregueras (2026-10-15) |
| ct.prg (96) — señales varias del CT | arroes/jarvis/villaviciosa (2026-10-26) |

## Ventilación
| Módulo | Más reciente |
| --- | --- |
| fan.prg (80) | audasa-ap9/jarvis/campolongo (2026-10-13) |
| fan_ctrl.prg (78), fan_meters.prg (91) | fan_ctrl: audasa-ap9/jarvis/campolongo; fan_meters: audasa-ap9/jarvis/pedra |
| fan_cnf.prg (20), fan_ctrl_fuction.prg (18), init_fan_cnf.prg (8) | fan_cnf: audasa-ap9/jarvis/campolongo; fan_ctrl_fuction: audasa-ap9/jarvis/campolongo; init_fan_cnf: tenerife/jarvis/guincho |
| co_duran.prg (6) | cerrado_calderon/jarvis/casabermeja3 (2026-08-06) |
| copa_visic.prg (4) | pancorbo_penamaria/jarvis/penamaria/ercc (2025-11-27) |
| smoke.prg | miravete/jarvis/ppal (2026-04-28) |

## Incendio y PCI
| Módulo | Más reciente |
| --- | --- |
| fire.prg (65) — detectores por ED | arroes/jarvis/villaviciosa (2026-10-26) |
| fire_apsensing.prg (12) — cable lineal AP Sensing por modbus TCP sobre ethraw | islares/jarvis/hoz (2026-07-01) |
| pci.prg (32) | arroes/jarvis/villaviciosa (2026-10-26) |
| bie.prg (30) | audasa-ap9/jarvis/montecelo (2026-09-24) |

## Señalización y tráfico
| Módulo | Más reciente |
| --- | --- |
| sem.prg (104) | aucalsa-ap66/jarvis/entrerregueras (2026-10-15) |
| barrier.prg (91) | audasa-ap9/jarvis/montecelo (2026-10-13) |
| arrow.prg (38), speed.prg (23), galibo.prg (46) | arrow: tenerife/jarvis/tf4; speed: miravete/jarvis/ppal; galibo: tenerife/jarvis/chumberas |
| panel.prg (90), panel_dgt.prg (84), panel_sdgt.prg (90) | panel: arroes/jarvis/villaviciosa; panel_dgt: arroes/jarvis/villaviciosa; panel_sdgt: audasa-ap9/jarvis/madroa |
| panel_pmv.prg (89), panel_sp.prg (39), panel_af.prg (51) | panel_pmv: tenerife/jarvis/vialitoral; panel_sp: axarquia/jarvis/torrox; panel_af: arroes/jarvis/villaviciosa |
| aforo.prg (52), aforo_stat.prg (52) | aforo: tenerife/jarvis/chumberas; aforo_stat: ibiza_sant_rafel/jarvis |

## DAI / CCTV
| Módulo | Más reciente |
| --- | --- |
| dai.prg (34) | tenerife/jarvis/vialitoral (2026-09-25) |
| dai_traficon.prg (25) | tenerife/jarvis/guincho (2026-09-17) |
| dai_citilog.prg (20) | audasa-ap9/jarvis/campolongo (2026-10-13) |
| dai_cascade.prg (10) | arroes/jarvis/infanzon (2026-10-09) |
| dai_bosch.prg (5) — en Hoz marcado "AUN NO SE HA PREPARADO" | islares/jarvis/hoz (2026-05-07) |
| cctv_pletac.prg | sanjuan/jarvis/ercc (2020-02-11) |
| domo.prg | serrallo/siga/ercc (2026-02-17) |

## SOS y megafonía
| Módulo | Más reciente |
| --- | --- |
| sos_ipefono.prg (57) | arroes/jarvis/villaviciosa (2026-10-26) |
| sos_barix.prg (18) | miravete/jarvis/ppal (2026-04-28) |
| sos_dgt.prg (8) | tenerife/jarvis/guincho (2026-09-16) |
| sos_equitel.prg (6) | axarquia/jarvis/ercc (2026-03-13) |
| optimux_v31.prg (10) | tenerife/jarvis/ercc (2026-07-03) |
| shmeg.prg (12) | pancorbo_penamaria/jarvis/penamaria/ercc (2026-09-16) |
| meg_evac.prg (5) | santander/jarvis/astillero (2026-04-09) |

## Iluminación
| Módulo | Más reciente |
| --- | --- |
| light.prg (90) | arroes/jarvis/villaviciosa (2026-10-26) |
| dali.prg (15) | cerrado_calderon/jarvis/ercc (2026-09-02) |

## Energía
| Módulo | Más reciente |
| --- | --- |
| unifilo.prg (47) | aucalsa-ap66/jarvis/entrerregueras (2026-10-15) |
| ana_circutor.prg (6) | arroes/jarvis/nievares (2026-05-07) |
| ana_hager.prg (5) | santander/jarvis/marga (2026-07-10) |
| ana_trafo.prg | sanjuan/jarvis/ercc (2024-06-21) |
| sai_salicru_st.prg (8) | arroes/jarvis/fabares (2026-07-31) |
| sai_n204_tri.prg (7) | islares/jarvis/limpias (2025-10-13) |
| sai_zgr.prg (6) | audasa-ap9/jarvis/sartego (2026-06-17) |
| sai_newsai.prg (6) | sella/jarvis/tezangos (2025-06-04) |
| grelec_c2lan.prg (9) | arroes/jarvis/nievares (2026-09-21) |

## Otros
| Módulo | Más reciente |
| --- | --- |
| gallery.prg (42) — galerías de evacuación | arroes/jarvis/villaviciosa (2026-10-26) |
| meteo.prg (8) | tenerife/jarvis/tf4 (2026-09-01) |
| meteo_dgt.prg (9) | fuentebuena/jarvis/ercc (2024-11-21) |
| climate.prg (6) | audasa-ap9/jarvis/sartego (2026-04-22) |

## Otros módulos con 5 o más copias (no clasificados)
Aparecieron al regenerar el catálogo (2026-11-02). La función es la que sugiere el nombre; **no verificada**: mirar el
fichero antes de usarlo.

| Módulo | Más reciente |
| --- | --- |
| sos.prg (20) | miravete/jarvis/ppal (2026-10-05) |
| actions.prg (15) — probablemente acciones anteriores a `actions2.prg` | padrun/jarvis/angelu (2026-03-10) |
| optimux_proto.prg (12) | tenerife/jarvis/ercc (2026-07-03) |
| mphone.prg (10) | santander/jarvis/torrelavega (2026-04-13) |
| panel_stop.prg (9) | tenerife/jarvis/guincho (2026-09-23) |
| jetio.prg (9) | arroes/jarvis/brañaviella (2025-12-19) |
| ana.prg (9) | audasa-ap9/jarvis/pedra (2026-05-14) |
| ortrat.prg (6), ortrat_proto.prg (7) | santander/jarvis/astillero (2026-01-22) |
| shmeg_ipefono.prg (6) | audasa-ap9/jarvis/sartego (2026-10-16) |
| mtx_gal.prg (6) | arroes/jarvis/nievares (2025-12-03) |
| icp.prg (6) | axarquia/jarvis/lagos (2026-02-13) |
| ser2eth.prg (6) | huca/siga (2024-08-01) |
| sai.prg (5) | cerrado_calderon/jarvis/ercc (2026-05-04) |
| panel_sainco.prg (5), panel_aucalsa.prg (5) | axarquia/jarvis/torrox (2026-02-11); aucalsa/jarvis/negron_I (2022-09-02) |
| comm.prg (5) | viastur/jarvis/bobes/pasarela (2025-07-09) |

Las carpetas `*/siga/*` y `ria_fabares/neos/siga/*` son de la generación anterior (SIGA); sus módulos (`siga.prg`,
`vsignal.prg`, `tube.prg`...) no se catalogan.

