{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "appsecimporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "appsecimporter.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{- define "threadfix.appsecimporter.db.url" -}}
{{ $url := printf "jdbc:mariadb://%s:%s/%s?autoReconnect=true&useSSL=false" (include "threadfix.db.hostname" . ) (include "threadfix.db.servicePort" . ) .Values.db.database }}
{{ default $url .Values.db.urlOverride }}
{{- end -}}