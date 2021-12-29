{{- define "threadfix.name" -}}
{{- $chart := "threadfix" -}}
{{- if eq $chart .Chart.Name -}}
{{- include "threadfix.self.name" . -}}
{{- else -}}
{{- $name := $chart -}}
{{- if ( index .Values "threadfix" ) -}}
{{- $name = default $name (index .Values "threadfix" "nameOverride") -}}
{{- end -}}
{{- if (index .Values "global" "threadfix" ) -}}
{{- $name = default $name (index .Values "global" "threadfix" "nameOverride") -}}
{{- end -}}
{{ printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.fullname" -}}
{{- $chart := "threadfix" -}}
{{- if eq $chart .Chart.Name -}}
{{- include "threadfix.self.fullname" . -}}
{{- else -}}
{{- $name := printf "%s-%s" .Release.Name ( include "threadfix.name" . ) -}}
{{- if ( index .Values "threadfix" ) -}}
{{- $name = default $name (index .Values "threadfix" "fullnameOverride") -}}
{{- end -}}
{{- if (index .Values "global" "threadfix" ) -}}
{{- $name = default $name ( index .Values "global" "threadfix" "fullnameOverride" ) -}}
{{- end -}}
{{ printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.springProfilesActive" -}}
{{ coalesce .Values.global.threadfix.springProfilesActive .Values.springProfilesActive "prod" }}
{{- end -}}

{{- define "threadfix.ingress.class" -}}
{{- if .Values.global.threadfix -}}
{{- default .Values.ingressClass .Values.global.threadfix.ingressClass -}}
{{- else -}}
{{- .Values.ingressClass -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ include "threadfix.name" . }}
{{- end -}}