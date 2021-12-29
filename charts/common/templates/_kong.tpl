{{- define "threadfix.kong.admin.name" -}}
{{- $name := printf "%s-%s" ( include "threadfix.kong.fullname" . ) "admin" -}}
{{- if .Values.kong -}}
{{- if .Values.kong.admin -}}
{{- $name = default $name .Values.kong.admin.nameOverride -}}
{{- end -}}
{{- end -}}
{{- if .Values.global -}}
{{- if .Values.global.kong -}}
{{- if .Values.global.kong.admin -}}
{{- $name = default $name .Values.global.kong.admin.nameOverride -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{ printf "%s" $name -}}
{{- end -}}

{{- define "threadfix.kong.admin.port" -}}
{{- default .Values.kong.admin.http.servicePort 8001 -}}
{{- end -}}

{{- define "threadfix.kong.name" -}}
{{ $name := "kong" }}
{{- if .Values.kong -}}
{{- if .Values.kong.nameOverride -}}
{{- $name = .Values.kong.nameOverride -}}
{{- end -}}
{{- end -}}
{{ printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "threadfix.kong.fullname" -}}
{{ $fullname := printf "%s-%s" .Release.Name ( include "threadfix.kong.name" . )}}
{{- if .Values.kong -}}
{{- if .Values.kong.fullnameOverride -}}
{{- $fullname = .Values.kong.fullnameOverride -}}
{{- end -}}
{{- end -}}
{{- printf "%s" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "threadfix.kong.cm" -}}
{{- default (include "threadfix.kong.fullname" . ) .Values.kongCMOveride -}}
{{- end -}}