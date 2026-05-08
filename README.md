# gitlab-kubernetes
This project is a deployment of GitLab and bootstrap components (ExternalDNS, CertManager, EnvoyGateway...) as well as monitoring (Grafana, Prometheus...) on DigitalOcean Kubernetes (DOKS) using Terraform and Flux CD. It was designed to be usable without any DigitalOcean resource limit increases.

I made this project to learn about Terraform, Kubernetes, Helm, GitOps and the complexities of managing distributed systems. I chose GitLab because it is personally useful to me as someone who programs very frequently.

## Quick Start
> [!WARNING]
> This will cost real money.

Before getting started, make sure you have a domain on DigitalOcean as well as all the required secrets.
1. Fork this repository
2. Delete all files in ./flux/flux-system
3. Create a new environment called "production", with the environment secrets listed in the knowledge base
4. Trigger the GitHub action corresponding to what you want to do

## Knowledge Base
### Architecture
1. Terraform manages:
   * Domain
   * VPC
   * Kubernetes cluster
   * FluxCD bootstrap
   * ConfigMap derived from non-sensitive Terraform values (e.g. database host, database port...)
   * Secrets derived from sensitive Terraform values (e.g. database password, R2 access credentials...)
   * Namespaces for the secrets
   * PostgreSQL database
   * Valkey database
   * CloudFlare R2 buckets
2. FluxCD bootstrap reconciliates ./flux
3. Kustomization templates values using two ConfigMaps: runtime-values (from Terraform) and shared-values (from the repository)
4. FluxCD manages repositories:
   * cert-manager
   * emberstack
   * envoy-proxy
   * external-dns
   * gitlab
   * prometheus-community
5. FluxCD manages releases:
   * cert-manager
   * cluster-issuer
   * dns01-certificate
   * envoy-gateway
   * external-dns
   * gateway-config
   * gitlab
   * kube-prometheus-stack
   * reflector
### Terraform
#### Variables
| Name | Description | Default |
| --- | --- | --- |
| do_token | DigitalOcean API token with full access | |
| do_dns_token | DigitalOcean API token with full access to DNS | |
| cloudflare_account_id | CloudFlare account ID | |
| cloudflare_api_token | CloudFlare API token with full access | |
| cloudflare_r2_endpoint | CloudFlare R2 endpoint | |
| cloudflare_r2_access_key_id | CloudFlare R2 access key ID | |
| cloudflare_r2_secret_access_key | CloudFlare R2 access key | |
| sendgrid_api_key | Twilio SendGrid API key | |
| git_repo | GitHub repository to sync with | |
| git_token | GitHub PAT with write access to the GitHub repository | |
| region | DigitalOcean region where all the resources will be located | ams3 | |
| r2_jurisdiction | Unlock the Terraform state | eu | |
| cluster_name | Name of the Kubernetes cluster | gitlab | |
| k8s_version | Kubernetes version | 1.35.1 | |
| node_size | Node size for the cluster | s-4vcpu-8gb | |
| node_count | Node count for the cluster | 3 |
| email | Email, to be used to create an account with Let's Encrypt | |
| domain_name | Domain name | |
| gitlab_host | Subdomain used for GitLab | gitlab |
| registry_host | Subdomain used for GitLab Registry | registry |
| pages_host | Subdomain used for GitLab Pages | pages |
| grafana_host | Subdomain used for Grafana | grafana |
### Github Actions
#### Index
| Name | Description |
| --- | --- |
| terraform-deploy | Deploy the application |
| terraform-destroy | Destroy the application |
| terraform-staterm | Delete an object from Terraform state |
| terraform-unlock | Unlock the Terraform state |
#### Environment Secrets
| Name | Environment Variable | Terraform Variable |
| --- | --- | --- |
| DOMAIN_NAME | TF_VAR_domain_name | domain_name |
| EMAIL | TF_VAR_email | email |
| DO_TOKEN | TF_VAR_do_token |do_token |
| DO_DNS_TOKEN | TF_VAR_do_dns_token | do_dns_token |
| CLOUDFLARE_ACCOUNT_ID | TF_VAR_cloudflare_account_id | cloudflare_account_id |
| CLOUDFLARE_API_TOKEN | TF_VAR_cloudflare_api_token | cloudflare_api_token |
| R2_ENDPOINT | TF_VAR_cloudflare_r2_endpoint | cloudflare_r2_endpoint |
| R2_ACCESS_KEY_ID | TF_VAR_cloudflare_r2_access_key_id | cloudflare_r2_access_key_id |
| R2_SECRET_ACCESS_KEY | TF_VAR_cloudflare_r2_secret_access_key | cloudflare_r2_secret_access_key |
| SPACES_ACCESS_ID | AWS_ACCESS_KEY_ID | - |
| SPACES_SECRET_KEY | AWS_SECRET_ACCESS_KEY | - |
| SENDGRID_API_KEY | TF_VAR_sendgrid_api_key | sendgrid_api_key |
### Limitations
* The DigitalOcean Kubernetes cluster version is hardcoded in terraform/cluster.tf. This was done to prevent errors triggered by upgrades, as the Droplet limit is too low for these.
## Images
![GitLab](https://raw.githubusercontent.com/clofour/gitlab-kubernetes/refs/heads/main/docs/assets/gitlab.png)
![Grafana](https://raw.githubusercontent.com/clofour/gitlab-kubernetes/refs/heads/main/docs/assets/grafana.png))