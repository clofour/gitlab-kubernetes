# gitlab-kubernetes
This project is a deployment of GitLab and bootstrap components (ExternalDNS, CertManager, EnvoyGateway...) as well as monitoring (Grafana, Prometheus...) on DigitalOcean Kubernetes (DOKS) using Terraform and Flux CD. It was designed to be usable without any DigitalOcean resource limit increases.

## Quick Start
1. Fork this repository
2. Create a new environment called "production", with the environment secrets listed in the knowledge base
3. Trigger the GitHub action corresponding to what you want to do

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
### Github Actions
#### Index
| Name | Description |
| ---- | ----------- |
| terraform-deploy | Deploy the application |
| terraform-destroy | Destroy the application |
| terraform-staterm | Delete an object from Terraform state |
| terraform-unlock | Unlock the Terraform state |
#### Environment Secrets
| Name | Description |
| ---- | ----------- |
| DOMAIN_NAME | Domain name |
| EMAIL | Email, to be used to create an account with Let's Encrypt |
| DO_TOKEN | DigitalOcean API token with full access |
| DO_DNS_TOKEN | DigitalOcean API token with full access to DNS |
| CLOUDFLARE_ACCOUNT_ID | CloudFlare account ID |
| CLOUDFLARE_API_TOKEN | CloudFlare API token with full access |
| R2_ENDPOINT | CloudFlare R2 endpoint |
| R2_ACCESS_KEY_ID | CloudFlare R2 access key ID |
| R2_SECRET_ACCESS_KEY | CloudFlare R2 access key |
| SPACES_ACCESS_ID | DigitalOcean Spaces access key ID |
| SPACES_SECRET_KEY | DigitalOcean Spaces access key |
| SENDGRID_API_KEY | Twilio SendGrid API key |
### Limitations
* The DigitalOcean Kubernetes cluster version is hardcoded in terraform/cluster.tf. This was done to prevent errors triggered by upgrades, as the Droplet limit is too low for these.