# Secret Manager Chart

## Secrets

K8s clusters use a tool called External Secrets which can read secret values from Vault or Azure KV. It requires a namespace to have a SecretStore resource which includes the Vault token and engine information used by ExternalSecrets to pull from Vault. This chart installs necessary resources for talking to Vault or Azure Key Vault to retrieve secrets in K8s.

If the cluster does not have ExternalSecrets installed or any of its CRDs, they can be installed by setting `installDependencies` value to `true`.

### Vault

Install with `helm install USERNAME secret-manager --set vault.token=$VAULT_TOKEN`

```
vault:
    secrets:
        K8S_SECRET_NAME:
            keys:
                - path: secret/mysecret
                  property: secret
                  secretKey: k8ssecretkey
```


### Azure Key Vault

Azure KV is disabled by default so it will need to be enabled and set vault to disabled.

```
helm install secrets secret-manager \
    --set vault.enabled=false \
    --set azureKeyVault.enabled=true \
    --set azureKeyVault.clientID=... \
    --set azureKeyVault.clientSecret=...
```

Secrets can be created in values file like so:

```
azureKeyVault:
    enabled: true
    secrets:
        K8S_SECRET_NAME:
            keys:
                - akvKey: mysecret
                  secretKey: k8ssecretkey
```
