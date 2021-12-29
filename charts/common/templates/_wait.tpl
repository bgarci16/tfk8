
{{- define "threadfix.wait.enabled" -}}
{{- if hasKey .Values.global "waitEnabled" -}}
{{- toString .Values.global.waitEnabled -}}
{{- else -}}
{{- toString .Values.wait.enabled -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.waitForKafka" -}}
- name: wait-for-kafka
  securityContext:
    {{- toYaml .Values.wait.securityContext | nindent 4 }}
  image: {{ include "threadfix.wait.image" . }}
  imagePullPolicy: {{ include "threadfix.wait.image.pullPolicy" . }}
  command: ['sh', '-c', 'until nc {{ template "threadfix.kafka.fullname" . }}-0.{{ template "threadfix.kafka.fullname" . }} {{ include "threadfix.kafka.externalPort" . }} -w1; do echo waiting for kafka; sleep 2; done;']
{{- end -}}


{{- define "threadfix.waitForAuth" -}}
- name: wait-for-auth
  securityContext:
    {{- toYaml .Values.wait.securityContext | nindent 4 }}
  image: {{ include "threadfix.wait.image" . }}
  imagePullPolicy: {{ include "threadfix.wait.image.pullPolicy" . }}
  command: ['sh', '-c', 'until nc {{ include "threadfix.auth.fullname" . }} {{ include "threadfix.auth.servicePort" . }} -w1 ; do echo waiting for auth; sleep 2; done;']
{{- end -}}

{{- define "threadfix.waitForAppsec" -}}
- name: wait-for-appsec
  securityContext:
    {{- toYaml .Values.wait.securityContext | nindent 4 }}
  image: {{ include "threadfix.wait.image" . }}
  imagePullPolicy: {{ include "threadfix.wait.image.pullPolicy" . }}
  command: ['sh', '-c', 'until nc {{ include "threadfix.appsec.fullname" . }} {{ include "threadfix.appsec.servicePort" . }} -w1 ; do echo waiting for appsec; sleep 2; done;']
{{- end -}}

{{- define "threadfix.waitForDB" -}}
- name: wait-for-db
  image: {{ include "threadfix.wait.image" . }}
  imagePullPolicy: {{ include "threadfix.wait.image.pullPolicy" . }}
  securityContext:
    {{- toYaml .Values.wait.securityContext | nindent 4 }}
  command: ['sh', '-c', 'until nc {{ include "threadfix.db.hostname" . }} {{ include "threadfix.db.servicePort" . }} -w1 ; do echo waiting for db; sleep 2; done;']
{{- end -}}

{{- define "threadfix.waitForProvider" -}}
- name: wait-for-provider
  securityContext:
    {{- toYaml .Values.wait.securityContext | nindent 4 }}
  image: {{ include "threadfix.wait.image" . }}
  imagePullPolicy: {{ include "threadfix.wait.image.pullPolicy" . }}
  command: ['sh', '-c', 'until nc {{ include "threadfix.provider.fullname" . }} {{ include "threadfix.provider.servicePort" . }} -w1 ; do echo waiting for provider; sleep 2; done;']
{{- end -}}

{{- define "threadfix.waitForCrud" -}}
- name: wait-for-crud
  securityContext:
    {{- toYaml .Values.wait.securityContext | nindent 4 }}
  image: {{ include "threadfix.wait.image" . }}
  imagePullPolicy: {{ include "threadfix.wait.image.pullPolicy" . }}
  command: ['sh', '-c', 'until nc {{ include "threadfix.crud.fullname" . }} {{ include "threadfix.crud.servicePort" . }} -w1 ; do echo waiting for crud; sleep 2; done;']
{{- end -}}