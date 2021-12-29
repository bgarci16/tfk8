{{- define "threadfix.zk.servers" -}}
{{- $namespace := .Release.Namespace }}
{{- $name := include "threadfix.zk.fullname" . -}}
{{- $leaderElectionPort := .Values.leaderElectionPort -}}
{{- $zk := dict "servers" (list) -}}
{{- range $idx, $v := until (int .Values.replicaCount) }}
{{- $noop := printf "%s-%d.%s-hs.%s.svc.cluster.local:2888:3888" $name $idx $name $namespace | append $zk.servers | set $zk "servers" -}}
{{- end }}
{{- printf "%s" (join ";" $zk.servers) | quote -}}
{{- end -}}