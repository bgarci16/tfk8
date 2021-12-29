{{- define "threadfix.migration.image" -}}
{{- $registryName := coalesce .Values.global.imageRegistry .Values.global.threadfix.imageRegistry  .Values.migration.image.registry  -}}
{{- $repositoryName := .Values.migration.image.repository -}}
{{- $tag := include "threadfix.migration.image.tag" . -}}
{{- $image := printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- default $image .Values.migration.imageOverride -}}
{{- end -}}

{{- define "threadfix.wait.image" -}}
{{- $registryName := default .Values.wait.image.registry .Values.global.imageRegistry  -}}
{{- $repositoryName := .Values.wait.image.repository  -}}
{{- $tag := .Values.wait.image.tag | toString -}}
{{- $image := printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{ print (coalesce .Values.global.waitImageOverride .Values.wait.imageOverride $image) }}
{{- end -}}

{{- define "threadfix.image.tag" -}}
{{- coalesce .Values.global.threadfix.imageTag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{- define "threadfix.migration.image.tag" -}}
{{- coalesce .Values.global.threadfix.imageTag .Values.migration.image.tag .Chart.AppVersion -}}
{{- end -}}

{{- define "threadfix.image" -}}
{{- $registryName := coalesce .Values.global.imageRegistry .Values.global.threadfix.imageRegistry .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := include "threadfix.image.tag" . -}}
{{- $image := printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- default $image .Values.imageOverride -}}
{{- end -}}

{{- define "threadfix.imagePullSecrets" -}}
{{- $imagePullSecrets := default .Values.imagePullSecrets .Values.global.imagePullSecrets -}}
{{- if $imagePullSecrets }}
imagePullSecrets:
{{- range $imagePullSecrets }}
  - name: {{ . }}
{{- end}}
{{- end -}}
{{- end -}}

{{- define "threadfix.image.pullPolicy" -}}
{{- coalesce  .Values.global.imagePullPolicy .Values.global.threadfix.imagePullPolicy .Values.image.pullPolicy -}}
{{- end -}}

{{- define "threadfix.migration.image.pullPolicy" -}}
{{- coalesce .Values.global.imagePullPolicy .Values.global.threadfix.imagePullPolicy .Values.migration.image.pullPolicy -}}
{{- end -}}

{{- define "threadfix.wait.image.pullPolicy" -}}
{{- default .Values.wait.image.pullPolicy .Values.global.imagePullPolicy -}}
{{- end -}}

{{- define "thirdparty.image" -}}
{{- $image := printf "%s:%s" .Values.image.repository (toString .Values.image.tag) -}}
{{- if ( or .Values.image.registry .Values.global.imageRegistry ) }}
  {{- $image = printf "%s/%s:%s" ( default .Values.image.registry .Values.global.imageRegistry ) .Values.image.repository (toString .Values.image.tag) -}}
{{- end -}}
{{- default $image .Values.imageOverride -}}
{{- end -}}

{{- define "thirdparty.image.pullPolicy" -}}
{{- default .Values.image.pullPolicy .Values.global.imagePullPolicy -}}
{{- end -}}

{{- define "threadfix.livenessProbe" -}}
{{- if .Values.livenessProbe.enabled -}}
{{- $options := list "failureThreshold" "initialDelaySeconds" "periodSeconds" "successThreshold" "timeoutSeconds" -}}
{{- $lp := .Values.livenessProbe -}}
{{- if and (not (hasKey $lp "initialDelaySeconds" )) ( eq .Capabilities.KubeVersion.Major "1" ) ( lt .Capabilities.KubeVersion.Minor "18" ) }}
initialDelaySeconds: 300
{{- end -}}
{{- range $k, $v := $lp }}
{{- if has $k $options }}
{{ $k }}: {{ $v }}
{{- end }}
{{- end }}
  {{- end }}
{{- end -}}

{{- define "threadfix.readinessProbe" -}}
{{- if .Values.readinessProbe.enabled -}}
{{- $options := list "failureThreshold" "initialDelaySeconds" "periodSeconds" "successThreshold" "timeoutSeconds" -}}
{{- $rp := .Values.readinessProbe -}}
{{- range $k, $v := $rp }}
{{- if has $k $options }}
{{ $k }}: {{ $v }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "threadfix.startupProbe" -}}
{{- if .Values.startupProbe.enabled -}}
{{- $options := list "failureThreshold" "initialDelaySeconds" "periodSeconds" "successThreshold" "timeoutSeconds" -}}
{{- $sp := .Values.startupProbe -}}
{{- range $k, $v := $sp }}
{{- if has $k $options }}
{{ $k }}: {{ $v }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "threadfix.probes" -}}
{{- $args := .args -}}
{{- with .context -}}
{{- if .Values.livenessProbe.enabled }}
livenessProbe:
  httpGet:
    path: {{ index $args "livenessPath" }}
    port: {{ index $args "port" }}
  {{- include "threadfix.livenessProbe" . | indent 2}}
{{- else if .Values.customLivenessProbe }}
livenessProbe: {{- tpl (.Values.customLivenessProbe | toYaml) . | nindent 2 }}
{{- end }}
{{- if .Values.readinessProbe.enabled }}
readinessProbe:
  httpGet:
    path: {{ index $args "readinessPath" }}
    port: {{ index $args "port" }}
  {{- include "threadfix.readinessProbe" . | indent 2}}
{{- else if .Values.customReadinessProbe }}
readinessProbe: {{- tpl (.Values.customReadinessProbe | toYaml) . | nindent 2 }}
{{- end }}
{{- if .Values.startupProbe.enabled }}
startupProbe:
  httpGet:
    path: {{ index $args "livenessPath" }}
    port: {{ index $args "port" }}
  {{- include "threadfix.startupProbe" . | indent 2}}
{{- else if .Values.customStartupProbe }}
startupProbe: {{- tpl (.Values.customStartupProbe | toYaml) . | nindent 2 }}
{{- end }}
{{- end -}}
{{- end -}}