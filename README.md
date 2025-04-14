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

### ✅ Configuratie Visual Studio Code

#### Stap 1:
Open Visual Studio Code in de map waar `main.tf` staat. Zet de terminal om naar **Git Bash**.

#### Stap 2:
Log in via Azure CLI:

```bash
az login
```

Heb je meerdere subscriptions? Selecteer de juiste via:

```bash
az account set --subscription "Subscription-ID-of-Naam"
```

#### Stap 3:
Kloon de repo via:

```bash
git clone https://github.com/Ooffuss1453/elkstack-terraform
```

---

## ☁️ Stap 2 – Deploy infrastructuur

1. Open een **Git Bash terminal** in de map waar `main.tf` staat.
2. Achterhaal je Subscription ID via:

```bash
az account show --output json
```

📋 Kopieer de waarde van `id` en sla die tijdelijk op.

3. Start de Terraform setup:

```bash
terraform init
terraform plan
terraform apply
```

Tijdens `terraform apply` wordt je automatisch gevraagd om je subscription ID:

📸 Zie:  
> var.subscription_id  
> Azure Subscription ID (wordt gevraagd bij uitvoeren)  
> Enter a value:

Voer hier je gekopieerde ID in. Bevestig met `yes`. Dit duurt ongeveer **6–8 minuten**.

✅ Dit maakt:  
- AKS cluster  
- Fleet & Agent VMs  
- VNet, IP’s, subnets, NSG  
- ELK stack op Kubernetes  

---

## 🔐 Stap 3 – Gevoelige gegevens ophalen

Voer onderstaande scripts uit vanuit de hoofdmap:

```bash
bash elastic-enrollment-token.sh
bash elastic-password.sh
bash kibana-verification-code.sh
```

📋 Noteer:
- Kibana Verification Code  
- Elasticsearch wachtwoord  
- Enrollment token  

---

## 🌐 Stap 4 – Open Kibana via Azure

1. Ga naar Azure Portal → resource group `Dataplatform-Group-Monitoring`  
2. Open de AKS cluster → Services  
3. Zoek `kibana` → kopieer het **externe IP**  
4. Open in je browser en volg de setup  

---

## 🛰️ Stap 5 – Fleet Server installeren

In deze stap installeren we de **Fleet Server** op de Fleet VM. De Fleet Server beheert alle aangesloten Elastic Agents binnen het systeem en zorgt ervoor dat loggegevens, metrics en andere data worden verzameld en doorgestuurd naar Elasticsearch. Dit vormt de kern van de monitoringarchitectuur.

1. Ga in Kibana naar **Fleet**  
2. Klik op **Add Fleet Server**  
3. Vul het **IP van de Fleet VM** in  
4. Kopieer het gegenereerde script  

SSH naar de Fleet VM:

```bash
ssh -i ssh/fleet_vm_id_rsa azureuser@<Fleet-VM-IP>
sudo apt update && sudo apt upgrade -y
```

Plak daarna het volledige installatiecommando in de terminal

ℹ️ **Let op:**  
- Als de installatie onderbroken wordt, kun je de commando opnieuw uitvoeren. Alle stappen moeten dan met `&&` aan het einde toegevoegd worden.
- Als er al een eerdere installatie bestaat, verwijder deze dan eerst met:

```bash
sudo /opt/Elastic/Agent/elastic-agent uninstall
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
ELKSTACK-TERRAFORM/
├── elastic-enrollment-token.sh
├── elastic-password.sh
├── kibana-verification-code.sh
├── LICENSE
├── main.tf
├── variables.tf
├── README.md
```

---

## ✅ Klaar voor gebruik

Je platform is nu klaar voor gebruik! Je kunt eenvoudig nieuwe projecten onboarden door:
- Een nieuwe namespace + elastic-agent te deployen
- Logs/metrics worden automatisch verzameld via Fleet

---

## ✍️ Auteur

Gemaakt voor project aan de hand van een onderzoeksopdracht over monitoring in de cloud (Azure).
