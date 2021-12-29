{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "provider.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "provider.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{- define "threadfix.provider.db.url" -}}
{{ default (printf "jdbc:mariadb://%s:%s/%s?autoReconnect=true&useSSL=false" (include "threadfix.db.hostname" . ) (include "threadfix.db.servicePort" . ) .Values.db.database ) .Values.db.urlOverride }}
{{- end -}}