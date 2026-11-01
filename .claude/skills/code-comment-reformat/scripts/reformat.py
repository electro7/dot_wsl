"""Reformatea los comentarios de un fuente C/C++ al estilo de estilo_codigo.txt.

Uso: python3 -I reformat.py <original> <propuesta>
Lee <original> (nunca lo modifica) y escribe <propuesta>. Conserva los bytes,
la codificacion (UTF-8 o Latin-1) y los finales de linea (CRLF o LF).
Imprime avisos de lo que ha dejado sin tocar. No evita los acentos: solo
reescribe comentarios que ya existen.
"""
import re, sys
src, dst = sys.argv[1], sys.argv[2]
raw = open(src, 'rb').read()
try:
    ENC = 'utf-8'; t = raw.decode(ENC)
except UnicodeDecodeError:
    ENC = 'latin-1'; t = raw.decode(ENC)
NL = '\r\n' if '\r\n' in t else '\n'
if NL == '\r\n':
    assert t.count('\r\n') == t.count('\n'), 'finales de linea mezclados'
else:
    assert '\r' not in t, 'finales de linea mezclados'
lines = t.split(NL)
W = 80
rep = []
nfunc = []

def vw(s): return len(s.expandtabs(4))

def scan(line, in_blk):
    i = 0; n = len(line); q = None
    while i < n:
        c = line[i]
        if in_blk:
            if line.startswith('*/', i): in_blk = False; i += 2; continue
            i += 1; continue
        if q:
            if c == '\\': i += 2; continue
            if c == q: q = None
            i += 1; continue
        if c in '"\'': q = c; i += 1; continue
        if line.startswith('/*', i): in_blk = True; i += 2; continue
        if line.startswith('//', i): return i, in_blk
        i += 1
    return -1, in_blk

def clean_banner(l):
    s = l.expandtabs(4)[2:]
    if s.startswith('  '): s = s[2:]
    elif s.startswith(' '): s = s[1:]
    return s.rstrip()

def block(indent, body, ln):
    out = [indent + '/*']
    for b in body:
        out.append(indent + ('*  ' + b if b else '*'))
        if vw(out[-1]) > W: rep.append('linea >80 en bloque (orig. linea %d): %s' % (ln + 1, b[:40]))
    out.append(indent + '*/')
    return out


DASH = '*  ' + '-' * 70
NOTF = re.compile(r'(class|struct|enum|typedef|namespace|union)\b')

def isfunc(idx):
    """El primer codigo tras idx (saltando blancos, #, comentarios) es una funcion"""
    n = len(lines)
    while idx < n and (not lines[idx].strip() or lines[idx].startswith('#')
                       or lines[idx].lstrip().startswith(('//', '/*'))):
        idx += 1
    hdr = []
    for q in range(idx, min(idx + 4, n)):
        l = lines[q]
        if l.rstrip() == '{':
            h = ' '.join(hdr)
            return bool(hdr) and '(' in h and not NOTF.match(hdr[0]) and ';' not in h and '=' not in h
        hdr.append(l)
    return False

def func_comment(indent, body, ln):
    body = [x for x in body if not re.fullmatch(r'-{20,}', x)]
    while body and not body[-1]: body.pop()
    title = body[0]; rest = body[1:]
    out = []
    if vw(indent + '/* ' + title) <= W:
        out.append(indent + '/* ' + title)
    else:
        rep.append('titulo >80 en comentario de funcion (linea %d)' % (ln + 1))
        out.append(indent + '/*'); rest = [title] + rest
    for b in rest:
        out.append(indent + ('*  ' + b if b else '*'))
        if vw(out[-1]) > W: rep.append('linea >80 en bloque (orig. linea %d): %s' % (ln + 1, b[:40]))
    out.append(indent + '*  ' + '-' * 68 + '*/')
    return out

slash = re.compile(r'/{10,}\s*')
out = []; k = 0; in_blk = False
while k < len(lines):
    L = lines[k]
    if not in_blk and slash.fullmatch(L):
        j = k + 1; body = []
        while j < len(lines) and lines[j].startswith('//'):
            if slash.fullmatch(lines[j]): j += 1; break
            body.append(clean_banner(lines[j])); j += 1
        while body and not body[0]: body.pop(0)
        while body and not body[-1]: body.pop()
        assert not any('*/' in b for b in body), k
        if k == 0:
            out.append('/' + '*' * 72)
            for b in body:
                if re.fullmatch(r'-{5,}', b): out.append('* ' + '-' * 71)
                else: out.append('* ' + b if b else '*')
            out.append('*' * 72 + '/')
        elif isfunc(j):
            out.extend(func_comment('', body, k)); nfunc.append(k)
        elif len(body) == 1 and vw('/* ' + body[0] + ' */') <= W:
            out.append('/* ' + body[0] + ' */')
        else:
            out.extend(block('', body, k))
        k = j; continue
    if not in_blk and L.startswith('/*') and not L.startswith('/**') and k > 0:
        e = k
        while e < len(lines) and '*/' not in lines[e]: e += 1
        if e < len(lines) and lines[e].rstrip().endswith('*/') and '*/' not in L[2:] or (e == k and L.rstrip().endswith('*/')):
            last = lines[e].rstrip()
            texts = []
            if e == k:
                texts = [L.rstrip()[2:-2].strip()]
            else:
                first = L[2:].strip()
                texts = [first] if first else []
                for g in range(k + 1, e):
                    m2 = lines[g].rstrip()
                    m2 = m2[1:] if m2.startswith('*') else m2
                    m2 = m2[2:] if m2.startswith('  ') else m2.strip() if not m2.startswith(' ') else m2[1:]
                    texts.append(m2.rstrip())
                lt = last[:-2]; lt = lt[1:] if lt.startswith('*') else lt; lt = lt.strip()
                if lt: texts.append(lt)
            while texts and not texts[-1]: texts.pop()
            if texts and not texts[0].startswith('#') and any(not re.fullmatch(r'-{20,}', x) for x in texts) and isfunc(e + 1):
                out.extend(func_comment('', texts, k)); nfunc.append(k)
                k = e + 1; continue
    pos, nb = scan(L, in_blk)
    if pos < 0:
        out.append(L); in_blk = nb; k += 1; continue
    code = L[:pos]
    if code.strip():                       # comentario al final de linea
        raw = L[pos + 2:].strip()
        if '*/' in raw:
            rep.append('sin tocar ("*/" dentro), linea %d' % (k + 1)); out.append(L)
        else:
            new = code + '/* ' + raw + ' */'
            if vw(new) <= W or vw(L) > W: out.append(new)
            else:
                rep.append('final de linea sin convertir (pasaria de 80), linea %d' % (k + 1)); out.append(L)
        k += 1; continue
    indent = code                          # comentario de linea completa
    grp = [k]; m = k + 1
    while m < len(lines):
        p2, _ = scan(lines[m], False)
        if p2 >= 0 and lines[m][:p2] == indent and not slash.fullmatch(lines[m]): grp.append(m); m += 1
        else: break
    raws = [lines[g][len(indent) + 2:].rstrip() for g in grp]
    if any('*/' in r for r in raws) or any(not r.strip() for r in raws):
        rep.append('sin tocar (vacio o "*/"), lineas %d-%d' % (grp[0] + 1, grp[-1] + 1))
        out.extend(lines[g] for g in grp)
    elif indent == '' and isfunc(m) and lines[m].strip():
        body = [r[1:] if r[:1] in ' \t' else r for r in raws]
        out.extend(func_comment(indent, body, grp[0])); nfunc.append(grp[0])
    elif len(grp) == 1 and vw(indent + '/*' + raws[0] + ' */') <= W:
        out.append(indent + '/*' + raws[0] + ' */')
    else:
        body = [r[1:] if r[:1] in ' \t' else r for r in raws]
        out.extend(block(indent, body, grp[0]))
    k = m
open(dst, 'wb').write(NL.join(out).encode(ENC))
print('comentarios de funcion:', len(nfunc))
print('\n'.join(rep) or 'sin avisos')
