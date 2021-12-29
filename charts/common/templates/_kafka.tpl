{{- define "threadfix.kafka.name" -}}
{{- $chart := "kafka" -}}
{{- if eq $chart .Chart.Name -}}
{{- include "threadfix.self.name" . -}}
{{- else -}}
{{- $name := default $chart (index .Values $chart "nameOverride") -}}
{{- if (index .Values "global" "threadfix" $chart ) -}}
{{- $name = default $name (index .Values "global" "threadfix" $chart "nameOverride") -}}
{{- end -}}
{{ printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.kafka.fullname" -}}
{{- $chart := "kafka" -}}
{{- if eq $chart .Chart.Name -}}
{{- include "threadfix.self.fullname" . -}}
{{- else -}}
{{- $nameTemplate := printf "threadfix.%s.name" $chart -}}
{{- $name := printf "%s-%s" .Release.Name ( include $nameTemplate . ) -}}
{{- $name = default $name (index .Values $chart "fullnameOverride") -}}
{{- if (index .Values "global" "threadfix" $chart ) -}}
{{- $name = default $name ( index .Values "global" "threadfix" $chart "fullnameOverride" ) -}}
{{- end -}}
{{ printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.kafka.externalPort" -}}
{{- $chart := "kafka" -}}
{{- if eq $chart .Chart.Name -}}
{{- .Values.externalPort -}}
{{- else -}}
{{- if (index .Values "global" "threadfix" $chart) -}}
{{- default (index .Values $chart "externalPort" ) ( index .Values "global" "threadfix" $chart "externalPort" ) -}}
{{- else -}}
{{- index .Values $chart "externalPort" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.kafka.cm" -}}
{{- $cm := include "threadfix.kafka.fullname" . -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.kafkaCMOverride -}}
{{- $cm = .Values.global.threadfix.kafkaCMOverride -}}
{{- end -}}
{{- end -}}
{{- if .Values.global.kafkaCMOverride -}}
{{ $cm = .Values.global.kafkaCMOverride }}
{{- end -}}
{{ printf "%s" $cm }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "threadfix.kafka.selectorLabels" -}}
app.kubernetes.io/name: {{ include "threadfix.kafka.name" . }}
{{ include "threadfix.selectorLabels" . }}
{{- end -}}