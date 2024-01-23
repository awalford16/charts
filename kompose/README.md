# Kompose

The Kompose chart takes inspiration from [kompose.io](https://kompose.io/) which converts docker-compose files into kubernetes manifests. The aim with this chart is to provide a generic chart that supports docker-compose files.

Kompose allows you to convert a docker-compose file into a Helm chart, however this chart is designed to take the compose file directly as an input to generate the manifests with one Helm install.

The chart supports the same labels defined by Kompose, plus a few extras, so that the same docker-compose files used with the `kompose` tool can be used for this chart.

## Supported Labels

### Tolerations

The chart will create deployment tolerations based on the `kompose.tolerations` label. It expects the tolerations to be passed in the format of `key=value:Effect` and multiple can be provided by separating them with a `;`.

### Node Selectors

Node Selectors for a deployment can be added with the label `kompose.nodeSelectors` and expects the value to be in the format of `key=value`. Multiple node selectors can be defined by separating them with a `;`.

### Grouping

Multiple images can be deployed under a single deployment using the `kompose.service.group` label. Setting the group name the same for different images will create multiple containers for them under the same deployment.

### Secrets

The chart supports external secrets and secrets from a file much like docker-compose. When `external` is set to true it will create and [ExternalSecret](https://external-secrets.io/v0.4.4/api-externalsecret/) resource. The `name` key references the secret store to use for external-secrets.

```yaml
services:
    test:
        environment:
            HELLO: /run/secrets/my_secret

secrets:
    my_secret:
        # This will create an external secret
        external: true
        name: my-secret-store
    my_other_secret:
        file: test.txt
```

Secrets will be mapped into environment variables if the value of the env var starts with `/run/secrets/`.

Currently the secrets only support 1 key each with the key being the same name as the secret.

Secret values from `file` are also supported but the file is required to live within the helm chart.

### Configs

### Volumes
