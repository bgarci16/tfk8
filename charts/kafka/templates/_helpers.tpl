{{- define "threadfix.kafka.advertised.listeners" -}}
{{- $service :=printf "%s.%s:%s" (include "threadfix.kafka.fullname" . ) .Release.Namespace  (include "threadfix.kafka.externalPort" . ) -}}
{{- $kafka := dict "servers" (list) -}}
{{- $brokers := index .Values "replicaCount" -}}
{{- if .Values.global -}}
{{- if .Values.global.kafka -}}
{{- $brokers := default $brokers .Values.global.kafka.brokers -}}
{{- end -}}
{{- end -}}
{{- $name := (include "threadfix.kafka.fullname" . ) -}}
{{- range $idx, $v := until (int $brokers) -}}
{{- $noop := printf "%s-%d.%s" $name $idx $service | append $kafka.servers | set $kafka "servers" -}}
{{- end -}}
{{- printf "%s" (join "," $kafka.servers) | quote -}}
{{- end -}}

{{- define "threadfix.kafka.env" -}}
{{- $env := dict -}}
{{- if .Values.configurationOverrides -}}
{{- range $key, $value := .Values.configurationOverrides -}}
{{- $_ := set $env (printf "KAFKA_%s" ( upper $key | replace "." "_"  )) $value -}}
{{- end -}}
{{- end -}}
{{- if .Values.customEnv -}}
{{- range $key, $value := .Values.customEnv -}}
{{- $_ := set $env $key $value -}}
{{- end -}}
{{- end -}}
{{- if $env -}}
{{- range $key, $value := $env -}}
- name: {{ $key }}
  value: {{ $value | quote }}
{{ end -}}
{{- end -}}
{{- end -}}