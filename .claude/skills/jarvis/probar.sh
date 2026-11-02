#!/bin/bash
# Lanza jarvis.exe en una carpeta de prueba (bajo /mnt/c) y muestra su salida.
# Uso: probar.sh CARPETA [SEGUNDOS] ["ARGS"] [driver ...]
#   CARPETA   con jarvis.prg (y los .dev); NUNCA una obra real
#   SEGUNDOS  tiempo maximo antes de matar el proceso (por defecto 15)
#   ARGS      opciones de jarvis (por defecto "-q -u": sin log ni .pst)
#   driver    drivers a copiar junto al exe (autolink, modbus, ...)
# Jarvis se queda en su bucle: siempre se mata por PID al terminar el tiempo.
d=$1; s=${2:-15}; a=${3:--q -u}; shift 3 2>/dev/null
inst="/mnt/c/Program Files (x86)/Jarvis"
case "$d" in /mnt/c/*) ;; *) echo "la carpeta debe estar bajo /mnt/c"; exit 1;; esac
[ -f "$d/jarvis.prg" ] || [ "$a" != "${a#-v}" ] || echo "aviso: no hay $d/jarvis.prg"
chmod u+w "$d/jarvis.exe" 2>/dev/null
cp -f "$inst/jarvis.exe" "$d/" || exit 1
for x in "$@"; do chmod u+w "$d/$x.exe" 2>/dev/null; cp -f "$inst/$x.exe" "$d/"; done
: > "$d/vacio.txt"
cat > "$d/prueba.ps1" <<'EOF'
$d = $env:JARVIS_DIR
Remove-Item "$d\out.txt","$d\err.txt" -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$d\jarvis.exe" -ArgumentList $env:JARVIS_ARGS -WorkingDirectory $d `
     -RedirectStandardInput "$d\vacio.txt" -RedirectStandardOutput "$d\out.txt" `
     -RedirectStandardError "$d\err.txt" -PassThru -WindowStyle Hidden
if ($p.WaitForExit([int]$env:JARVIS_SECS * 1000)) { "TERMINO solo" } else { Stop-Process -Id $p.Id -Force; "MATADO tras $env:JARVIS_SECS s" }
Get-Process | Where-Object { $_.Name -ne 'jarvis_w32' -and $_.Path -like "$d\*" } | Stop-Process -Force
EOF
export JARVIS_DIR="$(wslpath -w "$d")" JARVIS_ARGS="$a" JARVIS_SECS="$s" WSLENV=JARVIS_DIR:JARVIS_ARGS:JARVIS_SECS
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$d/prueba.ps1")" 2>&1 | tr -d '\r'
echo "--- salida:"; iconv -f cp850 -t utf8 "$d/out.txt"
if [ -s "$d/err.txt" ]; then echo "--- errores:"; iconv -f cp850 -t utf8 "$d/err.txt"; fi
