{{/*
Expand the name of the chart.
*/}}
{{- define "aigw.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aigw.fullname" -}}
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
{{- define "aigw.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aigw.labels" -}}
helm.sh/chart: {{ include "aigw.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aigw.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aigw.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the ServiceAccount to use
*/}}
{{- define "aigw.serviceAccountName" -}}
{{- default (include "aigw.fullname" .) .Values.serviceAccount.name }}
{{- end }}

{{/*
Create the name of the ConfigMap to use
*/}}
{{- define "aigw.configName" -}}
{{- if .Values.config.name }}
{{- .Values.config.name }}
{{- else }}
{{- printf "%s-config" (include "aigw.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create the name of the exporter cache volume to use
*/}}
{{- define "aigw.storageCacheName" -}}
{{- printf "%s-cache" (include "aigw.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Validate that storage is enabled if the exporter is enabled
*/}}
{{- define "aigw.validateExporterStorage" -}}
{{- if and .Values.aigw.exporter.enable (not .Values.aigw.storage.enable) }}
{{- fail "Must enable aigw.storage to use aigw.exporter" }}
{{- end }}
{{- end }}

{{/*
F5 Processor name
*/}}
{{- define "aigw-processors-f5.fullname" -}}
{{- printf "%s-processors-f5" (include "aigw.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
F5 Processor selector labels
*/}}
{{- define "aigw-processors-f5.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aigw-processors-f5.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
LLM Guard Processor name
*/}}
{{- define "aigw-processors-llm-guard.fullname" -}}
{{- printf "%s-processors-llm-guard" (include "aigw.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
LLM Guard Processor selector labels
*/}}
{{- define "aigw-processors-llm-guard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aigw-processors-llm-guard.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
XCDF Processor name
*/}}
{{- define "aigw-processors-xcdf.fullname" -}}
{{- printf "%s-processors-xcdf" (include "aigw.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
XCDF Processor selector labels
*/}}
{{- define "aigw-processors-xcdf.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aigw-processors-xcdf.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
