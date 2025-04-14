# ELK Monitoring Platform on Azure (AKS + Fleet Server)

Deze repository bevat een complete setup voor een schaalbare ELK stack in Azure, inclusief:
- AKS cluster
- Fleet Server & Agent VMs
- Elasticsearch, Kibana en Logstash
- Automatisering via Terraform
- Scripts om gevoelige tokens/credentials op te halen

---

## ⚙️ Vereisten

- Azure Subscription
- Terraform
- Azure CLI
- Git Bash of WSL (voor Bash-scripts)
- Poorten 5601, 8220, 9200, 5044 open op NSG
- OpenSSH (voor SSH naar VMs)

---

## ✏️ Stap 1 – Voorbereiding

### ✅ Controleer `main.tf`:
- **Subscription ID** staat nu hardcoded → pas deze aan via `terraform.tfvars`
- **Regio** staat op `UK South` → wijzig naar `westeurope` of je gewenste regio

---

## ☁️ Stap 2 – Deploy infrastructuur

Open een terminal in de map waar `main.tf` staat:

```bash
terraform init
terraform plan
terraform apply
```

Bevestig met `yes`. Dit duurt ongeveer **6–8 minuten**.

> Dit maakt:  
> ✅ AKS cluster  
> ✅ Fleet & Agent VMs  
> ✅ VNet, IP’s, subnets, NSG  
> ✅ ELK stack op Kubernetes

---

## 🔐 Stap 3 – Gevoelige gegevens ophalen

Voer onderstaande scripts uit vanuit de `scripts/` map:

```bash
bash scripts/elastic-enrollment-token.sh
bash scripts/elastic-password.sh
bash scripts/kibana-verification-code.sh
```

📋 Noteer:
- Kibana Verification Code
- Elasticsearch wachtwoord
- Enrollment token

---

## 🌐 Stap 4 – Open Kibana via Azure

1. Ga naar Azure Portal → `aks_rg-main` resource group
2. Open de AKS cluster → Services & Ingress
3. Zoek `kibana` → kopieer het **externe IP**
4. Open in browser → volg de setup-stappen

---

## 🛰️ Stap 5 – Fleet Server installeren

1. Ga in Kibana naar **Fleet**
2. Klik op **Add Fleet Server**
3. Vul het **IP van de Fleet VM** in
4. Kopieer het gegenereerde script

SSH naar de Fleet VM:

```bash
ssh -i ssh/fleet_vm_id_rsa azureuser@<Fleet-VM-IP>
sudo apt update && sudo apt upgrade -y
# plak hier het script
```

---

## 🤖 Stap 6 – Agent installeren op Agent VM

1. Klik in Kibana op **Add agent**
2. Vul opnieuw het IP van de Fleet VM in
3. Voeg **--insecure** toe aan het einde van het script
4. SSH naar Agent VM:

```bash
ssh -i ssh/agent_vm_id_rsa azureuser@<Agent-VM-IP>
sudo apt update && sudo apt upgrade -y
# plak hier het script met --insecure
```

---

## 📊 Stap 7 – Monitoring uitbreiden

Gebruik het zoekveld in Kibana om integraties te activeren zoals:
- Azure Monitoring
- Kubernetes Metrics
- Azure Activity Logs

---

## 📁 Projectstructuur

```
elk-monitoring-aks/
├── README.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
├── scripts/
│   ├── elastic-enrollment-token.sh
│   ├── elastic-password.sh
│   └── kibana-verification-code.sh
├── ssh/
│   └── fleet_vm_id_rsa, agent_vm_id_rsa (auto gegenereerd)
```

---

## ✅ Klaar voor gebruik

Je platform is nu klaar voor gebruik! Je kunt eenvoudig nieuwe projecten onboarden door:
- Een nieuwe namespace + elastic-agent te deployen
- Logs/metrics worden automatisch verzameld via Fleet

---

## ✍️ Auteur

Gemaakt voor project aan de hand van een onderzoeksopdracht over monitoring in de cloud (Azure).
