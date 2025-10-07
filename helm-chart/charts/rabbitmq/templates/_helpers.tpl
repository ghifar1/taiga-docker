{{- define "rabbitmq.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rabbitmq.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "rabbitmq.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "rabbitmq.labels" -}}
app.kubernetes.io/name: {{ include "rabbitmq.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "rabbitmq.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rabbitmq.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "rabbitmq.secretName" -}}
{{- printf "%s-auth" (include "rabbitmq.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rabbitmq.image" -}}
{{- if .Values.image.registry -}}
{{- printf "%s/%s:%s" .Values.image.registry .Values.image.repository .Values.image.tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end -}}
{{- end -}}

{{- define "rabbitmq.auth.username" -}}
{{- if .Values.auth.username -}}
{{- .Values.auth.username -}}
{{- else -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (include "rabbitmq.secretName" .) -}}
{{- if $secret -}}
{{- index $secret.data "username" | b64dec -}}
{{- else -}}
{{- randAlphaNum 12 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "rabbitmq.auth.password" -}}
{{- if .Values.auth.password -}}
{{- .Values.auth.password -}}
{{- else -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (include "rabbitmq.secretName" .) -}}
{{- if $secret -}}
{{- index $secret.data "password" | b64dec -}}
{{- else -}}
{{- randAlphaNum 24 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "rabbitmq.auth.erlangCookie" -}}
{{- if .Values.auth.erlangCookie -}}
{{- .Values.auth.erlangCookie -}}
{{- else -}}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (include "rabbitmq.secretName" .) -}}
{{- if $secret -}}
{{- index $secret.data "erlang-cookie" | b64dec -}}
{{- else -}}
{{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}
{{- end -}}
