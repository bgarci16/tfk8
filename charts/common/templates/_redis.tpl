
{{- define "threadfix.redis.name" -}}
{{- default "redis" .Values.global.redis.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "threadfix.redis.fullname" -}}
{{- if .Values.global.redis.fullnameOverride -}}
{{- .Values.global.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "redis" .Values.global.redis.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.redis.port" -}}
{{- $port := 6379 -}}
{{- if .Values.global -}}
{{- if .Values.global.redis -}}
{{- $port = default $port .Values.global.redis.servicePort -}}
{{- end -}}
{{- end -}}
{{ $port -}}
{{- end -}}

{{- define "threadfix.redis.secret" -}}
{{- $secret := "" -}}
{{- if .Values.redis -}}
{{- if .Values.redis.auth -}}
{{- if .Values.redis.auth.existingSecret -}}
{{- $secret = .Values.redis.auth.existingSecret -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- default ( include "threadfix.redis.fullname" . ) $secret -}}
{{- end -}}

{{- define "threadfix.redis.password" -}}
{{- $password := "" -}}
{{- $secrets := (lookup "v1" "Secret" .Release.Namespace ( include "threadfix.redis.secret" . )) -}}
{{- if $secrets -}}
{{- $password = index $secrets "data" "redis-password" | b64dec -}}
{{- end -}}
{{- if .Values.redis -}}
{{- if .Values.redis.auth -}}
{{- if .Values.redis.auth.password -}}
{{- $password = .Values.redis.auth.password -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- if .Values.global.redis -}}
{{- if .Values.global.redis.password -}}
{{- $password = .Values.global.redis.password -}}
{{- end -}}
{{- end -}}
{{- printf "%s" (default (randAlphaNum 10) $password) -}}
{{- end -}}
