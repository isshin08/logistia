# Plateforme intelligente de cybersécurité — LOGISTIA

[![CI - Validation](https://github.com/isshin08/logistia/actions/workflows/ci.yml/badge.svg)](https://github.com/isshin08/logistia/actions/workflows/ci.yml)

## Architecture

| VM | Rôle | IP | VLAN |
|---|---|---|---|
| db-server | PostgreSQL | 192.168.20.10 | 20 |
| web-server | Nginx + Flask | 192.168.20.20 | 20 |
| ia-server | Isolation Forest | 192.168.20.30 | 20 |
| soc-server | Wazuh + Grafana + Prometheus + Loki | 192.168.30.10 | 30 |
| runner-server | GitHub Actions Runner | 192.168.50.10 | 50 |

## Stack technique

- **Infrastructure** : Proxmox VE 9.2 + Terraform (bpg/proxmox) + Ansible
- **Application** : Flask + Nginx + PostgreSQL
- **Supervision** : Prometheus + Grafana + Loki + Promtail
- **SOC** : Wazuh Manager + Agents
- **IA** : Isolation Forest (scikit-learn)
- **CI/CD** : GitHub Actions + Self-hosted Runner

## Déploiement

```bash
# Provisionner les VM
cd terraform
terraform init
terraform apply -parallelism=1

# Configurer les services
cd ../ansible
ansible-playbook playbooks/common.yml --forks=1
ansible-playbook playbooks/db.yml --forks=1
ansible-playbook playbooks/web.yml --forks=1
ansible-playbook playbooks/supervision.yml --forks=1
ansible-playbook playbooks/soc.yml --forks=1
ansible-playbook playbooks/ia.yml --forks=1
ansible-playbook playbooks/runner.yml --forks=1
```
