# zenotta-cloud-mining

> Still in development and very experimental

## Replacing cluster and recreating helm resources

When changing resources on the cluster first remove modeules that rely on its credentials.
This avoids passing outdated credentials to providers

`terraform state rm module.zenotta-miners`
`helm_release.zenotta-node-release`