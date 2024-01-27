{{/*
Expand the name of the chart.
*/}}
{{- define "kompose.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kompose.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kompose.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kompose.labels" -}}
helm.sh/chart: {{ include "kompose.chart" . }}
{{ include "kompose.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kompose.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kompose.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kompose.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kompose.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "kompose.komposeLabel" -}}
{{- with (index .labels .key) -}}
{{ . }}
{{- end }}
{{- end }}

{{/*
Build a list of services which accounts for service grouping label
---
service1:
  lables:
    kompose.service.group: hello
service2:
  labels:
    kompose.service.group: hello
service3: {}
---
# deployment: [containers]
hello: service1;service2
service3: service3
*/}}
{{- define "kompose.podGroups" -}}
{{- $services := dict }}
{{- range $service, $config := .Values.services }}
  {{- $groupLabel := index (default (dict) $config.labels) "kompose.service.group" | default $service }}
  {{- $existing := index $services $groupLabel | default "" }}
  {{- $_ := set $services $groupLabel (cat $existing $service | trim | replace " " ";") }}
{{- end }}
{{- $services | toJson -}}
{{- end }}

{{/*
Convert a taint string into a list of tolerations suitable for a Kubernetes deployment
Usage:
  {{ include "kompose.taintToTolerations" "sku=gpu:NoSchedule" | toYaml | indent 2 }}
*/}}
{{- define "kompose.taintToTolerations" -}}
{{- $taint := (split ":" .) }}
{{- $key := (split "=" $taint._0)._0 }}
{{- $value := (split "=" $taint._0)._1 -}}
- key: "{{ $key }}"
  operator: "Equal"
  value: "{{ $value }}"
  effect: "{{ $taint._1 }}"
{{- end }}

{{- define "kompose.keyValue" -}}
{{- range $i, $dict := (split ";" .) }}
{{- toYaml (dict (split "=" $dict)._0 (split "=" $dict)._1) }}
{{- end }}
{{- end }}

{{- define "kompose.listToDict" -}}
{{- range $dict := . }}
{{- toYaml (dict (split "=" $dict)._0 (split "=" $dict)._1) }}
{{- end }}
{{- end }}
