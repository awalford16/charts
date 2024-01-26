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

The chart supports external secrets and secrets from a file much like docker-compose. When `external` is set to true it will create and [ExternalSecret](https://external-secrets.io/v0.4.4/api-externalsecret/) resource. The `name` key references the secret key within the remote secret store.

```yaml
services:
    test:
        environment:
            HELLO: /run/secrets/my_secret

secrets:
    my_secret:
        # This will create an external secret
        external: true
        name: secret-key
    my_other_secret:
        file: test.txt
```

Additional ExternalSecret configuration can be managed with the `x-externalSecrets` block in the compose values:

```yaml
x-externalSecrets:
  secretStoreName: my-secret-store
  secretStoreKind: ClusterSecretStore
```

Secrets will be mapped into environment variables if the value of the env var starts with `/run/secrets/`.

Currently the secrets only support 1 key each with the key being the same name as the secret.

Secret values from `file` are also supported but the file is required to live within the helm chart.

### Configs

Defining a `config` block will create ConfigMap resources. Currently it just supports the `content` key with the CM data passed in directly.

```yaml
config:
    my_config:
        content: |
            hello
```

If `configs` is added to a service then it will mount in that ConfigMap as a volume at `/CONFIGMAP_NAME`

```yaml
services:
    app:
        configs:
            - my_config
```

Additionally, they can be consumed as environment variables, similar to secrets by specifying the path `/CONFIGMAP_NAME`. This is where docker-compose will store config data on a build. The chart will check to see that the CM exists and will spit out the relevant template:

```yaml
services:
    app:
        environment:
            MY_CONFIG: /my-config # Config map does not exist, will render as this path specifically
```

```yaml
services:
    app:
        environment:
            MY_CONFIG: /my-config # Config map exists so will read in CM value into env var

config:
    my-config:
        content: |
            hello
```


### Volumes
