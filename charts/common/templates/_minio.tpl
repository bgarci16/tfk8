
{{- define "threadfix.minio.name" -}}
{{- default "minio" .Values.global.minio.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "threadfix.minio.fullname" -}}
{{- if .Values.global.minio.fullnameOverride -}}
{{- .Values.global.minio.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "minio" .Values.global.minio.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "threadfix.minio.secret" -}}
{{- coalesce .Values.minio.existingSecret .Values.global.minio.existingSecret ( include "threadfix.minio.fullname" . ) -}}
{{- end -}}