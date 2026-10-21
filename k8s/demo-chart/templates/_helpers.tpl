{{/* Every resource is named after the release (e.g. "demo") */}}
{{- define "demo.name" -}}
{{- .Release.Name -}}
{{- end -}}

{{- define "demo.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: portfolio
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}

{{/* Selects only the web pods: the migration Job and the smoke test use other components */}}
{{- define "demo.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: web
{{- end -}}

{{/* repository@digest (preferred) or repository:tag */}}
{{- define "demo.image" -}}
{{- if .Values.image.digest -}}
{{ .Values.image.repository }}@{{ .Values.image.digest }}
{{- else if .Values.image.tag -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- else -}}
{{- fail "Set image.digest (recommended) or image.tag" -}}
{{- end -}}
{{- end -}}

{{/* localhost is required: probes, HEALTHCHECK and smoke test send Host: localhost */}}
{{- define "demo.allowedHosts" -}}
{{- printf "localhost,%s" .Values.ingress.host -}}
{{- end -}}

{{/* Same variables as the ConfigMap, for the pre-install/pre-upgrade Job (the ConfigMap may still hold the previous revision) */}}
{{- define "demo.env" -}}
{{- range $key, $value := .Values.config }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
- name: DJANGO_ALLOWED_HOSTS
  value: {{ include "demo.allowedHosts" . | quote }}
{{- end -}}