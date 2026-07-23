#  Plateforme Intelligente de Cybersécurité — LOGISTIA

[![CI - Validation](https://github.com/isshin08/logistia/actions/workflows/ci.yml/badge.svg)](https://github.com/isshin08/logistia/actions/workflows/ci.yml)
[![Deploy](https://github.com/isshin08/logistia/actions/workflows/deploy.yml/badge.svg)](https://github.com/isshin08/logistia/actions/workflows/deploy.yml)
[![Security](https://github.com/isshin08/logistia/actions/workflows/security.yml/badge.svg)](https://github.com/isshin08/logistia/actions/workflows/security.yml)

> Projet ISRC — Infrastructure intelligente, sécurisée et automatisée pour la chaîne logistique LOGISTIA.

---
##  Contexte

L'entreprise LOGISTIA exploite plusieurs entrepôts connectés. Ce projet modernise et sécurise son infrastructure en intégrant :

- Un **SOC pédagogique** (Wazuh)
- Une **automatisation complète** (Terraform + Ansible)
- Une **supervision centralisée** (Prometheus + Grafana + Loki)
- Un **pipeline DevSecOps** (GitHub Actions)
- Une **IA de détection d'anomalies** (Isolation Forest)

---
##  Architecture

```
PC Hôte (32Go RAM)
└── VirtualBox
    ├── Proxmox VE 9.2 (192.168.1.250)
    │   ├── db-server      192.168.20.10  VLAN 20  PostgreSQL
    │   ├── web-server     192.168.20.20  VLAN 20  Nginx + Flask
    │   ├── ia-server      192.168.20.30  VLAN 20  Isolation Forest
    │   ├── soc-server     192.168.30.10  VLAN 30  Wazuh + Grafana + Prometheus
    │   └── runner-server  192.168.50.10  VLAN 50  GitHub Actions Runner
    └── terraform-ansible  192.168.1.150           Poste de contrôle
```

### Plan réseau

| VLAN | Réseau | Rôle |
|------|--------|------|
| 10 | 192.168.10.0/24 | Administration |
| 20 | 192.168.20.0/24 | Serveurs applicatifs |
| 30 | 192.168.30.0/24 | SOC / Monitoring |
| 40 | 192.168.40.0/24 | IoT simulé |
| 50 | 192.168.50.0/24 | CI/CD Runner |

### Machines virtuelles

| VM ID | Nom | Rôle | IP | CPU | RAM | Disque |
|-------|-----|------|----|-----|-----|--------|
| 100 | db-server | PostgreSQL | 192.168.20.10 | 1 vCPU | 2 Go | 20 Go |
| 101 | runner-server | GitHub Actions Runner | 192.168.50.10 | 1 vCPU | 2 Go | 20 Go |
| 102 | soc-server | Wazuh + Grafana + Prometheus + Loki | 192.168.30.10 | 2 vCPU | 8 Go | 50 Go |
| 103 | web-server | Nginx + Flask | 192.168.20.20 | 1 vCPU | 2 Go | 20 Go |
| 104 | ia-server | Isolation Forest | 192.168.20.30 | 1 vCPU | 4 Go | 20 Go |

---
## 🛠️ Stack technique

| Catégorie | Outil | Version |
|-----------|-------|---------|
| Hyperviseur | Proxmox VE | 9.2 |
| IaC | Terraform | 1.15.5 |
| Provider Terraform | bpg/proxmox | 0.78.1 |
| Configuration | Ansible | 2.19.4 |
| Application web | Flask + Nginx | 3.x / 1.22 |
| Base de données | PostgreSQL | 15 |
| Supervision | Prometheus + Grafana | 2.52 / 11.x |
| Centralisation logs | Loki + Promtail | 3.0 |
| SOC/SIEM | Wazuh | 4.14.5 |
| IA | Isolation Forest (scikit-learn) | 1.x |
| CI/CD | GitHub Actions + Runner self-hosted | - |
| Sécurité | fail2ban + auditd + nftables | - |

---

## 🚀 Déploiement

### Prérequis

- Proxmox VE 9.2 avec token API \`terraform@pve!terraform-token\`
- VM Debian 13 avec Terraform 1.15.5 + Ansible 2.19.4
- Secrets GitHub configurés (voir ci-dessous)

### 1. Provisionner les VM (Terraform)

```bash
terraform init
terraform plan
terraform apply -parallelism=1
```

### 2. Configurer les services (Ansible)

```bash
cd ansible
ansible-playbook playbooks/common.yml --forks=1
ansible-playbook playbooks/db.yml --forks=1
ansible-playbook playbooks/web.yml --forks=1
ansible-playbook playbooks/supervision.yml --forks=1
ansible-playbook playbooks/soc.yml --forks=1
ansible-playbook playbooks/ia.yml --forks=1
ansible-playbook playbooks/runner.yml --forks=1
```

---

## 🔄 Pipeline CI/CD

| Workflow | Déclencheur | Description |
|----------|-------------|-------------|
| \`ci.yml\` | Push / PR | Lint Terraform + Ansible, test connectivité VM |
| \`deploy.yml\` | Push ou Manuel | Terraform plan + tous les playbooks Ansible |
| \`security.yml\` | Manuel uniquement | Scan secrets, audit sécurité, vérification services |

### Secrets GitHub requis

| Secret | Description |
|--------|-------------|
| \`PROXMOX_API_URL\` | URL API Proxmox |
| \`PROXMOX_TOKEN_ID\` | ID token terraform@pve |
| \`PROXMOX_TOKEN_SECRET\` | Valeur du token |
| \`SSH_PUBLIC_KEY\` | Clé publique SSH |
| \`DB_PASSWORD\` | Mot de passe PostgreSQL |

> 💡 Ajouter \`[skip ci]\` dans le message de commit pour ignorer les workflows (ex: modification du README)

---

##  Intelligence Artificielle

**Algorithme** : Isolation Forest (scikit-learn) — détection d'anomalies non supervisée

**Features analysées** :
- Nombre de requêtes HTTP
- Nombre d'erreurs (4xx/5xx)
- Tentatives de connexion SSH
- Volume de données transférées
- Durée de session

**Résultats** : 18 anomalies détectées sur 220 entrées (taux : 8.18%)

**Exécution** : Timer systemd toutes les 5 minutes sur ia-server

---

## 🛡️ Cybersécurité

### Mesures en place

- Durcissement SSH + Connexion par clé uniquement
- fail2ban actif sur toutes les VM (bannissement après 5 tentatives)
- auditd pour la journalisation des événements système
- Segmentation VLAN (isolation inter-réseau)
- NAT Proxmox (VM non exposées directement)
- Wazuh surveille 5 agents en temps réel

### Simulations d'attaques réalisées

| Scénario | Outil | Résultat |
|----------|-------|---------|
| Reconnaissance réseau | nmap -sS -sV -sC | Ports et CVE identifiés |
| Détection vulnérabilités | nmap --script vuln | CVE-2024-6387 détectée |
| Brute force SSH | Hydra | Wazuh alerte + fail2ban bannit |
| Flood HTTP | curl x400 | IA détecte 18 anomalies |

---

##  Supervision

| Service | URL | Rôle |
|---------|-----|------|
| Grafana | http://192.168.30.10:3000 | Dashboards métriques et logs |
| Prometheus | http://192.168.30.10:9090 | Collecte métriques |
| Loki | http://192.168.30.10:3100 | Agrégation logs |

---

##  Structure du dépôt

```
logistia/
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini
│   └── playbooks/
│       ├── common.yml
│       ├── db.yml
│       ├── web.yml
│       ├── supervision.yml
│       ├── soc.yml
│       ├── ia.yml
│       └── runner.yml
├── tests/
│   ├── scan.sh
│   ├── flood_http.sh
│   └── preuves/
└── .github/workflows/
    ├── ci.yml
    ├── deploy.yml
    └── security.yml
```

---

