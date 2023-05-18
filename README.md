# Helm Charts

Some helm charts that I need for public use

## Secret Manager

Deploys External secrets and creates a secret store with support for AKV or Vault

It is recommended to install the External secret CRDs first from here: https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml as helm cannot handle the CRDs and the resources in one install