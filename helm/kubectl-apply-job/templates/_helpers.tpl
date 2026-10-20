{{/* vim: set filetype=mustache: */}}


{{/* library chart values */}}

{{- define "applyJob.Values" -}}
{{- (.Values.kubectlApplyJob | toYaml) | default dict -}}
{{- end -}}

{{- define "applyJob.securityContext" -}}
{{- (get (include "applyJob.Values" . | fromYaml) "securityContext" | toYaml) | default dict }}
{{- end -}}

{{- define "applyJob.securityContext.runAsUser" -}}
{{ get (include "applyJob.securityContext" . | fromYaml) "runAsUser" | default 1000 }}
{{- end -}}

{{- define "applyJob.securityContext.runAsGroup" -}}
{{ get (include "applyJob.securityContext" . | fromYaml) "runAsGroup" | default 1000 }}
{{- end -}}

{{- define "applyJob.securityContext.seccompProfileType" -}}
{{ get (include "applyJob.securityContext" . | fromYaml) "seccompProfileType" | default "RuntimeDefault" }}
{{- end -}}

{{- define "applyJob.image" -}}
{{- (get (include "applyJob.Values" . | fromYaml) "image" | toYaml) | default dict }}
{{- end -}}

{{- define "applyJob.image.pullPolicy" -}}
{{ get (include "applyJob.image" . | fromYaml) "pullPolicy" | default "IfNotPresent" }}
{{- end -}}

{{/*
Fallback image, used when the consuming chart sets no image. Consumers include
the Job with their own context, so this chart's values.yaml defaults never apply
to them. Keep this in sync with kubectlApplyJob.image in values.yaml; Renovate
bumps both (see renovate.json5).
*/}}
{{- define "applyJob.containerImage" -}}
{{- $registry := "gsoci.azurecr.io" -}}
{{- /* renovate: datasource=docker depName=gsoci.azurecr.io/giantswarm/docker-kubectl */ -}}
{{- $defaultTag := "1.37.0" -}}
{{- if and .Values.image .Values.image.registry -}}
{{- $registry = .Values.image.registry -}}
{{- end -}}
{{- if (get (include "applyJob.image" . | fromYaml) "registry") -}}
{{- $registry = get (include "applyJob.image" . | fromYaml) "registry" -}}
{{- end -}}
{{- if and .Values.global -}}
{{- if and .Values.global.image .Values.global.image.registry -}}
{{- $registry = .Values.global.image.registry -}}
{{- end -}}
{{- end -}}
{{- $repository := get (include "applyJob.image" . | fromYaml) "repository" | default "giantswarm/docker-kubectl" -}}
{{- $tag := get (include "applyJob.image" . | fromYaml) "tag" | toString | default $defaultTag -}}
{{ printf "%s/%s:%s" $registry $repository $tag }}
{{- end -}}

{{- define "applyJob.backoffLimit" -}}
{{- get (include "applyJob.Values" . | fromYaml) "backoffLimit" | default 10 }}
{{- end -}}

{{- define "applyJob.resources" -}}
{{- if get (include "applyJob.Values" . | fromYaml) "resources" -}}
{{- get (include "applyJob.Values" . | fromYaml) "resources" -}}
{{- else -}}
requests:
  cpu: 100m
  memory: 256Mi
limits:
  cpu: 500m
  memory: 512Mi
{{- end -}}
{{- end -}}

{{- define "applyJob.jobNameSuffix" -}}
{{- get (include "applyJob.Values" . | fromYaml) "jobNameSuffix" | default "kubectl-apply-job" }}
{{- end -}}

{{/* Create a default fully qualified app name. Truncated to meet DNS naming spec. */}}
{{- define "applyJob.name" -}}
{{- printf "%s-%s" (.Chart.Name | trimSuffix "-" | trimSuffix ".") (include "applyJob.jobNameSuffix" .) | replace "+" "_" | trunc 63 | trimSuffix "-" | trimSuffix "." -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "applyJob.chart" -}}
{{- printf "%s-%s" (.Chart.Name | trimSuffix "-" | trimSuffix ".") (.Chart.Version | trimSuffix "-" | trimSuffix ".") | replace "+" "_" | trunc 63 | trimAll "-._" -}}
{{- end -}}

{{- define "applyJob.defaultLabels" -}}
app.kubernetes.io/name: "{{ template "applyJob.name" . }}"
app.kubernetes.io/instance: "{{ template "applyJob.name" . }}"
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
app.kubernetes.io/component: {{ get (include "applyJob.Values" . | fromYaml) "name" | default "kubectl-apply-job" | quote }}
helm.sh/chart: "{{ template "applyJob.chart" . }}"
application.giantswarm.io/team: {{ index .Chart.Annotations "io.giantswarm.application.team" | quote }}
giantswarm.io/service-type: "managed"
{{- end -}}

{{- define "applyJob.annotations" -}}
"helm.sh/hook": "pre-install,pre-upgrade"
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded,hook-failed"
{{- end -}}

{{- define "applyJob.selectorLabels" -}}
app.kubernetes.io/name: "{{ template "applyJob.name" . }}"
app.kubernetes.io/instance: "{{ template "applyJob.name" . }}"
{{- end -}}

{{- define "applyJob.enableCiliumNetworkPolicy" -}}
{{- if hasKey .Values "ciliumNetworkPolicy" -}}
{{- if hasKey .Values.ciliumNetworkPolicy "enabled" -}}
{{ .Values.ciliumNetworkPolicy.enabled }}
{{- end -}}
{{- end -}}
{{- end -}}
