# Kompose

The Kompose chart takes inspiration from [kompose.io](https://kompose.io/) which converts docker-compose files into kubernetes manifests. The aim with this chart is to provide a generic chart that supports docker-compose files.

Kompose allows you to convert a docker-compose file into a Helm chart, however this chart is designed to take the compose file directly as an input to generate the manifests with one Helm install.

The chart supports the same labels defined by Kompose so that the same docker-compose files used with the `kompose` tool can be used for this chart.
