{{- define "threadfix.crud.db.url" -}}
{{- $url := printf "jdbc:mariadb://%s:%s/%s?autoReconnect=true&useSSL=false" (include "threadfix.db.hostname" . ) (include "threadfix.db.servicePort" . ) .Values.db.database -}}
{{ default $url .Values.db.urlOverride }}
{{- end -}}