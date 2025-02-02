# Addons

## Prerequisites

* terraform >= 1.0.0
* AWS role configured and assumed(Route53 is used for TSB MP FQDN)
* (optional) Azure role configured and assumed
* (optional) GCP role configured and assumed  `gcloud auth application-default login`

## ArgoCD

Deploy Argo CD for gitops demo

```bash
# Deploys Argocd on all Clusters
make argocd
```

`argocd` is exposed using LoadBalancer type `kubectl get svc -n argocd argo-cd-argocd-server`, the username is `admin`
and the password can be found in the `outputs/terraform_outputs/terraform-argocd-<cloud>-<cluster_id>.json` file
(defaults to the `tsb_password` if set).

For details about the deployed applications, take a look at the manifests in the `applications` folder.

## TSB monitoring stack

Deploy the TSB monitoring stack to have metrics and dashboards showing the operational status
of the different TSB components.

```bash
# Deploys the TSB monitoring stack in the management plane cluster
make monitoring
```

`grafana` is exposed using ClusterIP type. It can be accessed by port-forwarding port 3000 to the `grafana` pod
in the `tsb-monitoring` namespace. The username is `admin` and the password can be found in the
`outputs/terraform_outputs/terraform-monitoring.json` file (defaults to the `tsb_password` if set).

### Module Overview

#### module.argocd (`make argocd`)
* Deploys ArgoCD
* bookinfo demo app using ArgoCD with related TSB components.
* grpc demo app using ArgoCD with related TSB components.
* eshop demo app using ArgoCD with related TSB components.

#### module.monitoring (`make monitoring`)
* Deploys the TSB monitoring stack.
* prometheus configured to scrape all the TSB and XCP components.
* grafana with TSB operational dashboards preloaded and configured.

#### keycloak (In progress)
* module.keycloak-helm - deploys keycloak.
* module.keycloak-provider - configs keycloak for JWT-based external authorization demo.
* module.app_bookinfo - deploys bookinfo.
