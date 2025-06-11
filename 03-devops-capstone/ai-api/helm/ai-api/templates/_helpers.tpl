{{- define "ai-api.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "ai-api.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}
