#!/usr/bin/env python3
"""Regenera los datos de catalogo.md: por modulo .prg, nº de copias en las obras (sin old*) y la
copia mas reciente segun el ULTIMO COMMIT del fichero en el repositorio de su obra (mtime solo
sirve para preseleccionar las 5 candidatas: puede reflejar un checkout). Excluye simuladores.
Uso: python3 regenerar_catalogo.py [modulo.prg ...]   (sin argumentos: los de catalogo.md)
Imprime 'modulo<TAB>copias<TAB>fecha<TAB>ruta'; el catalogo se actualiza a mano con el resultado."""
import os,re,subprocess,sys,collections
OBRAS='/mnt/c/work/obras'
HERE=os.path.dirname(os.path.abspath(__file__))
out=subprocess.run(['find',OBRAS,'-name','*.prg','-not','-path','*/.git/*','-not','-path','*/old*',
                    '-printf','%TY-%Tm-%Td %f %h\n'],capture_output=True,text=True,errors='replace').stdout
by=collections.defaultdict(list)
for l in out.splitlines():
    d,f,p=l.split(' ',2); by[f].append((d,os.path.relpath(p,OBRAS)))
mods=sys.argv[1:] or sorted(set(re.findall(r'\b([a-z0-9_]+\.prg)\b',open(os.path.join(HERE,'catalogo.md'),encoding='utf-8').read())))
def gdate(path,f):
    r=subprocess.run(['git','-C',os.path.join(OBRAS,path),'log','-1','--format=%cs','--',f],capture_output=True,text=True)
    return r.stdout.strip()
for m in mods:
    c=sorted([x for x in by.get(m,[]) if 'simulador' not in x[1]],key=lambda x:(x[0],x[1]),reverse=True)[:5]
    best=None
    for d,p in c:
        g=gdate(p,m) or d
        if best is None or g>best[0]: best=(g,p)
    print('%s\t%d\t%s\t%s'%(m,len(by.get(m,[])),*(best or ('','-'))))
