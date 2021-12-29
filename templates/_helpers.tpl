{{/* vim: set filetype=mustache: */}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "threadfix.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default network.properties if none is defined
*/}}
{{- define "threadfix.network.properties" -}}
{{- $networkProps := "" -}}
{{- $networkPropsSecret := lookup "v1" "Secret" .Release.Namespace ( printf "%s-network-props" .Release.Name ) -}}
{{- if $networkPropsSecret -}}
{{- $networkProps = index $networkPropsSecret "data" "network.properties" | b64dec -}}
{{- else -}}
{{- $networkProps = printf "master-key=%s" ( randAscii 32 | b64enc ) -}}
{{- end -}}
{{ default $networkProps ( index .Values "network.properties" ) }}
{{- end -}}

{{- define "threadfix.license" -}}
{{ index .Values "threadfix.license" }}
{{- end -}}

{{- define "threadfix.license.cm" -}}
{{ coalesce .Values.global.threadfix.licenseCMOverride .Values.licenseCMOverride "tf-license" }}
{{- end -}}

{{- define "threadfix.config.secrets" -}}
{{ default ( printf "%s-config-secrets" .Release.Name ) .Values.global.threadfix.configSecretsOverride }}
{{- end -}}

{{- define "threadfix.esapi.properties" -}}
{{- $esapi_dict := dict -}}
{{- $current_esapi_cm := (lookup "v1" "Secret" .Release.Namespace ( printf "%s-config-secrets" .Release.Name )) -}}
{{- $current_esapi := "" -}}
{{- if $current_esapi_cm -}}
  {{- $current_esapi := (index $current_esapi_cm "data" "ESAPI.properties" | b64dec) -}}
  {{- $current_esapi_list := splitList "\n" $current_esapi -}}
  {{- range $current_esapi_list -}}
    {{ if regexMatch "^[A-Za-z0-9._%+-]+=.+" . -}}
      {{- $key_val := splitn "=" 2 . -}}
      {{- $_ := set $esapi_dict $key_val._0 $key_val._1 -}}
    {{- end -}}
  {{- end -}}  
{{- end -}}  
{{- $default_esapi := (.Files.Get "config/ESAPI.properties" ) -}}
{{- $default_esapi_list := splitList "\n" $default_esapi -}}
  {{- range $default_esapi_list -}}
  {{- if regexMatch "^[A-Za-z0-9._%+-]+=.*" . -}}
    {{- $key_val := splitn "=" 2 . -}}
    {{- $_ := set $esapi_dict $key_val._0 $key_val._1 -}}
  {{- end -}}
{{- end -}}
{{- if .Values.esapi.esapiProperties -}}
  {{- range $k, $v := .Values.esapi.esapiProperties -}}
    {{- $_ := set $esapi_dict $k $v -}}
  {{- end -}}
{{- end -}}
{{- if not (and (hasKey $esapi_dict "ESAPI.MasterKey") (hasKey $esapi_dict "ESAPI.MasterSalt")) -}}
  {{- $masterKey := randBytes 16 -}}
  {{- $masterSalt := randBytes 20 -}}
  {{- $_ := set $esapi_dict "ESAPI.MasterKey" $masterKey -}}
  {{- $_ := set $esapi_dict "ESAPI.MasterSalt" $masterSalt -}}
  {{- $_ := set $esapi_dict "Encryptor.MasterKey" $masterKey -}}
  {{- $_ := set $esapi_dict "Encryptor.MasterSalt" $masterSalt -}}
{{- end -}}
{{- range $k,$v := $esapi_dict -}}
{{ printf "%s=%s" $k $v }}
{{ end -}}
{{- end -}}

{{- define "threadfix.esapi.validation.properties" -}}
{{- $validation_dict := dict -}} 
{{- $default_validation := (.Files.Get "config/validation.properties" ) -}}
{{- $default_validation_list := splitList "\n" $default_validation -}}
  {{- range $default_validation_list -}}
  {{- if regexMatch "^[A-Za-z0-9._%+-]+=.*" . -}}
    {{- $key_val := splitn "=" 2 . -}}
    {{- $_ := set $validation_dict $key_val._0 $key_val._1 -}}
  {{- end -}}
{{- end -}}
{{- if .Values.esapi.validationProperties -}}
  {{- range $k, $v := .Values.esapi.validationProperties -}}
    {{- $_ := set $validation_dict $k $v -}}
  {{- end -}}
{{- end -}}
{{- range $k,$v := $validation_dict -}}
{{ printf "%s=%s" $k $v }}
{{ end -}}
{{- end -}}

{{- define "threadfix.onelogin.saml.properties" -}}
{{- $saml_dict := dict -}} 
{{- $default_saml := (.Files.Get "config/onelogin.saml.properties" ) -}}
{{- $default_saml_list := splitList "\n" $default_saml -}}
  {{- range $default_saml_list -}}
  {{- if regexMatch "^[A-Za-z0-9._%+-]+ =.*" . -}}
    {{- $key_val := splitn "=" 2 . -}}
    {{- $_ := set $saml_dict ( trim $key_val._0 ) ( trim $key_val._1 ) -}}
  {{- end -}}
{{- end -}}
{{- if .Values.saml.properties -}}
  {{- range $k, $v := .Values.saml.properties -}}
    {{- $_ := set $saml_dict $k $v -}}
  {{- end -}}
{{- end -}}
{{- range $k,$v := $saml_dict -}}
{{ printf "%s = %s" $k $v }}
{{ end -}}
{{- end -}}