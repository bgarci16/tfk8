{{- define "threadfix.appsec.db.url" -}}
{{- $db_url := printf "jdbc:mariadb://%s:%s/%s?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&jdbcCompliantTruncation=false&useSSL=false" (include "threadfix.db.hostname" .) (include "threadfix.db.servicePort" .) .Values.db.database -}}
{{- if eq (include "threadfix.db.type" . ) "sqlserver"  -}}
    {{- $db_url = printf "jdbc:sqlserver://%s:%s;databaseName=%s;integratedSecurity=false;sendStringParametersAsUnicode=false;serverPreparedStatementDiscardThreshold=100;enablePrepareOnFirstPreparedStatementCall=true;disableStatementPooling=false;statementPoolingCacheSize=100;" (include "threadfix.db.hostname" .) (include "threadfix.db.servicePort" .) .Values.db.database -}}
{{- end -}}
{{ default $db_url .Values.db.urlOverride }}
{{- end -}}

{{- define "threadfix.appsec.dbInit.image" -}}
{{- $registryName := default .Values.dbInit.image.registry .Values.global.imageRegistry  -}}
{{- $repositoryName := .Values.dbInit.image.repository  -}}
{{- $tag := .Values.dbInit.image.tag | toString -}}
{{- $image := printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{ print (coalesce .Values.global.dbtoolsImageOverride .Values.dbInit.imageOverride $image) }}
{{- end -}}

