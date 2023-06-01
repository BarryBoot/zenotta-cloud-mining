# zenotta-cloud-mining

> Still in development and very experimental

## Replacing cluster and recreating helm resources

When changing resources on the cluster first remove modeules that rely on its credentials.
This avoids passing outdated credentials to providers

`terraform state rm module.zenotta-miners`
`terraform state rm module.zenotta-nodes`
`kubectl get pv | grep Released | awk '$1 {print$1}' | while read vol; do kubectl delete pv/${vol}; done`
`helm list --short | grep zenotta-miner | xargs -L1 helm uninstall`
`helm list --short | grep zenotta-node | xargs -L1 helm uninstall`