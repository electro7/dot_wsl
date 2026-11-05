#!/bin/bash
# Stop: si la tarea (desde el ultimo prompt) ha durado mas de AVISO_UMBRAL
# segundos (por defecto 120), lanza una notificacion de Windows desde WSL.
umbral=${AVISO_UMBRAL:-120}
d=~/.claude/hooks/estado
in=$(cat)
sid=$(jq -r '.session_id // empty' <<<"$in")
[ -n "$sid" ] && [ -f "$d/$sid" ] || exit 0
{ read -r t0; read -r prompt; } < "$d/$sid"
rm -f "$d/$sid"
dur=$(( $(date +%s) - t0 ))
[ "$dur" -ge "$umbral" ] || exit 0

cwd=$(jq -r '.cwd // ""' <<<"$in")
titulo="Claude Code · $(basename "$cwd") · $((dur/60)) min $((dur%60)) s"
esc() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g' <<<"$1"; }
xml="<toast><visual><binding template=\"ToastText02\"><text id=\"1\">$(esc "$titulo")</text><text id=\"2\">$(esc "$prompt")</text></binding></visual></toast>"
ps="[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
\$x = New-Object Windows.Data.Xml.Dom.XmlDocument
\$x.LoadXml('${xml//\'/\'\'}')
\$id = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\\WindowsPowerShell\\v1.0\\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\$id).Show([Windows.UI.Notifications.ToastNotification]::new(\$x))"
enc=$(printf '%s' "$ps" | iconv -f UTF-8 -t UTF-16LE | base64 -w0)
powershell.exe -NoProfile -NonInteractive -EncodedCommand "$enc" >/dev/null 2>&1 </dev/null &
exit 0
