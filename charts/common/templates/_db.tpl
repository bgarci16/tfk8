{{- define "threadfix.db.name" -}}
{{- $chart := "db" -}}
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

{{- define "threadfix.db.fullname" -}}
{{- $chart := "db" -}}
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

{{- define "threadfix.db.hostname" -}}
{{- $hostname := ( include "threadfix.db.fullname" . ) -}}
{{- if .Values.db -}}
{{- $hostname = default $hostname .Values.db.hostnameOverride -}}
{{- end -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- $hostname = default $hostname .Values.global.threadfix.db.hostnameOverride -}}
{{- end -}}
{{- end -}}
{{ printf "%s" $hostname }}
{{- end -}}

{{- define "threadfix.db.servicePort" -}}
{{- if eq .Chart.Name "db" -}}
    {{- .Values.service.port -}}
{{- else -}}
    {{- $port := 3306 -}}
    {{- if eq (include "threadfix.db.type" . ) "sqlserver"  -}}
    {{- $port = 1433 -}}
    {{- end -}}
    {{- if .Values.db -}}
        {{- $port = default $port .Values.db.portOverride -}}
    {{- end -}}
    {{- if .Values.global.threadfix -}}
        {{- if .Values.global.threadfix.db -}}
            {{- $port = default $port .Values.global.threadfix.db.portOverride -}}
        {{- end -}}
    {{- end -}}
    {{ $port | int }}
{{- end -}}
{{- end -}}


{{- define "threadfix.db.type" -}}
{{ $type := .Values.db.type }}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{ $type = default $type .Values.global.threadfix.db.type }}
{{- end -}}
{{- end -}}
{{- printf "%s" $type -}}
{{- end -}}


{{- define "threadfix.db.driver" -}}
{{- if eq "sqlserver" (include "threadfix.db.type" . ) -}}
    {{- printf "%s" "com.microsoft.sqlserver.jdbc.SQLServerDriver" -}}
{{- else -}}
    {{- printf "%s" "org.mariadb.jdbc.Driver" -}}
{{- end -}}
{{- end -}}


{{- define "threadfix.db.hibernateDialect" -}}
{{- $hibernateDialect := "org.hibernate.dialect.MySQL55Dialect" -}}
{{- if eq (include "threadfix.db.type" . ) "sqlserver"  -}}
    {{- printf "org.hibernate.dialect.SqlServer2012Dialect" -}}
{{- else -}}
    {{- printf "org.hibernate.dialect.MySQL55Dialect" -}}
{{- end -}}
{{- end -}}

{{- define "threadfix.db.globallyQuoted" -}}
{{- $globallyQuoted := .Values.db.globallyQuoted -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- $globallyQuoted = default $globallyQuoted .Values.global.threadfix.db.globallyQuoted -}}
{{- end -}}
{{- end -}}
{{ $globallyQuoted -}}
{{- end -}}

{{- define "threadfix.db.pool.cacheSize" -}}
{{- $cacheSize := .Values.db.pool.cacheSize -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- if .Values.global.threadfix.db.pool -}}
{{- $cacheSize = default $cacheSize .Values.global.threadfix.db.pool.cacheSize -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{ $cacheSize -}}
{{- end -}}

{{- define "threadfix.db.pool.minPool" -}}
{{- $minPool := .Values.db.pool.minPool -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- if .Values.global.threadfix.db.pool -}}
{{- $minPool = default $minPool .Values.global.threadfix.db.pool.minPool -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{ $minPool -}}
{{- end -}}

{{- define "threadfix.db.pool.maxPool" -}}
{{- $maxPool := .Values.db.pool.maxPool -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- if .Values.global.threadfix.db.pool -}}
{{- $maxPool = default $maxPool .Values.global.threadfix.db.pool.maxPool -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{ $maxPool -}}
{{- end -}}

{{- define "threadfix.db.pool.idleConnectionLimit" -}}
{{- $idleConnectionLimit := .Values.db.pool.idleConnectionLimit -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- if .Values.global.threadfix.db.pool -}}
{{- $idleConnectionLimit = default $idleConnectionLimit .Values.global.threadfix.db.pool.idleConnectionLimit -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{ $idleConnectionLimit -}}
{{- end -}}

{{- define "threadfix.db.secret" -}}
{{- $dbSecrets := printf "%s-db" .Release.Name -}}
{{- if eq .Chart.Name "db" -}}
{{- $dbSecrets = default $dbSecrets .Values.existingSecret -}}
{{- else -}}
{{- $dbSecrets = default $dbSecrets .Values.db.existingSecret -}}
{{- end -}}
{{- if .Values.global.threadfix -}}
{{- if .Values.global.threadfix.db -}}
{{- $dbSecrets = default $dbSecrets .Values.global.threadfix.db.existingSecret -}}
{{- end -}}
{{- end -}}
{{ printf "%s" $dbSecrets }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "threadfix.db.selectorLabels" -}}
app.kubernetes.io/component: database
app.kubernetes.io/name: {{ include "threadfix.db.name" . }}
{{ include "threadfix.selectorLabels" . }}
{{- end -}}