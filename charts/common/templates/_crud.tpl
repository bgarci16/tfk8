{{- define "threadfix.crud.name" -}}
{{- $chart := "crud" -}}
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

{{- define "threadfix.crud.fullname" -}}
{{- $chart := "crud" -}}
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

{{- define "threadfix.crud.servicePort" -}}
{{- $chart := "crud" -}}
{{- if eq $chart .Chart.Name -}}
{{- include "threadfix.self.servicePort" . -}}
{{- else -}}
{{- if (index .Values "global" "threadfix" $chart) -}}
{{- default (index .Values $chart "servicePort" ) ( index .Values "global" "threadfix" $chart "servicePort" ) -}}
{{- else -}}
{{- index .Values $chart "servicePort" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "threadfix.crud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "threadfix.crud.name" . }}
{{ include "threadfix.selectorLabels" . }}
{{- end -}}