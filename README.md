# AI Gateway Helm Chart

- [AI Gateway Helm Chart](#ai-gateway-helm-chart)
  - [Introduction](#introduction)
  - [Prerequisites](#prerequisites)
  - [Requirements](#requirements)
  - [Installing the Chart](#installing-the-chart)
    - [Installing the Chart from the OCI Registry](#installing-the-chart-from-the-oci-registry)
    - [Installing the Chart via Sources](#installing-the-chart-via-sources)
      - [Pulling the Chart](#pulling-the-chart)
      - [Installing the Chart](#installing-the-chart-1)
    - [Custom installation options](#custom-installation-options)
      - [Service type](#service-type)
  - [Upgrading the Chart](#upgrading-the-chart)
    - [Upgrading the Chart from the OCI Registry](#upgrading-the-chart-from-the-oci-registry)
    - [Upgrading the Chart from the Sources](#upgrading-the-chart-from-the-sources)
  - [Uninstalling the Chart](#uninstalling-the-chart)
  - [Configuration](#configuration)

## Introduction

This chart deploys the AI Gateway in your Kubernetes cluster.

## Prerequisites

- [Helm 3.0+](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Requirements

Kubernetes: `>= 1.25.0-0`

## Installing the Chart

### Installing the Chart from the OCI Registry

To install the latest stable release of AI Gateway in the `ai-gateway` namespace, run the following command:

```shell
helm install aigw oci://private-registry.nginx.com/aigw/aigw --create-namespace -n ai-gateway
```

`aigw` is the name of the release, and can be changed to any name you want. This name is added as a prefix to the Deployment name.

If the namespace already exists, you can omit the optional `--create-namespace` flag. If you want the latest version from the `main` branch, add `--version 0.0.0-edge` to your install command.

To wait for the Deployment to be ready, you can either add the `--wait` flag to the `helm install` command, or run
the following after installing:

```shell
kubectl wait --timeout=5m -n ai-gateway deployment/aigw --for=condition=Available
```

### Installing the Chart via Sources

#### Pulling the Chart

```shell
helm pull oci://private-registry.nginx.com/aigw/aigw --untar
cd aigw
```

This will pull the latest stable release. To pull the latest version from the `main` branch, specify the
`--version 0.0.0-edge` flag when pulling.

#### Installing the Chart

To install the chart into the `ai-gateway` namespace, run the following command.

```shell
helm install aigw . --create-namespace -n ai-gateway
```

`aigw` is the name of the release, and can be changed to any name you want. This name is added as a prefix to the Deployment name.

If the namespace already exists, you can omit the optional `--create-namespace` flag.

To wait for the Deployment to be ready, you can either add the `--wait` flag to the `helm install` command, or run
the following after installing:

```shell
kubectl wait --timeout=5m -n ai-gateway deployment/aigw --for=condition=Available
```

### Custom installation options

#### Service type

By default, the AI Gateway helm chart deploys a ClusterIP Service.

To use a NodePort Service instead:

```shell
helm install aigw oci://private-registry.nginx.com/aigw/aigw --create-namespace -n ai-gateway --set service.type=NodePort
```

To disable the creation of a Service:

```shell
helm install aigw oci://private-registry.nginx.com/aigw/aigw --create-namespace -n ai-gateway --set service.create=false
```

## Upgrading the Chart

### Upgrading the Chart from the OCI Registry

To upgrade the release `aigw`, run:

```shell
helm upgrade aigw oci://private-registry.nginx.com/aigw/aigw -n ai-gateway
```

This will upgrade to the latest stable release. To upgrade to the latest version from the `main` branch, specify
the `--version 0.0.0-edge` flag when upgrading.

### Upgrading the Chart from the Sources

Pull the chart sources as described in [Pulling the Chart](#pulling-the-chart), if not already present. Then, to upgrade
the release `aigw`, run:

```shell
helm upgrade aigw . -n ai-gateway
```

## Uninstalling the Chart

To uninstall/delete the release `aigw`:

```shell
helm uninstall aigw -n ai-gateway
kubectl delete ns ai-gateway
```

These commands remove all the Kubernetes components associated with the release and deletes the release.

## Configuration

The following table lists the configurable parameters of the AI Gateway chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aigw.affinity | object | `{}` | Affinity rules for the aigw pods |
| aigw.annotations | object | `{}` | Annotations for the aigw pods |
| aigw.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Security context for the aigw pods |
| aigw.enable | bool | `true` | Enable the core (aigw) application |
| aigw.env | list | `[]` | Configure additional environment variables for the aigw deployment |
| aigw.exporter.batchSize | int | `1` | Batch size of the exporter |
| aigw.exporter.enable | bool | `false` | Enable audit exporter (storage must also be enable) |
| aigw.exporter.removeFiles | bool | `true` | Remove transactions after exporting |
| aigw.exporter.s3Bucket | string | `""` | Name of S3 bucket to export to |
| aigw.exporter.s3UploadTimeout | string | `"30s"` | Timeout for uploading a single transaction to S3 |
| aigw.exporter.type | string | `"stdout"` | Type of exporter (stdout, s3) |
| aigw.exporter.workers | int | `1` | Number of workers for the exporter |
| aigw.healthServer.port | int | `8081` | Configure the port of the health server |
| aigw.image.pullPolicy | string | `"IfNotPresent"` |  |
| aigw.image.repository | string | `"ghcr.io/nginxinc/aigw"` | Repository for the aigw image |
| aigw.image.tag | string | `"v0.1.0"` | Version tag for the aigw image |
| aigw.nodeSelector | object | `{}` | Node selector for scheduling the aigw pods |
| aigw.replicas | int | `1` | Number of replicas for the aigw deployment |
| aigw.resources | object | `{"requests":{"cpu":"50m","memory":"50Mi"}}` | Resource requests and limits for the aigw container |
| aigw.securityContext | object | `{"fsGroup":101,"runAsGroup":101,"runAsNonRoot":true,"runAsUser":101,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the aigw deployment |
| aigw.service.annotations | object | `{}` | Annotations for the service |
| aigw.service.enable | bool | `true` | Enable the service |
| aigw.service.port | int | `80` | Port for the service |
| aigw.service.type | string | `"ClusterIP"` | Type of services for the service |
| aigw.storage.enable | bool | `false` | Enable storage |
| aigw.storage.persistence.accessMode | string | `"ReadWriteOnce"` | ReadWriteOnce or ReadOnly |
| aigw.storage.persistence.enable | bool | `false` | Create a volume to store empheral audit data |
| aigw.storage.persistence.size | string | `"1Gi"` | Size of persistent volume claim |
| aigw.storage.persistence.storageClass | string | `nil` | Type of persistent volume claim |
| aigw.tolerations | list | `[]` | Tolerations for the aigw pods |
| config.contents | string | `"mode: standalone\n\nserver:\n  address: :4141\n\nadminServer:\n  address: localhost:8080\n"` | The contents of an aigw.yaml configuration file |
| config.create | bool | `true` | Enable creation of the AI Gateway `aigw.yaml` config map |
| config.name | string | `nil` | Name of ConfigMap to use |
| imagePullSecrets | list | `[]` | Array of imagePullSecrets for pulling images from private registries |
| license.secretKey | string | `"token"` | Key of the secret which contains the license data |
| license.secretName | string | `"f5-license"` | Name of the secret that contains the license data |
| processors.f5.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Security context for the aigw-processors-f5 pods |
| processors.f5.enable | bool | `true` | Enable the F5 processors (aigw-processors-f5) application |
| processors.f5.env | list | `[]` | Configure additional environment variables for the aigw-processors-f5 deployment |
| processors.f5.image.pullPolicy | string | `"IfNotPresent"` |  |
| processors.f5.image.repository | string | `"ghcr.io/nginxinc/aigw-processors-f5"` | Repository for the aigw-processors-f5 image |
| processors.f5.image.tag | string | `"v0.1.0"` | Version tag for the aigw-processors-f5 image |
| processors.f5.replicas | int | `1` | Number of replicas for the aigw-processors-f5 deployment |
| processors.f5.securityContext | object | `{"fsGroup":101,"runAsGroup":101,"runAsNonRoot":true,"runAsUser":101,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the aigw-processors-f5 deployment |
| processors.f5.service.annotations | object | `{}` | Annotations for the service |
| processors.f5.service.enable | bool | `true` | Enable the service |
| processors.f5.service.port | int | `80` | Port for the service |
| processors.f5.service.type | string | `"ClusterIP"` | Type of services for the service |
| serviceAccount.annotations | object | `{}` | Annotations for the AI Gateway service account |
| serviceAccount.create | bool | `true` | Enable creation of the AI Gateway service account |
| serviceAccount.name | string | `nil` | Service account name to be used |
| tracing.endpoint | string | `""` | Endpoint to ship gRPC traces to |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs)
