{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "threadfix.self.name" -}}
{{- $name := .Chart.Name -}}
{{- if .Values.global -}}
  {{- if (index .Values "global" $name) -}}
    {{- $name = default $name (index .Values "global" .Chart.Name "nameOverride" ) -}}
  {{- end -}}
{{- end -}}
{{ default $name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "threadfix.self.fullname" -}}
{{- $name := include "threadfix.self.name" . -}}
{{- if .Values.global -}}
{{- if (index .Values "global" .Chart.Name ) -}}
{{- $name = default $name (index .Values "global" .Chart.Name "fullnameOverride") -}}
{{- end -}}
{{- end -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "threadfix.self.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "threadfix.self.labels" -}}
{{- $selectorLabelsTemplate := printf "threadfix.%s.selectorLabels" .Chart.Name -}}
helm.sh/chart: {{ include "threadfix.self.chart" . }}
{{ include $selectorLabelsTemplate . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "threadfix.self.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "threadfix.self.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{- define "threadfix.self.servicePort" -}}
{{- $port := .Values.service.port -}}
{{- if .Values.global -}}
  {{- if (index .Values "global" .Chart.Name ) -}}
    {{- $port = default $port (index .Values "global" .Chart.Name "servicePort" ) -}}
  {{- end -}}
{{- end -}}
{{- $port = $port | int -}}
{{ printf "%d" $port }}
{{- end -}}

{{- define "threadfix.self.progressDeadlineSeconds" -}}
{{- $progressDeadlineSeconds := .Values.progressDeadlineSeconds -}}
{{- if .Values.global -}}
{{- if .Values.global.threadfix -}}
{{- $progressDeadlineSeconds = default $progressDeadlineSeconds .Values.global.threadfix.progressDeadlineSeconds -}}
{{- end -}}
{{- $progressDeadlineSeconds = default $progressDeadlineSeconds .Values.global.progressDeadlineSeconds -}}
{{- end -}}
{{- if $progressDeadlineSeconds -}}
progressDeadlineSeconds: {{ $progressDeadlineSeconds }}
{{- end -}}
{{- end -}}

{{- define "threadfix.self.env" -}}
{{- range $key, $val := .Values.env }}
- name: {{ $key }}
{{- $valueType := printf "%T" $val -}}
{{ if eq $valueType "map[string]interface {}" }}
{{ toYaml $val | indent 2 -}}
{{- else }}
  value: {{ $val | quote -}}
{{- end -}}
{{- end -}}
{{- end -}}