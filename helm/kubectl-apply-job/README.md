# kubectl-apply-job

A Helm chart containing a Job to apply kubernetes manifests using kubectl apply.

**Homepage:** <https://github.com/giantswarm/kubectl-apply-job>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| kubectlApplyJob.enabled | bool | `true` | Render the Job. |
| kubectlApplyJob.jobNameSuffix | string | `""` | Suffix appended to the consuming chart's name to build the name of the Job and its ServiceAccount, ClusterRole and ClusterRoleBinding. Defaults to "kubectl-apply-job". |
| kubectlApplyJob.name | string | `""` | Value of the app.kubernetes.io/component label on every rendered resource. Defaults to "kubectl-apply-job". |
| kubectlApplyJob.files | list | `[]` | A list of paths to apply through the Job. |
| kubectlApplyJob.image.registry | string | `"gsoci.azurecr.io"` | Container image registry. |
| kubectlApplyJob.image.repository | string | `"giantswarm/docker-kubectl"` | Container image repository. |
| kubectlApplyJob.image.tag | string | `"1.37.2"` | Container image tag. |
| kubectlApplyJob.image.pullPolicy | string | `"IfNotPresent"` | Container image pull policy. |
| kubectlApplyJob.backoffLimit | int | `10` | Number of retries before the Job is marked as failed. Setting this higher means the creation Job is less likely to be marked as failed. |
| kubectlApplyJob.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resources of the Job container. |
| kubectlApplyJob.securityContext.runAsUser | int | `1000` | User ID the Job container runs as. |
| kubectlApplyJob.securityContext.runAsGroup | int | `1000` | Group ID the Job container runs as. |
| kubectlApplyJob.securityContext.seccompProfileType | string | `"RuntimeDefault"` | Seccomp profile type of the Job container. |
| image | object | `{}` | Image registry override. The library reads `image.registry` from the consuming chart's values. |
| ciliumNetworkPolicy.enabled | bool | `false` | Render a CiliumNetworkPolicy for the Job. |
