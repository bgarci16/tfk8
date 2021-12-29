{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "db.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "db.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "threadfix.db.username" -}}
{{- $username := "" -}}
{{- $secrets := (lookup "v1" "Secret" .Release.Namespace (printf "%s-db" .Release.Name)) -}}
{{- if $secrets -}}
{{ $username = index $secrets "data" "username" | b64dec }}
{{- end -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- $username =  .Values.global.threadfix.db.username -}}
{{- end -}}
{{- end -}}
{{- printf "%s" ( coalesce .Values.username $username "ThreadFix" ) -}}
{{- end -}}

{{- define "threadfix.db.password" -}}
{{- $password := "" -}}
{{- $secrets := (lookup "v1" "Secret" .Release.Namespace (printf "%s-db" .Release.Name)) -}}
{{- if $secrets -}}
{{- $password = index $secrets "data" "password" | b64dec -}}
{{- end -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- $password = .Values.global.threadfix.db.password -}}
{{- end -}}
{{- end -}}
{{- printf "%s" (coalesce .Values.password $password (randAlphaNum 32) ) -}}
{{- end -}}


