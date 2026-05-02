# gitlab-kubernetes
This project is a deployment of GitLab and bootstrap components (ExternalDNS, CertManager, EnvoyGateway...) as well as monitoring (Grafana, Prometheus...) on DigitalOcean Kubernetes (DOKS) using Terraform and Flux CD.

## Quick Start
1. Fork this repository
2. Create a new environment called "production", with the environment secrets listed in the knowledge base
3. Trigger the GitHub action corresponding to what you want to do

## Knowledge Base
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

