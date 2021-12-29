{{- define "threadfix.zk.name" -}}
{{- $chart := "zk" -}}
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

{{- define "threadfix.zk.fullname" -}}
{{- $chart := "zk" -}}
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

{{- define "threadfix.zk.clientPort" -}}
{{- $chart := "zk" -}}
{{- if eq $chart .Chart.Name -}}
{{- .Values.client.port -}}
{{- else -}}
{{- if (index .Values "global" "threadfix" $chart) -}}
{{- default (index .Values $chart "clientPort" ) ( index .Values "global" "threadfix" $chart "clientPort" ) -}}
{{- else -}}
{{- index .Values $chart "clientPort" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "threadfix.zk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "threadfix.zk.name" . }}
{{ include "threadfix.selectorLabels" . }}
{{- end -}}