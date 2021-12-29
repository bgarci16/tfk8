{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "threadfix.queue.serviceAccountName" -}}

{{- if .Values.serviceAccount.create -}}
    {{ default (include "threadfix.queue.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{- define "threadfix.queue.db.url" -}}
{{- $db_url := printf "jdbc:mariadb://%s:%s/%s?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&jdbcCompliantTruncation=false&useSSL=false" (include "threadfix.db.hostname" .) (include "threadfix.db.servicePort" .) .Values.db.database -}}
{{- if eq (include "threadfix.db.type" . ) "sqlserver" -}}
    {{- $db_url = printf "jdbc:sqlserver://%s:%s;databaseName=%s;integratedSecurity=false;sendStringParametersAsUnicode=false" (include "threadfix.db.hostname" .) (include "threadfix.db.servicePort" .) .Values.db.database -}}
{{- end -}}
{{ default $db_url .Values.db.urlOverride }}
{{- end -}}