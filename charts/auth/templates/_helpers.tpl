{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "threadfix.auth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "threadfix.auth.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}