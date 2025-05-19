# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">=3.64.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}

#   subscription_id = "642dd095-927a-4bdf-9152-d4f6609d0207"
# }

# provider "kubernetes" {
#   config_path             = "~/.kube/config"
#   host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#   client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# }

# data "azurerm_resource_group" "main" {
#   name = "Dataplatform-Group-Monitoring"
# }

# resource "azurerm_kubernetes_cluster" "aks" {
#   depends_on = [azurerm_kubernetes_cluster.aks]
#   name                = "my-aks-cluster"
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
#   dns_prefix          = "myaksdns"

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_DS2_v2"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   oidc_issuer_enabled = true
#   role_based_access_control_enabled = true

#   network_profile {
#     network_plugin = "azure"
#   }

#   tags = {
#     Environment = "dev"
#   }
# }

# data "azurerm_kubernetes_cluster" "aks_data" {
#   name                = azurerm_kubernetes_cluster.aks.name
#   resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
# }

# # provider "kubernetes" {
# #   host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
# #   client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
# #   client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
# #   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# # }

# # Define Virtual Network
# resource "azurerm_virtual_network" "vnet" {
#   name                = "vnet-mon-innovationlab"
#   location = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
#   address_space       = ["10.0.0.0/16"]
# }

# #Define security group ===============================================================================================================================
# resource "azurerm_network_security_group" "AKSsg" {
#   name                = "SecurityGroupGeneral"
#   location = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
# }
# #Define security rules
# resource "azurerm_network_security_rule" "AgentToFleet" {
#       name                        = "AgentToFleet"
#       priority                    = 100
#       direction                   = "Inbound"
#       access                      = "Allow"
#       protocol                    = "Tcp"
#       source_port_range           = "*"
#       destination_port_range      = "8220"
#       source_address_prefix       = "*"
#       destination_address_prefix  = "*"
#       resource_group_name         = data.azurerm_resource_group.main.name
#       network_security_group_name = azurerm_network_security_group.AKSsg.name
# }
# resource "azurerm_network_security_rule" "AgentToElastic" {
#       name                        = "AgentToElastic"
#       priority                    = 101
#       direction                   = "Inbound"
#       access                      = "Allow"
#       protocol                    = "Tcp"
#       source_port_range           = "*"
#       destination_port_range      = "9200"
#       source_address_prefix       = "*"
#       destination_address_prefix  = "*"
#       resource_group_name         = data.azurerm_resource_group.main.name
#       network_security_group_name = azurerm_network_security_group.AKSsg.name
# }
# resource "azurerm_network_security_rule" "AgentToLogtash" {
#       name                        = "AgentToLogtash"
#       priority                    = 102
#       direction                   = "Inbound"
#       access                      = "Allow"
#       protocol                    = "Tcp"
#       source_port_range           = "*"
#       destination_port_range      = "5044"
#       source_address_prefix       = "*"
#       destination_address_prefix  = "*"
#       resource_group_name         = data.azurerm_resource_group.main.name
#       network_security_group_name = azurerm_network_security_group.AKSsg.name
# }
# resource "azurerm_network_security_rule" "AgentToKibanaWhenFleet" {
#       name                        = "AgentToKibanaWhenFleet"
#       priority                    = 103
#       direction                   = "Inbound"
#       access                      = "Allow"
#       protocol                    = "Tcp"
#       source_port_range           = "*"
#       destination_port_range      = "5601"
#       source_address_prefix       = "*"
#       destination_address_prefix  = "*"
#       resource_group_name         = data.azurerm_resource_group.main.name
#       network_security_group_name = azurerm_network_security_group.AKSsg.name
# }
# resource "azurerm_network_security_rule" "FleetToElastic" {
#       name                        = "FleetToElastic"
#       priority                    = 104
#       direction                   = "Inbound"
#       access                      = "Allow"
#       protocol                    = "Tcp"
#       source_port_range           = "*"
#       destination_port_range      = "9200"
#       source_address_prefix       = "*"
#       destination_address_prefix  = "*"
#       resource_group_name         = data.azurerm_resource_group.main.name
#       network_security_group_name = azurerm_network_security_group.AKSsg.name
# }
# resource "azurerm_network_security_rule" "ssh_sr" {
#       name                        = "ssh"
#       priority                    = 105
#       direction                   = "Inbound"
#       access                      = "Allow"
#       protocol                    = "Tcp"
#       source_port_range           = "*"
#       destination_port_range      = "22"
#       source_address_prefix       = "*"
#       destination_address_prefix  = "*"
#       resource_group_name         = data.azurerm_resource_group.main.name
#       network_security_group_name = azurerm_network_security_group.AKSsg.name
# }

# # Define Subnet for AKS
# resource "azurerm_subnet" "aks_subnet" {
#   name                 = "aks-subnet"
#   resource_group_name  = data.azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# # Define Subnet for Agents
# resource "azurerm_subnet" "agent_subnet" {
#   name                 = "agent-subnet"
#   resource_group_name  = data.azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
# }
# #Associate subnet with Security Group
# resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.aks_subnet.id
#   network_security_group_id = azurerm_network_security_group.AKSsg.id
# }
# #Associate subnet with Security Group
# resource "azurerm_subnet_network_security_group_association" "agents_subnet_nsg_assoc" {
#   subnet_id                 = azurerm_subnet.agent_subnet.id
#   network_security_group_id = azurerm_network_security_group.AKSsg.id
# }

# # Create a public IP address fleetVM
# resource "azurerm_public_ip" "fleet_public_ip" {
#   name = "FleetPubIP"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location = "West Europe"
#   allocation_method = "Static"
# }

# # Create a public IP address agentVM
# resource "azurerm_public_ip" "agent_public_ip" {
#   name = "AgentPubIP"
#   resource_group_name = data.azurerm_resource_group.main.name
#   location = "West Europe"
#   allocation_method = "Static"
# }

# # Create AKS Cluster in Azure =====================================================================================================================
# resource "azurerm_kubernetes_cluster" "aks_cluster" {
#   name                = "aks-cluster"
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
#   dns_prefix          = "k8s"

#   default_node_pool {
#     name       = "default"
#     node_count = 2
#     vm_size    = "Standard_DS2_v2"
#     vnet_subnet_id  = azurerm_subnet.aks_subnet.id
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#    network_profile {
#     network_plugin    = "azure"
#     dns_service_ip    = "10.1.0.10"  # Non-overlapping range
#     service_cidr      = "10.1.0.0/16"  # Non-overlapping range
#     load_balancer_sku = "standard"
#   }
# }

# # Setup SSH =======================================================================================================================================
# resource "local_file" "create_ssh_folder" {
#   filename = "./ssh/.placeholder"
#   content  = ""
# }

# # Generate SSH Key for Fleet VM
# resource "tls_private_key" "fleet_vm_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "local_file" "fleet_vm_private_key" {
#   depends_on = [local_file.create_ssh_folder]
#   filename   = "./ssh/fleet_vm_id_rsa"
#   content    = tls_private_key.fleet_vm_key.private_key_pem
#   file_permission = "0600"
# }

# resource "local_file" "fleet_vm_public_key" {
#   depends_on = [local_file.create_ssh_folder]
#   filename   = "./ssh/fleet_vm_id_rsa.pub"
#   content    = tls_private_key.fleet_vm_key.public_key_openssh
# }

# # Generate SSH Key for Agent VM
# resource "tls_private_key" "agent_vm_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "local_file" "agent_vm_private_key" {
#   depends_on = [local_file.create_ssh_folder]
#   filename   = "./ssh/agent_vm_id_rsa"
#   content    = tls_private_key.agent_vm_key.private_key_pem
#   file_permission = "0600"
# }

# resource "local_file" "agent_vm_public_key" {
#   depends_on = [local_file.create_ssh_folder]
#   filename   = "./ssh/agent_vm_id_rsa.pub"
#   content    = tls_private_key.agent_vm_key.public_key_openssh
# }

# # Setup Agent & Fleet VM + network interfaces =======================================================================================================
# # Network Interface for the AKS VM
# resource "azurerm_network_interface" "fleet_vm_nic" {
#   name                = "fleet-vm-nic"
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.aks_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.fleet_public_ip.id
#   }
# }

# # AKS VM
# resource "azurerm_linux_virtual_machine" "fleet_vm" {
#   name                = "fleet-vm"
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
#   size                = "Standard_B1s"
#   admin_username      = "azureuser"
#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.fleet_vm_key.public_key_openssh
#   }
#   network_interface_ids = [azurerm_network_interface.fleet_vm_nic.id]

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = 30
#   }
# }

# # Network Interface for the Agent VM
# resource "azurerm_network_interface" "agent_vm_nic" {
#   name                = "agent-vm-nic"
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.agent_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.agent_public_ip.id
#   }
# }

# # Agent VM
# resource "azurerm_linux_virtual_machine" "agent_vm" {
#   name                = "agent-vm"
#   location            = data.azurerm_resource_group.main.location
#   resource_group_name = data.azurerm_resource_group.main.name
#   size                = "Standard_B1s"
#   admin_username      = "azureuser"
#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.agent_vm_key.public_key_openssh
#   }
#   network_interface_ids = [azurerm_network_interface.agent_vm_nic.id]

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = 30
#   }
# }

# # Deploy Elasticsearch, Kibana and Logstash on the Kubernetes cluster =======================================================================================================
# resource "kubernetes_deployment" "elasticsearch" {
#   metadata {
#     name      = "elasticsearch"
#     namespace = "default"
#     labels = { app = "elasticsearch" }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = { app = "elasticsearch" }
#     }

#     template {
#       metadata { labels = { app = "elasticsearch" } }

#       spec {
#         container {
#           name  = "elasticsearch"
#           image = "docker.elastic.co/elasticsearch/elasticsearch:8.16.1"

#           port { container_port = 9200 }

#           env {
#             name  = "discovery.type"
#             value = "single-node"
#           }

#           resources {
#             requests = {
#               cpu    = "1000m"  # request 1 CPU
#               memory = "2Gi"    # request 2 GiB RAM
#             }
#             limits = {
#               cpu    = "2000m"  # cap at 2 CPU
#               memory = "4Gi"    # cap at 4 GiB RAM
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_deployment" "kibana" {
#   metadata {
#     name      = "kibana"
#     namespace = "default"
#     labels    = { app = "kibana" }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = { app = "kibana" }
#     }

#     template {
#       metadata { labels = { app = "kibana" } }

#       spec {
#         container {
#           name  = "kibana"
#           image = "docker.elastic.co/kibana/kibana:8.16.1"

#           port { container_port = 5601 }

#           env {
#             name  = "ELASTICSEARCH_URL"
#             value = "http://elasticsearch.default.svc.cluster.local:9200"
#           }
#           env {
#             name  = "xpack.security.enrollment.enabled"
#             value = "true"
#           }

#           resources {
#             requests = {
#               cpu    = "500m"   # request 0.5 CPU
#               memory = "1Gi"    # request 1 GiB RAM
#             }
#             limits = {
#               cpu    = "1000m"  # cap at 1 CPU
#               memory = "2Gi"    # cap at 2 GiB RAM
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_deployment" "logstash" {
#   metadata {
#     name      = "logstash"
#     namespace = "default"
#     labels    = { app = "logstash" }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = { app = "logstash" }
#     }

#     template {
#       metadata { labels = { app = "logstash" } }

#       spec {
#         container {
#           name  = "logstash"
#           image = "docker.elastic.co/logstash/logstash:8.16.1"

#           port { container_port = 5044 }

#           resources {
#             requests = {
#               cpu    = "500m"   # request 0.5 CPU
#               memory = "1Gi"    # request 1 GiB RAM
#             }
#             limits = {
#               cpu    = "1000m"  # cap at 1 CPU
#               memory = "2Gi"    # cap at 2 GiB RAM
#             }
#           }
#         }
#       }
#     }
#   }
# }

# # Use loadbalancer to expose Elasticsearch, Kibana and Logstash with their respective ports ====================================================================================================
# resource "kubernetes_service" "elasticsearch" {
#   metadata {
#     name      = "elasticsearch"
#     namespace = "default"
#   }

#   spec {
#     type = "LoadBalancer"

#     selector = {
#       app = "elasticsearch"
#     }

#     port {
#       port        = 9200
#       target_port = 9200
#     }
#   }
# }

# resource "kubernetes_service" "kibana" {
#   metadata {
#     name      = "kibana"
#     namespace = "default"
#   }

#   spec {
#     type = "LoadBalancer"

#     selector = {
#       app = "kibana"
#     }

#     port {
#       port        = 5601
#       target_port = 5601
#     }
#   }
# }

# resource "null_resource" "set_subscription" {
#   provisioner "local-exec" {
#     command = "az account set --subscription ${var.subscription_id}"
#   }
# }

# resource "null_resource" "aks_get_credentials" {
#   provisioner "local-exec" {
#     command = "az aks get-credentials --resource-group ${data.azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.aks_cluster.name} --overwrite-existing"
#   }
#   depends_on = [azurerm_kubernetes_cluster.aks_cluster]
# }

# resource "null_resource" "wait_for_elasticsearch_pod" {
#   provisioner "local-exec" {
#     command = <<EOT
#     kubectl wait --for=condition=ready pod -n default -l app=elasticsearch-alt --timeout=1200s
#     EOT
#   }
#   depends_on = [kubernetes_deployment.elasticsearch2]
# }

# resource "null_resource" "wait_for_kibana_pod" {
#   depends_on = [kubernetes_deployment.kibana2]

#   provisioner "local-exec" {
#     command = <<EOT
#       kubectl wait --for=condition=ready pod -n default -l app=kibana-alt --timeout=1200s
#     EOT
#   }
# }

# data "external" "enrollment_token" {
#   program = ["bash", "${path.module}/elastic-enrollment-token.sh"]
#   depends_on = [null_resource.wait_for_elasticsearch_pod]
# }

# data "external" "elastic_password" {
#   program = ["bash", "${path.module}/elastic-password.sh"]
#   depends_on = [null_resource.wait_for_elasticsearch_pod]
# }

# data "external" "verification_code" {
#   program = ["bash", "${path.module}/kibana-verification-code.sh"]
#   depends_on = [null_resource.wait_for_kibana_pod]
# }

# output "enrollment_token" {
#   value = data.external.enrollment_token.result
# }
# output "elastic_password" {
#   value = data.external.elastic_password.result
# }

# output "verification_code" {
#   value = data.external.verification_code.result
# }

# # # ===================================================
# # # ELK Stack Infrastructure and Deployments (Appended)
# # # ===================================================

# # # Storage Account for Azure File
# # resource "azurerm_storage_account" "elk_storage" {
# #   name                     = "elkstorageaccttf"
# #   resource_group_name      = data.azurerm_resource_group.main.name
# #   location                 = data.azurerm_resource_group.main.location
# #   account_tier             = "Standard"
# #   account_replication_type = "LRS"
# # }

# # resource "azurerm_storage_share" "elk_share" {
# #   name                 = "elkshare"
# #   quota               = 50
# #   storage_account_id  = azurerm_storage_account.elk_storage.id
# # }

# # # Kubernetes Secret for Azure File
# # resource "kubernetes_secret" "elk_azure_file" {
# #   metadata {
# #     name      = "elk-azure-file-secret"
# #     namespace = "default"
# #   }

# #   data = {
# #     azurestorageaccountname = azurerm_storage_account.elk_storage.name
# #     azurestorageaccountkey  = azurerm_storage_account.elk_storage.primary_access_key
# #   }

# #   type = "Opaque"
# # }

# # # Persistent Volume
# # resource "kubernetes_persistent_volume" "elk_pv" {
# #   metadata {
# #     name = "elk-pv"
# #   }
# #   spec {
# #     capacity = {
# #       storage = "100Gi"
# #     }
# #     access_modes = ["ReadWriteMany"]
# #     persistent_volume_source {
# #       azure_file {
# #         secret_name  = kubernetes_secret.elk_azure_file.metadata[0].name
# #         share_name   = azurerm_storage_share.elk_share.name
# #         read_only    = false
# #       }
# #     }
# #   }
# # }

# # Persistent Volume Claim
# resource "kubernetes_persistent_volume_claim" "elk_pvc" {
#   metadata {
#     name = "elk-pvc"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     resources {
#       requests = {
#         storage = "100Gi"
#       }
#     }
#   }
# }

# # # Logstash ConfigMap
# # resource "kubernetes_manifest" "logstash_config" {
# #   depends_on = [azurerm_kubernetes_cluster.aks]
# #   manifest = {
# #     apiVersion = "v1"
# #     kind       = "ConfigMap"
# #     metadata = {
# #       name = "logstash-pipeline-config"
# #     }
# #     data = {
# #       "logstash.conf" = <<EOF
# # input {
# #   beats {
# #     port => 5044
# #   }
# # }
# # output {
# #   elasticsearch {
# #     hosts => ["http://elasticsearch:9200"]
# #     index => "logstash-%%{+YYYY.MM.dd}"
# #   }
# # }
# # EOF
# #     }
# #   }
# # }

# # # Elasticsearch Deployment
# # resource "kubernetes_manifest" "elasticsearch" {
# #   depends_on = [azurerm_kubernetes_cluster.aks]
# #   manifest = {
# #     apiVersion = "apps/v1"
# #     kind       = "Deployment"
# #     metadata = {
# #       name = "elasticsearch"
# #     }
# #     spec = {
# #       replicas = 1
# #       selector = {
# #         matchLabels = {
# #           app = "elasticsearch"
# #         }
# #       }
# #       template = {
# #         metadata = {
# #           labels = {
# #             app = "elasticsearch"
# #           }
# #         }
# #         spec = {
# #           containers = [{
# #             name  = "elasticsearch"
# #             image = "docker.elastic.co/elasticsearch/elasticsearch:8.7.0"
# #             ports = [{
# #               containerPort = 9200
# #             }]
# #             env = [{
# #               name  = "discovery.type"
# #               value = "single-node"
# #             }]
# #             volumeMounts = [{
# #               name      = "elasticsearch-storage"
# #               mountPath = "/usr/share/elasticsearch/data"
# #             }]
# #           }]
# #           volumes = [{
# #             name = "elasticsearch-storage"
# #             persistentVolumeClaim = {
# #               claimName = "elk-pvc"
# #             }
# #           }]
# #         }
# #       }
# #     }
# #   }
# # }

# # # Kibana Deployment
# # resource "kubernetes_manifest" "kibana" {
# #   depends_on = [azurerm_kubernetes_cluster.aks]
# #   manifest = {
# #     apiVersion = "apps/v1"
# #     kind       = "Deployment"
# #     metadata = {
# #       name = "kibana"
# #     }
# #     spec = {
# #       replicas = 1
# #       selector = {
# #         matchLabels = {
# #           app = "kibana"
# #         }
# #       }
# #       template = {
# #         metadata = {
# #           labels = {
# #             app = "kibana"
# #           }
# #         }
# #         spec = {
# #           containers = [{
# #             name  = "kibana"
# #             image = "docker.elastic.co/kibana/kibana:8.7.0"
# #             ports = [{
# #               containerPort = 5601
# #             }]
# #             env = [{
# #               name  = "ELASTICSEARCH_HOSTS"
# #               value = "http://elasticsearch:9200"
# #             }]
# #           }]
# #         }
# #       }
# #     }
# #   }
# # }

# # # Logstash Deployment
# # resource "kubernetes_manifest" "logstash" {
# #   depends_on = [azurerm_kubernetes_cluster.aks]
# #   manifest = {
# #     apiVersion = "apps/v1"
# #     kind       = "Deployment"
# #     metadata = {
# #       name = "logstash"
# #     }
# #     spec = {
# #       replicas = 1
# #       selector = {
# #         matchLabels = {
# #           app = "logstash"
# #         }
# #       }
# #       template = {
# #         metadata = {
# #           labels = {
# #             app = "logstash"
# #           }
# #         }
# #         spec = {
# #           containers = [{
# #             name  = "logstash"
# #             image = "docker.elastic.co/logstash/logstash:8.7.0"
# #             ports = [{
# #               containerPort = 5044
# #             }]
# #             volumeMounts = [
# #               {
# #                 name      = "logstash-storage"
# #                 mountPath = "/usr/share/logstash/data"
# #               },
# #               {
# #                 name      = "logstash-config"
# #                 mountPath = "/usr/share/logstash/pipeline"
# #               }
# #             ]
# #           }]
# #           volumes = [
# #             {
# #               name = "logstash-storage"
# #               persistentVolumeClaim = {
# #                 claimName = "elk-pvc"
# #               }
# #             },
# #             {
# #               name = "logstash-config"
# #               configMap = {
# #                 name = "logstash-pipeline-config"
# #               }
# #             }
# #           ]
# #         }
# #       }
# #     }
# #   }
# # }

# # ======================= ELK Stack Classic Kubernetes Resources ============================================================================

# resource "kubernetes_deployment" "elasticsearch2" {
#   metadata {
#     name   = "elasticsearch-alt"
#     labels = { app = "elasticsearch-alt" }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = { app = "elasticsearch-alt" }
#     }

#     template {
#       metadata { labels = { app = "elasticsearch-alt" } }

#       spec {
#         container {
#           name  = "elasticsearch"
#           image = "docker.elastic.co/elasticsearch/elasticsearch:8.7.0"

#           port { container_port = 9200 }

#           env {
#             name  = "discovery.type"
#             value = "single-node"
#           }

#           resources {
#             requests = {
#               cpu    = "1000m"
#               memory = "2Gi"
#             }
#             limits = {
#               cpu    = "2000m"
#               memory = "4Gi"
#             }
#           }

#           volume_mount {
#             name       = "elasticsearch-storage"
#             mount_path = "/usr/share/elasticsearch/data"
#           }
#         }

#         volume {
#           name = "elasticsearch-storage"
#           persistent_volume_claim {
#             claim_name = "elk-pvc"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_deployment" "kibana2" {
#   metadata {
#     name   = "kibana-alt"
#     labels = { app = "kibana-alt" }
#   }

#   spec {
#     replicas = 1

#      # ─── RollingUpdate strategy ──────────────────────────────────────────────
#     strategy {
#       type = "RollingUpdate"
#       rolling_update {
#         max_surge       = "25%"   # up to 25% extra pods
#         max_unavailable = "25%"   # allow 25% pods unavailable
#       }
#     }
#     progress_deadline_seconds = 600  # fail if not ready within 10 minutes

#     selector {
#       match_labels = { app = "kibana-alt" }
#     }

#     template {
#       metadata { labels = { app = "kibana-alt" } }

#       spec {
#         container {
#           name  = "kibana"
#           image = "docker.elastic.co/kibana/kibana:8.7.0"

#           port { container_port = 5601 }

#           env {
#             name  = "ELASTICSEARCH_HOSTS"
#             value = "http://elasticsearch-alt:9200"
#           }

#           resources {
#             requests = {
#               cpu    = "500m"
#               memory = "1Gi"
#             }
#             limits = {
#               cpu    = "1000m"
#               memory = "2Gi"
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_deployment" "logstash2" {
#   metadata {
#     name   = "logstash-alt"
#     labels = { app = "logstash-alt" }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = { app = "logstash-alt" }
#     }

#     template {
#       metadata { labels = { app = "logstash-alt" } }

#       spec {
#         container {
#           name  = "logstash"
#           image = "docker.elastic.co/logstash/logstash:8.7.0"

#           port { container_port = 5044 }

#           resources {
#             requests = {
#               cpu    = "500m"
#               memory = "1Gi"
#             }
#             limits = {
#               cpu    = "1000m"
#               memory = "2Gi"
#             }
#           }

#           volume_mount {
#             name       = "logstash-config"
#             mount_path = "/usr/share/logstash/pipeline"
#           }
#           volume_mount {
#             name       = "logstash-storage"
#             mount_path = "/usr/share/logstash/data"
#           }
#         }

#         volume {
#           name = "logstash-storage"
#           persistent_volume_claim {
#             claim_name = "elk-pvc"
#           }
#         }
#         volume {
#           name       = "logstash-config"
#           config_map {
#             name = kubernetes_config_map.logstash_config2.metadata[0].name
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "elasticsearch_alt" {
#   metadata {
#     name      = "elasticsearch-alt"
#     namespace = "default"
#   }

#   spec {
#     type = "ClusterIP"
#     selector = {
#       app = "elasticsearch-alt"
#     }

#     port {
#       port        = 9200
#       target_port = 9200
#     }
#   }
# }

# resource "kubernetes_service" "kibana_alt" {
#   metadata {
#     name      = "kibana-alt"
#     namespace = "default"
#   }

#   spec {
#     type = "ClusterIP"
#     selector = {
#       app = "kibana-alt"
#     }

#     port {
#       port        = 5601
#       target_port = 5601
#     }
#   }
# }

# resource "kubernetes_service" "logstash_alt" {
#   metadata {
#     name      = "logstash-alt"
#     namespace = "default"
#   }

#   spec {
#     type = "ClusterIP"
#     selector = {
#       app = "logstash-alt"
#     }

#     port {
#       port        = 5044
#       target_port = 5044
#     }
#   }
# }

# resource "kubernetes_config_map" "logstash_config2" {
#   metadata {
#     name = "logstash-pipeline-config"
#   }

#   data = {
#     "logstash.conf" = <<-EOT
#       input {
#         beats {
#           port => 5044
#         }
#       }

#       output {
#         elasticsearch {
#           hosts => ["http://elasticsearch-alt:9200"]
#           index => "logstash-%%{+YYYY.MM.dd}"
#         }
#       }
#     EOT
#   }
# }
























































# # {
# #   "version": 4,
# #   "terraform_version": "1.3.1",
# #   "serial": 19,
# #   "lineage": "b99ed367-6acc-6669-8b8e-6e1c7e3fb3eb",
# #   "outputs": {},
# #   "resources": [
# #     {
# #       "mode": "data",
# #       "type": "azurerm_kubernetes_cluster",
# #       "name": "aks_data",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "aci_connector_linux": null,
# #             "agent_pool_profile": [
# #               {
# #                 "auto_scaling_enabled": false,
# #                 "count": 1,
# #                 "max_count": 0,
# #                 "max_pods": 30,
# #                 "min_count": 0,
# #                 "name": "default",
# #                 "node_labels": {},
# #                 "node_public_ip_enabled": false,
# #                 "node_public_ip_prefix_id": "",
# #                 "node_taints": [],
# #                 "orchestrator_version": "1.31",
# #                 "os_disk_size_gb": 128,
# #                 "os_type": "Linux",
# #                 "tags": {},
# #                 "type": "VirtualMachineScaleSets",
# #                 "upgrade_settings": [
# #                   {
# #                     "drain_timeout_in_minutes": 0,
# #                     "max_surge": "10%",
# #                     "node_soak_duration_in_minutes": 0
# #                   }
# #                 ],
# #                 "vm_size": "Standard_DS2_v2",
# #                 "vnet_subnet_id": "",
# #                 "zones": []
# #               }
# #             ],
# #             "api_server_authorized_ip_ranges": [],
# #             "azure_active_directory_role_based_access_control": [],
# #             "azure_policy_enabled": null,
# #             "current_kubernetes_version": "1.31.7",
# #             "disk_encryption_set_id": "",
# #             "dns_prefix": "myaksdns",
# #             "fqdn": "myaksdns-19jcks3u.hcp.westeurope.azmk8s.io",
# #             "http_application_routing_enabled": null,
# #             "http_application_routing_zone_name": null,
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.ContainerService/managedClusters/my-aks-cluster",
# #             "identity": [
# #               {
# #                 "identity_ids": [],
# #                 "principal_id": "a86225ae-4313-4143-a23d-d98b5c7cff4f",
# #                 "tenant_id": "a9f4aef9-8df7-4cc3-99a8-e85824715025",
# #                 "type": "SystemAssigned"
# #               }
# #             ],
# #             "ingress_application_gateway": null,
# #             "key_management_service": [],
# #             "key_vault_secrets_provider": null,
# #             "kube_admin_config": [],
# #             "kube_admin_config_raw": "",
# #             "kube_config": [
# #               {
# #                 "client_certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZIVENDQXdXZ0F3SUJBZ0lRTmZKZ1lQeGJpMkJENHIwK0o5c1NHREFOQmdrcWhraUc5dzBCQVFzRkFEQU4KTVFzd0NRWURWUVFERXdKallUQWVGdzB5TlRBMU1UUXhNRFUzTURaYUZ3MHlOekExTVRReE1UQTNNRFphTURBeApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1SVXdFd1lEVlFRREV3eHRZWE4wWlhKamJHbGxiblF3CmdnSWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUNEd0F3Z2dJS0FvSUNBUUMrbm4rZmNGYngyZGJjRVV2SEhQTkEKZWcvZFFaKy8vZkU3L3kvcjlZRGRiWnhZcTVtOFdidytoTklPUUNUM2M1eklPeGJRME1rOXdSVHhxNjlaVHlTRgp4Q2NWL0xVaU9KS1BRWFBjcGQ5M2ZaeTY1Uzl1UXI1YXdla1BFUFI0ZnhkbVBQMi9zTCtPdlhkQlp6UU9rSWNqCnFMN1JNTm80NFU4STA3bXhrMEVEYXVtdDNPM3NJRmtNUmVIRW91Unl2VjZUOHI5aVB2eWNKakpZSWJQbEM1Y3IKWm5xM3hZelN4OVdDRk8venR5d0lSOXMxTFNjZFNHRHlyUmNEZSttYzYxL0c0L0prUnd4Z0dnU3pGRVVoSEE5dAoxU2V6V245V3VENnYvWUNKUVlsUjU0Z0pXcjh1TXJITGUwdlZad2tNa0I1eitTK1I2Q3ZSa2hMZHdiL0p1bWZTCnVRRjIvMW9tUTFDbm1wUjdpUzlyYk4wRzVtZGxJY245L3gzaTI0NnVuWWIxVnlRSmxFTk1VOHVIM2wxTXYzWkMKSGFLdDE5OWxGNkpIb0RSY0JjUVdEU1dhN1FMSTZKcGpqS2c1Mnp0QzlOSHFLTzFBVWNsMnE4NmR3dE5hWVlRRgpvNkg1NXJ2Q1NGc2F4RXdQUUZqajZnOUtTcjhXbzlGZmpwNHc1MzROSVdkemJsWHBOU0hyeVMvcG9kN1dnWHVrClVyN1FxOUNGb1l6SmZuVGVSMUUzTkZDODExYlc2L3ZRUEphVUgyNEJ2SXpUQlEzSGFqNFZTdXl5Zzc0OXRpSisKcGZtVVFiN3F3b1IwNmVkZEZlK1dUZHMwSXpkekdlVjBJVm80WmppU0JFanhUejRVSGZoUU1BeStPWVFlVUVhcwowUEpZVkxVYllPNVBDMS9sRzZPSlFRSURBUUFCbzFZd1ZEQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0V3WURWUjBsCkJBd3dDZ1lJS3dZQkJRVUhBd0l3REFZRFZSMFRBUUgvQkFJd0FEQWZCZ05WSFNNRUdEQVdnQlIzRG40UlNsNU4Kbkt0NjBuNXoxdCtRcnozem1EQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FnRUF6NGhyaUhhS0pDaUhhQW5JMWJUZwpPVHNmTit6YlNTdEx2cVBwZjhJcGZPQ0lJS0xRNFBJTkJCTzlqbi9IcjVDcnJXNlJwSWUxTEp6bW5tWUlxeUhyCkdObkdxZmFXMHVSMDBUaFpvY3R5UVRYMlBOZHhqY3F5SCtST1JncnV0TmRDKzFhZ29IeW5XYVYvdmU3V08rZGgKMVpCbTgwV1ZKMGVNL0F1RGN0MTBzYmFMRXpuZHRGTnpqN0QvQWVoeHZWYWUrcVNpa2sxOFdtY3FBRHAzRE1VOQppMmk4T1JaaU4ra094OXFVUktEVFo4bVR1L28wdmczUktvNXBjeEtLcDhyQ1BCakVkSEphU3BkL2tTWEdlOVlwCmlrcWJvcXFvUHlnbW5IUk1FeFZGTFRweFFWYXYvZWF4dDFDaWFWTmw1bTVXUXEwL2JTV1plazA4V1VVaGREbEgKNnZUSDJ3a0orL0srUmsxSDV6SlJVK3ZJaXpRcExyS2FtVFA0UEp4cmRWYVUyMkVzcTJycVBqOFlDVGhuVHBGMApWQzJNdlpVTS82L3pNaUJleFRXSlVHcjNNWHVjVW43ZHptRmoyTnFQVFl3Qloyb0kzTFhCcDV2dXp5ZEsyZ21VCnMzU0ZJNWx1eVl5U3ZGSmd3RTROa3dyVHFaK2I4YktUOGZwWDdSY0l3M3oxN0FCekxzSG1VSjl6Zzk5SXdqMHcKVW5PcUhNZnpESkFnN2xhbmQ1RzVQMHQ4N3Zqa3F5U2JHZHRxZEE4Tml0aUpGUDFVdzN2Q0ltNVovZmFNdEkzQwp1Y1R4ZDN6M2w4VWV4M2Y0Y0RSbmozVWNMMzFsbC9Gc1NWbWUrdFY3V2tUdXRieEd0bEF3UzFORGhtdHhRbVpQCnlQdWk0Vnh5QWhVeUsrTzZsRmZuWEE4PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
# #                 "client_key": "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBdnA1L24zQlc4ZG5XM0JGTHh4enpRSG9QM1VHZnYvM3hPLzh2Ni9XQTNXMmNXS3VaCnZGbThQb1RTRGtBazkzT2N5RHNXME5ESlBjRVU4YXV2V1U4a2hjUW5GZnkxSWppU2owRnozS1hmZDMyY3V1VXYKYmtLK1dzSHBEeEQwZUg4WFpqejl2N0MvanIxM1FXYzBEcENISTZpKzBURGFPT0ZQQ05PNXNaTkJBMnJwcmR6dAo3Q0JaREVYaHhLTGtjcjFlay9LL1lqNzhuQ1l5V0NHejVRdVhLMlo2dDhXTTBzZlZnaFR2ODdjc0NFZmJOUzBuCkhVaGc4cTBYQTN2cG5PdGZ4dVB5WkVjTVlCb0VzeFJGSVJ3UGJkVW5zMXAvVnJnK3IvMkFpVUdKVWVlSUNWcS8KTGpLeHkzdEwxV2NKREpBZWMva3ZrZWdyMFpJUzNjRy95YnBuMHJrQmR2OWFKa05RcDVxVWU0a3ZhMnpkQnVabgpaU0hKL2Y4ZDR0dU9ycDJHOVZja0NaUkRURlBMaDk1ZFRMOTJRaDJpcmRmZlpSZWlSNkEwWEFYRUZnMGxtdTBDCnlPaWFZNHlvT2RzN1F2VFI2aWp0UUZISmRxdk9uY0xUV21HRUJhT2grZWE3d2toYkdzUk1EMEJZNCtvUFNrcS8KRnFQUlg0NmVNT2QrRFNGbmMyNVY2VFVoNjhrdjZhSGUxb0Y3cEZLKzBLdlFoYUdNeVg1MDNrZFJOelJRdk5kVwoxdXY3MER5V2xCOXVBYnlNMHdVTngybytGVXJzc29PK1BiWWlmcVg1bEVHKzZzS0VkT25uWFJYdmxrM2JOQ00zCmN4bmxkQ0ZhT0dZNGtnUkk4VTgrRkIzNFVEQU12am1FSGxCR3JORHlXRlMxRzJEdVR3dGY1UnVqaVVFQ0F3RUEKQVFLQ0FnQWR6ZHg0aW5FZHVZak51ZXFXUkdHSVdFMTRzOVVOaU9BYUdHbGV4SEVVcmhtL0IzMnZKSHk1YmIwRwpPMk5NU1loZkNsWWo2akU4OVo2WHR0ZGc2RzMyZUZnQUtSWU5Ocms3cXVrNXU3bTREaXplVUExZGVSUVlUcTlwCkNxYWUzSWhGRlE0NzFaL3Q2cFBsNXdRTnJ1MWlWdlVXOGtOOGwwWHJSR2VKYTFQRC9BaHpoZEt4azlFNGlRaW0KM1MxSS8zRDFRd1JIa1QrZ0RwemFpTkorNHBRTlZpV2o3RUI3aUlGS3FJbG9HdURJbnF1WW9lbTJ1MlZsTEVrbgo0MDBBbXhETG9VSjZDVjNXL05wMVFac1pkVEM0WkphamhXZlpvRTgwNXpjY3Z1R0FxK25xUklVVjdSazlqcGFwCjFFVm04SFhDZmxqQXdJTnhiaHlERGRNMThHNWhFQ3h3K0VSMjRXVVpaNVFnamRGMUJrMFBHRDRJd25FRTJBd2oKbFRYMFpqUmdZWnNNZGpNYis2R3dlRnVsR0puczlQNE14bVdGUjNibUhidXRKSFNQb1p6Znd6Q1pQdU5xVlBGZApmcGVZSkhQaFNvN3NIbkJwZURZRFhrdEhIOHV3RnNCT04wTC9JY01GZmdJUWovKzdZYlJVb3U1NWJRYy9YUHY2CjJvVlRIM1hGZlhlR0RrTlFpYU9KcWpRY1NCYWVyUE1kSU91WkhmLzJmNTBpdnVBUEx3WFU5NXRSVHF2YmI3cWkKU0xBMVBCdS9QVHdybXNBUk1QcFRab0V4cUh1ck1IaXVLOGp1aEZRY21OMEJZWDRIUGRjNU5pVzlqSXdjeFVrbQpKaUtxVG05bVFEMEFGWUMzUTU4ODZkT09SSnlsMjViTy93NnpFcTBNMEdYWWZENlcwUUtDQVFFQTVEazFZN3U0CmlFUWUzVE1xOE9GZkxxYVhlNGpoVWdLSHMvcFRVd1RBZHN1Y3QvSVZ6UXBLckRmN1JMT0pLQXV4TFROMHNnbW8KdlVWVGpkWFY2RVpjSW9nS1BIcWhtdTk3SllRbWVrQWUxM2Y5c0E0c0RkR1lxRXk4MHFJOElyR1FUK1RLZ3RYSApITjVoVGdud2RSeEc3TndIUVQxSVFFazFYTlBGYXd4VkVPcEh2SjZrSGxIVzlXUGNZK29CdHdyQjBSQVRRMUpuClVlb2lFR2R1MXRUUkdzTmFtak9YaHdpblRSVHI0clRSd05jOFoxaklRQlNidmh0TXAvNjh6cWlVNGRPUkwrSHgKeFh6dTlBNmt0a0JGUXNjeDZRaTlaNHNvVzhYTzU1ejlBWTlYTWZJK0hXSGxiMjkxbzJ0NzBSS3c3YXpnQ3NySApxeXJJd25mOVVtZld0UUtDQVFFQTFkR2xjbWxDNDNKay8wdjU0VzM2M0djRVloSnQ2aXFwZ2NDRE82Y2xJbjJHCkYxb3NUdkROSHpwT3hDNWpFNGZvTzBoN0JFQWZBc3NqZVRxbXlpRnBoRjlzWE9GSUhtaU1OUHVYcWhxVGd5ZjIKMnFZemZERUh5MmliUU5JU21mMU9rVS9pdW52ZWE2b2NzWUQ4OE1EMmw0YmxhMm1RVi9rVDdjMjR2dXRZUXFIZgpNTWRZaC9ub1lrWFYvSHRUdjhBdnZWSnpkVGM5ckxoQWRmc3dWUTgvT1c0YStnQmZwY2JETnlmZVJHZmxHZjAwCnFKQjV5R2w3aGNqclVrYjA5VHZRVklESXJFNFdkalN4dXlXSlhsTldDd3FqaUdGVkxqT1c2UlVjL1dBdnh2K0oKZkNBSVo3OCtzdllQT1ZLcTc5cG9qcnpNZGFTZkV2alRhNzJXVnVqVDNRS0NBUUFiUnY4cm1XODMwalNDS2JCegpNK3lsYmNIalFQdjFTbG9mMThhSHdLU2tUamZBQUk0OGdJTm1UQmFiSW40OUxCQ1VIM2RPSkR0bnk5WnR1R1lsCnFlc3ZNV1ZQenpScmlUNEZ3T0s4YjlkLzExYVo2VWU0cXhsODNCY2hjY1NRUFByTG9jUFdtV2gvK2RCVmZIaWgKOXF3L2VSamc0a3MxYThxVityVzQwck9FSHd4TjdnUWRuNWg2b2VIZ2kwS0ROeVR0TU9lc2Z6ZmNJWWpLdnlJUApTVVpvMVhxSnZhclp0OTRQSjNYK0ZiQ1FST2x5VExrNmQzd1ozN2RzeU5TV09xMzR3OG14bUdiR1BPVnVoQ1dKCnB1cmdUV0NZd3JPb29ZaEVWOE1nQ2JKdnNrc3dyQXhpaEtYZ2lNamRyR1lUR2hITmhvRU1xU251T21IZVpHc0IKbzJtVkFvSUJBUURINjU2elRDSmpnZ2xXLzFYajVxNUJOLzFNS1lrbUFyKzg5eUI5UFRvbWRwRlM4bGd0YzArSApYRUJiaERmVkFpVXNrUWVjb011ZUZBdldCUFlBVnA5UFN0MktOb1gxRUxIUHRGSkpsVkhKdHl0RG8xVE9VUlhGCnBjaE1JbCtNSmVFNVV5VmVVZ1ZVUzVsS2lwMTJDaVpHNWJWSzZrZ3hTVTNOOHFWRHRjOHZkaVMyZWgyWC9oMi8KRFNjWVRNT3dyV1Mxc3dzTFZSeFFpM0tTSGN4Q0srQmt0VU41NzdGKzBrcWpIcDdlL1Bta2hEQ2hUM3plMjJuSQpYR1ZTNTgrUUlGNFpOTlRzN3BKbjhic2dqZWRVRDcySzAyYTJWTE9OWUdWQkNDR3o4eVNZLzBNd2tNN3JHbERvCmlkTVFPUEJsRmFUZm1UM2UzWTV5OGI3VXBVNlZjbHJ0QW9JQkFRQ2QwMmZuaU9maEdWR1VJWk9pckJ0Q0g0dFUKb0Q1ZVltVjlnNGt2dWNnWDV3TS9nWkx0bXBIRDJ3S21lUnpSSXFqTEZqNXlIbFpYZ2xkSzdtY0N2aE85aGNLWgp1QUcwZkFxTFpNWENiRnQ1VE5sVTY2c001K1Q5L1hPU001YnkzRDc3MXRqb2JGTjdKV2dSeVlqZnRJQUpYQUJNCitXYXJVdGRZeDJaVHFiSTltNk4xSktHbVJVTlgyd01laE1sWGEvUVYwNWxoR1FiMTh3aFM5RTFlL2hlNnpKMFEKVzR5ZDZIZURlRUxwTCtid01YRkppWVp3S2NmanM2bTNpVXI5L3hoY3kxWmN0UnNvb2d0R1NVSGM4VEVaZ2YxYgpnVFNDckZ4ZVZJdDEvWkNFajAvZVBYT0Vrd3lpWjNoTmlvM2xoMFVncmFscGZVU2U5enhGR2J5SllIODQKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K",
# #                 "cluster_ca_certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUU2VENDQXRHZ0F3SUJBZ0lSQVBMdXlBNTllUnZkSFZLb2F2K0pyWjB3RFFZSktvWklodmNOQVFFTEJRQXcKRFRFTE1Ba0dBMVVFQXhNQ1kyRXdJQmNOTWpVd05URTBNVEExTnpBMldoZ1BNakExTlRBMU1UUXhNVEEzTURaYQpNQTB4Q3pBSkJnTlZCQU1UQW1OaE1JSUNJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBZzhBTUlJQ0NnS0NBZ0VBCjF0ZU5yeGNlQzRwUEtNUTE4cDNOZ3VaUVRlS2xSeGdvdFJjSTNkZVF1bjd5ZDR1L05JWDNubFNRTmN0MDBESk8KeTN0M21pSzVyMzZCbTZVbWFDQ3hTbHRHU3BGS0FWYVlLUEdabXUrVm1EbHZYcWVjYlhoY2xZM2x1WUI0Ynd0YgpEZS9KWnIxWFpyY3F1K0lKUEdaY1FwQ3UzZTd3ZjVwMEs1Y1JsbmNtQ3Z6K08zK1o5U2J6Z1JEeHhDWmZhRzBJCnNqYmcwUzg0RXVTQkJGbEJScG1vMVp6SFhnVWR2bHg2Q1NXZ2txeFRYaGlBU0tTVldveWlzODh6WVU4MGp0ckwKU3JzZmNoK3JDbXA3WFp0MnNXRDdNYlhIQXhqNFpJVWdqK3VhaS9EQmdhN3o1bHdWTmhUMG92eHBoMncyRUs0TQpKcmU2dWZsMzEwQllsYS9UbG5mUUpUczVuRkhWSlErdlVjOHVOZWNIdWI3MFc3cnBYY09rWW5oeTN5Vk1xZy9DCnoxMVZ0SVpUdzhuc251UGJRT051SVpobk1yVDU3UFhXZmQrV2tBa2N4WDd0NlM3Wm9iTkFhOEFHQUlqZVkzNE8KZ1hONTlpek5lMDVHOUpxaTZpL2x1Tjc2M3ZQYUtDQmlnRDN3QUN6bXl1TXRENWJmQTdKd0JxOFhBT2drRllYUAoxbmduTmRkNWN0NC83MTlIZUJmeisxd20yczdXTEtJOFdBYlQ2RVptaUZheWp4Q0dmcmdMQjBhMUNLOWN3QVlvCmQ0WGpmRVVhQ0tLNkxURzFsRHprVUdDZjRETWJuV2pvcExMalNuaXlOR2lCS0JYcy9VOVA1UFd0aGRaaWdGM2UKZ3VzQUdsbEJDckFXU2VFMkVSSVVuYzV5WUdDanZWdEVaVHQrc1JJaXBYc0NBd0VBQWFOQ01FQXdEZ1lEVlIwUApBUUgvQkFRREFnS2tNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdIUVlEVlIwT0JCWUVGSGNPZmhGS1hrMmNxM3JTCmZuUFczNUN2UGZPWU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQ0FRQjZVZkRyRXg0UVdyYzNHazNTUjRKRHJLUXEKam1pSWlIYS9SOUkrb3c1Y2c4cWxRenM1dG9Pb0oxc1BBTUx5Sm9rbW8yQ0ZlOTF2SkVnN0Qyd3RLOHhCb3RyNwpXWDdNWktFeDhmVnJXYTlrMDhSVHpmMk8vL2JaN01lSk1VeFJXajJSSGdoQ0JXVlc2SWVVdFpER0RqK1lWeFZWCnR4cm5PWkN6QlQ3bmJmUy9xTURWWjVNVHlsR3JRcFJQMnpuejBZTzNsK1dYNFdNc2pKN0VFUElLMEdEczhsck0KSlJSbFlkR1FUZi9vNXlPamtFbVdTMklYY09lUmFaaS8wdVJhZUdkOWhGREY1RVlzUFZwSXJBdlIyWHlzY3Y4aApPVzh3YWpZa2hRSnB6aHlNTTByMGliQXYxeUVvYXVTSzREOHY0NkFBU0FvVGthQ0M5d3hBQlBFRmZuVTQzS2xxCmhvN09MMU8yS1RUcEt0Y3Z6aURzc3lXZFZFSmFMQ2tSM1k2Vzltc0RNRnlNODRnMjJKd0RUa2h1ZEZDWUcrMG4KZWx2dXB1SDFhRHhsaFBlRTM4eWxQOU03TGdsM3crMXAwMXN6TTZzQmFBUjYvNjk1SWxzYmZDZUFrNmRKZkNxcgpWZlVmdDJlVEJFdkRKT2ZIWGZRaCtsQzQyV0pqc0ZoZDhSTGVLU09YSDlZUzRTU0syNnBIS2ZnTTNiVkJVdzh2CjRwWjB6a2lTak1jMll0U2pmSUdYUlE3Z2E3QzdwYW1Cb2NBZTB6YUxoaHg5SXBCUmdMNXIrd0lIblRFNHlIeloKQUc0cVpLS0ZJODRMRzJLb1BoaHRiWFpXTTZWNXRyZHBlWjFrQjZNU1FhV0k3Sml0VFkxanAwTXc0TG9UY3J5aApTbW4rZURTL2xuSjJ4TnRzeEE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
# #                 "host": "https://myaksdns-19jcks3u.hcp.westeurope.azmk8s.io:443",
# #                 "password": "9bs427dr3sb52f9lrhnf7z1fxw6fwaooyu46s984hg56x0dc67w5zxkw57ws3mapf7no2bqdizglu8g7bje9kutago94waidohfu6m7lm63htnug6dl22tquy92agvou",
# #                 "username": "clusterUser_Dataplatform-Group-Monitoring_my-aks-cluster"
# #               }
# #             ],
# #             "kube_config_raw": "apiVersion: v1\nclusters:\n- cluster:\n    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUU2VENDQXRHZ0F3SUJBZ0lSQVBMdXlBNTllUnZkSFZLb2F2K0pyWjB3RFFZSktvWklodmNOQVFFTEJRQXcKRFRFTE1Ba0dBMVVFQXhNQ1kyRXdJQmNOTWpVd05URTBNVEExTnpBMldoZ1BNakExTlRBMU1UUXhNVEEzTURaYQpNQTB4Q3pBSkJnTlZCQU1UQW1OaE1JSUNJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBZzhBTUlJQ0NnS0NBZ0VBCjF0ZU5yeGNlQzRwUEtNUTE4cDNOZ3VaUVRlS2xSeGdvdFJjSTNkZVF1bjd5ZDR1L05JWDNubFNRTmN0MDBESk8KeTN0M21pSzVyMzZCbTZVbWFDQ3hTbHRHU3BGS0FWYVlLUEdabXUrVm1EbHZYcWVjYlhoY2xZM2x1WUI0Ynd0YgpEZS9KWnIxWFpyY3F1K0lKUEdaY1FwQ3UzZTd3ZjVwMEs1Y1JsbmNtQ3Z6K08zK1o5U2J6Z1JEeHhDWmZhRzBJCnNqYmcwUzg0RXVTQkJGbEJScG1vMVp6SFhnVWR2bHg2Q1NXZ2txeFRYaGlBU0tTVldveWlzODh6WVU4MGp0ckwKU3JzZmNoK3JDbXA3WFp0MnNXRDdNYlhIQXhqNFpJVWdqK3VhaS9EQmdhN3o1bHdWTmhUMG92eHBoMncyRUs0TQpKcmU2dWZsMzEwQllsYS9UbG5mUUpUczVuRkhWSlErdlVjOHVOZWNIdWI3MFc3cnBYY09rWW5oeTN5Vk1xZy9DCnoxMVZ0SVpUdzhuc251UGJRT051SVpobk1yVDU3UFhXZmQrV2tBa2N4WDd0NlM3Wm9iTkFhOEFHQUlqZVkzNE8KZ1hONTlpek5lMDVHOUpxaTZpL2x1Tjc2M3ZQYUtDQmlnRDN3QUN6bXl1TXRENWJmQTdKd0JxOFhBT2drRllYUAoxbmduTmRkNWN0NC83MTlIZUJmeisxd20yczdXTEtJOFdBYlQ2RVptaUZheWp4Q0dmcmdMQjBhMUNLOWN3QVlvCmQ0WGpmRVVhQ0tLNkxURzFsRHprVUdDZjRETWJuV2pvcExMalNuaXlOR2lCS0JYcy9VOVA1UFd0aGRaaWdGM2UKZ3VzQUdsbEJDckFXU2VFMkVSSVVuYzV5WUdDanZWdEVaVHQrc1JJaXBYc0NBd0VBQWFOQ01FQXdEZ1lEVlIwUApBUUgvQkFRREFnS2tNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdIUVlEVlIwT0JCWUVGSGNPZmhGS1hrMmNxM3JTCmZuUFczNUN2UGZPWU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQ0FRQjZVZkRyRXg0UVdyYzNHazNTUjRKRHJLUXEKam1pSWlIYS9SOUkrb3c1Y2c4cWxRenM1dG9Pb0oxc1BBTUx5Sm9rbW8yQ0ZlOTF2SkVnN0Qyd3RLOHhCb3RyNwpXWDdNWktFeDhmVnJXYTlrMDhSVHpmMk8vL2JaN01lSk1VeFJXajJSSGdoQ0JXVlc2SWVVdFpER0RqK1lWeFZWCnR4cm5PWkN6QlQ3bmJmUy9xTURWWjVNVHlsR3JRcFJQMnpuejBZTzNsK1dYNFdNc2pKN0VFUElLMEdEczhsck0KSlJSbFlkR1FUZi9vNXlPamtFbVdTMklYY09lUmFaaS8wdVJhZUdkOWhGREY1RVlzUFZwSXJBdlIyWHlzY3Y4aApPVzh3YWpZa2hRSnB6aHlNTTByMGliQXYxeUVvYXVTSzREOHY0NkFBU0FvVGthQ0M5d3hBQlBFRmZuVTQzS2xxCmhvN09MMU8yS1RUcEt0Y3Z6aURzc3lXZFZFSmFMQ2tSM1k2Vzltc0RNRnlNODRnMjJKd0RUa2h1ZEZDWUcrMG4KZWx2dXB1SDFhRHhsaFBlRTM4eWxQOU03TGdsM3crMXAwMXN6TTZzQmFBUjYvNjk1SWxzYmZDZUFrNmRKZkNxcgpWZlVmdDJlVEJFdkRKT2ZIWGZRaCtsQzQyV0pqc0ZoZDhSTGVLU09YSDlZUzRTU0syNnBIS2ZnTTNiVkJVdzh2CjRwWjB6a2lTak1jMll0U2pmSUdYUlE3Z2E3QzdwYW1Cb2NBZTB6YUxoaHg5SXBCUmdMNXIrd0lIblRFNHlIeloKQUc0cVpLS0ZJODRMRzJLb1BoaHRiWFpXTTZWNXRyZHBlWjFrQjZNU1FhV0k3Sml0VFkxanAwTXc0TG9UY3J5aApTbW4rZURTL2xuSjJ4TnRzeEE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==\n    server: https://myaksdns-19jcks3u.hcp.westeurope.azmk8s.io:443\n  name: my-aks-cluster\ncontexts:\n- context:\n    cluster: my-aks-cluster\n    user: clusterUser_Dataplatform-Group-Monitoring_my-aks-cluster\n  name: my-aks-cluster\ncurrent-context: my-aks-cluster\nkind: Config\npreferences: {}\nusers:\n- name: clusterUser_Dataplatform-Group-Monitoring_my-aks-cluster\n  user:\n    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZIVENDQXdXZ0F3SUJBZ0lRTmZKZ1lQeGJpMkJENHIwK0o5c1NHREFOQmdrcWhraUc5dzBCQVFzRkFEQU4KTVFzd0NRWURWUVFERXdKallUQWVGdzB5TlRBMU1UUXhNRFUzTURaYUZ3MHlOekExTVRReE1UQTNNRFphTURBeApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1SVXdFd1lEVlFRREV3eHRZWE4wWlhKamJHbGxiblF3CmdnSWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUNEd0F3Z2dJS0FvSUNBUUMrbm4rZmNGYngyZGJjRVV2SEhQTkEKZWcvZFFaKy8vZkU3L3kvcjlZRGRiWnhZcTVtOFdidytoTklPUUNUM2M1eklPeGJRME1rOXdSVHhxNjlaVHlTRgp4Q2NWL0xVaU9KS1BRWFBjcGQ5M2ZaeTY1Uzl1UXI1YXdla1BFUFI0ZnhkbVBQMi9zTCtPdlhkQlp6UU9rSWNqCnFMN1JNTm80NFU4STA3bXhrMEVEYXVtdDNPM3NJRmtNUmVIRW91Unl2VjZUOHI5aVB2eWNKakpZSWJQbEM1Y3IKWm5xM3hZelN4OVdDRk8venR5d0lSOXMxTFNjZFNHRHlyUmNEZSttYzYxL0c0L0prUnd4Z0dnU3pGRVVoSEE5dAoxU2V6V245V3VENnYvWUNKUVlsUjU0Z0pXcjh1TXJITGUwdlZad2tNa0I1eitTK1I2Q3ZSa2hMZHdiL0p1bWZTCnVRRjIvMW9tUTFDbm1wUjdpUzlyYk4wRzVtZGxJY245L3gzaTI0NnVuWWIxVnlRSmxFTk1VOHVIM2wxTXYzWkMKSGFLdDE5OWxGNkpIb0RSY0JjUVdEU1dhN1FMSTZKcGpqS2c1Mnp0QzlOSHFLTzFBVWNsMnE4NmR3dE5hWVlRRgpvNkg1NXJ2Q1NGc2F4RXdQUUZqajZnOUtTcjhXbzlGZmpwNHc1MzROSVdkemJsWHBOU0hyeVMvcG9kN1dnWHVrClVyN1FxOUNGb1l6SmZuVGVSMUUzTkZDODExYlc2L3ZRUEphVUgyNEJ2SXpUQlEzSGFqNFZTdXl5Zzc0OXRpSisKcGZtVVFiN3F3b1IwNmVkZEZlK1dUZHMwSXpkekdlVjBJVm80WmppU0JFanhUejRVSGZoUU1BeStPWVFlVUVhcwowUEpZVkxVYllPNVBDMS9sRzZPSlFRSURBUUFCbzFZd1ZEQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0V3WURWUjBsCkJBd3dDZ1lJS3dZQkJRVUhBd0l3REFZRFZSMFRBUUgvQkFJd0FEQWZCZ05WSFNNRUdEQVdnQlIzRG40UlNsNU4Kbkt0NjBuNXoxdCtRcnozem1EQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FnRUF6NGhyaUhhS0pDaUhhQW5JMWJUZwpPVHNmTit6YlNTdEx2cVBwZjhJcGZPQ0lJS0xRNFBJTkJCTzlqbi9IcjVDcnJXNlJwSWUxTEp6bW5tWUlxeUhyCkdObkdxZmFXMHVSMDBUaFpvY3R5UVRYMlBOZHhqY3F5SCtST1JncnV0TmRDKzFhZ29IeW5XYVYvdmU3V08rZGgKMVpCbTgwV1ZKMGVNL0F1RGN0MTBzYmFMRXpuZHRGTnpqN0QvQWVoeHZWYWUrcVNpa2sxOFdtY3FBRHAzRE1VOQppMmk4T1JaaU4ra094OXFVUktEVFo4bVR1L28wdmczUktvNXBjeEtLcDhyQ1BCakVkSEphU3BkL2tTWEdlOVlwCmlrcWJvcXFvUHlnbW5IUk1FeFZGTFRweFFWYXYvZWF4dDFDaWFWTmw1bTVXUXEwL2JTV1plazA4V1VVaGREbEgKNnZUSDJ3a0orL0srUmsxSDV6SlJVK3ZJaXpRcExyS2FtVFA0UEp4cmRWYVUyMkVzcTJycVBqOFlDVGhuVHBGMApWQzJNdlpVTS82L3pNaUJleFRXSlVHcjNNWHVjVW43ZHptRmoyTnFQVFl3Qloyb0kzTFhCcDV2dXp5ZEsyZ21VCnMzU0ZJNWx1eVl5U3ZGSmd3RTROa3dyVHFaK2I4YktUOGZwWDdSY0l3M3oxN0FCekxzSG1VSjl6Zzk5SXdqMHcKVW5PcUhNZnpESkFnN2xhbmQ1RzVQMHQ4N3Zqa3F5U2JHZHRxZEE4Tml0aUpGUDFVdzN2Q0ltNVovZmFNdEkzQwp1Y1R4ZDN6M2w4VWV4M2Y0Y0RSbmozVWNMMzFsbC9Gc1NWbWUrdFY3V2tUdXRieEd0bEF3UzFORGhtdHhRbVpQCnlQdWk0Vnh5QWhVeUsrTzZsRmZuWEE4PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==\n    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBdnA1L24zQlc4ZG5XM0JGTHh4enpRSG9QM1VHZnYvM3hPLzh2Ni9XQTNXMmNXS3VaCnZGbThQb1RTRGtBazkzT2N5RHNXME5ESlBjRVU4YXV2V1U4a2hjUW5GZnkxSWppU2owRnozS1hmZDMyY3V1VXYKYmtLK1dzSHBEeEQwZUg4WFpqejl2N0MvanIxM1FXYzBEcENISTZpKzBURGFPT0ZQQ05PNXNaTkJBMnJwcmR6dAo3Q0JaREVYaHhLTGtjcjFlay9LL1lqNzhuQ1l5V0NHejVRdVhLMlo2dDhXTTBzZlZnaFR2ODdjc0NFZmJOUzBuCkhVaGc4cTBYQTN2cG5PdGZ4dVB5WkVjTVlCb0VzeFJGSVJ3UGJkVW5zMXAvVnJnK3IvMkFpVUdKVWVlSUNWcS8KTGpLeHkzdEwxV2NKREpBZWMva3ZrZWdyMFpJUzNjRy95YnBuMHJrQmR2OWFKa05RcDVxVWU0a3ZhMnpkQnVabgpaU0hKL2Y4ZDR0dU9ycDJHOVZja0NaUkRURlBMaDk1ZFRMOTJRaDJpcmRmZlpSZWlSNkEwWEFYRUZnMGxtdTBDCnlPaWFZNHlvT2RzN1F2VFI2aWp0UUZISmRxdk9uY0xUV21HRUJhT2grZWE3d2toYkdzUk1EMEJZNCtvUFNrcS8KRnFQUlg0NmVNT2QrRFNGbmMyNVY2VFVoNjhrdjZhSGUxb0Y3cEZLKzBLdlFoYUdNeVg1MDNrZFJOelJRdk5kVwoxdXY3MER5V2xCOXVBYnlNMHdVTngybytGVXJzc29PK1BiWWlmcVg1bEVHKzZzS0VkT25uWFJYdmxrM2JOQ00zCmN4bmxkQ0ZhT0dZNGtnUkk4VTgrRkIzNFVEQU12am1FSGxCR3JORHlXRlMxRzJEdVR3dGY1UnVqaVVFQ0F3RUEKQVFLQ0FnQWR6ZHg0aW5FZHVZak51ZXFXUkdHSVdFMTRzOVVOaU9BYUdHbGV4SEVVcmhtL0IzMnZKSHk1YmIwRwpPMk5NU1loZkNsWWo2akU4OVo2WHR0ZGc2RzMyZUZnQUtSWU5Ocms3cXVrNXU3bTREaXplVUExZGVSUVlUcTlwCkNxYWUzSWhGRlE0NzFaL3Q2cFBsNXdRTnJ1MWlWdlVXOGtOOGwwWHJSR2VKYTFQRC9BaHpoZEt4azlFNGlRaW0KM1MxSS8zRDFRd1JIa1QrZ0RwemFpTkorNHBRTlZpV2o3RUI3aUlGS3FJbG9HdURJbnF1WW9lbTJ1MlZsTEVrbgo0MDBBbXhETG9VSjZDVjNXL05wMVFac1pkVEM0WkphamhXZlpvRTgwNXpjY3Z1R0FxK25xUklVVjdSazlqcGFwCjFFVm04SFhDZmxqQXdJTnhiaHlERGRNMThHNWhFQ3h3K0VSMjRXVVpaNVFnamRGMUJrMFBHRDRJd25FRTJBd2oKbFRYMFpqUmdZWnNNZGpNYis2R3dlRnVsR0puczlQNE14bVdGUjNibUhidXRKSFNQb1p6Znd6Q1pQdU5xVlBGZApmcGVZSkhQaFNvN3NIbkJwZURZRFhrdEhIOHV3RnNCT04wTC9JY01GZmdJUWovKzdZYlJVb3U1NWJRYy9YUHY2CjJvVlRIM1hGZlhlR0RrTlFpYU9KcWpRY1NCYWVyUE1kSU91WkhmLzJmNTBpdnVBUEx3WFU5NXRSVHF2YmI3cWkKU0xBMVBCdS9QVHdybXNBUk1QcFRab0V4cUh1ck1IaXVLOGp1aEZRY21OMEJZWDRIUGRjNU5pVzlqSXdjeFVrbQpKaUtxVG05bVFEMEFGWUMzUTU4ODZkT09SSnlsMjViTy93NnpFcTBNMEdYWWZENlcwUUtDQVFFQTVEazFZN3U0CmlFUWUzVE1xOE9GZkxxYVhlNGpoVWdLSHMvcFRVd1RBZHN1Y3QvSVZ6UXBLckRmN1JMT0pLQXV4TFROMHNnbW8KdlVWVGpkWFY2RVpjSW9nS1BIcWhtdTk3SllRbWVrQWUxM2Y5c0E0c0RkR1lxRXk4MHFJOElyR1FUK1RLZ3RYSApITjVoVGdud2RSeEc3TndIUVQxSVFFazFYTlBGYXd4VkVPcEh2SjZrSGxIVzlXUGNZK29CdHdyQjBSQVRRMUpuClVlb2lFR2R1MXRUUkdzTmFtak9YaHdpblRSVHI0clRSd05jOFoxaklRQlNidmh0TXAvNjh6cWlVNGRPUkwrSHgKeFh6dTlBNmt0a0JGUXNjeDZRaTlaNHNvVzhYTzU1ejlBWTlYTWZJK0hXSGxiMjkxbzJ0NzBSS3c3YXpnQ3NySApxeXJJd25mOVVtZld0UUtDQVFFQTFkR2xjbWxDNDNKay8wdjU0VzM2M0djRVloSnQ2aXFwZ2NDRE82Y2xJbjJHCkYxb3NUdkROSHpwT3hDNWpFNGZvTzBoN0JFQWZBc3NqZVRxbXlpRnBoRjlzWE9GSUhtaU1OUHVYcWhxVGd5ZjIKMnFZemZERUh5MmliUU5JU21mMU9rVS9pdW52ZWE2b2NzWUQ4OE1EMmw0YmxhMm1RVi9rVDdjMjR2dXRZUXFIZgpNTWRZaC9ub1lrWFYvSHRUdjhBdnZWSnpkVGM5ckxoQWRmc3dWUTgvT1c0YStnQmZwY2JETnlmZVJHZmxHZjAwCnFKQjV5R2w3aGNqclVrYjA5VHZRVklESXJFNFdkalN4dXlXSlhsTldDd3FqaUdGVkxqT1c2UlVjL1dBdnh2K0oKZkNBSVo3OCtzdllQT1ZLcTc5cG9qcnpNZGFTZkV2alRhNzJXVnVqVDNRS0NBUUFiUnY4cm1XODMwalNDS2JCegpNK3lsYmNIalFQdjFTbG9mMThhSHdLU2tUamZBQUk0OGdJTm1UQmFiSW40OUxCQ1VIM2RPSkR0bnk5WnR1R1lsCnFlc3ZNV1ZQenpScmlUNEZ3T0s4YjlkLzExYVo2VWU0cXhsODNCY2hjY1NRUFByTG9jUFdtV2gvK2RCVmZIaWgKOXF3L2VSamc0a3MxYThxVityVzQwck9FSHd4TjdnUWRuNWg2b2VIZ2kwS0ROeVR0TU9lc2Z6ZmNJWWpLdnlJUApTVVpvMVhxSnZhclp0OTRQSjNYK0ZiQ1FST2x5VExrNmQzd1ozN2RzeU5TV09xMzR3OG14bUdiR1BPVnVoQ1dKCnB1cmdUV0NZd3JPb29ZaEVWOE1nQ2JKdnNrc3dyQXhpaEtYZ2lNamRyR1lUR2hITmhvRU1xU251T21IZVpHc0IKbzJtVkFvSUJBUURINjU2elRDSmpnZ2xXLzFYajVxNUJOLzFNS1lrbUFyKzg5eUI5UFRvbWRwRlM4bGd0YzArSApYRUJiaERmVkFpVXNrUWVjb011ZUZBdldCUFlBVnA5UFN0MktOb1gxRUxIUHRGSkpsVkhKdHl0RG8xVE9VUlhGCnBjaE1JbCtNSmVFNVV5VmVVZ1ZVUzVsS2lwMTJDaVpHNWJWSzZrZ3hTVTNOOHFWRHRjOHZkaVMyZWgyWC9oMi8KRFNjWVRNT3dyV1Mxc3dzTFZSeFFpM0tTSGN4Q0srQmt0VU41NzdGKzBrcWpIcDdlL1Bta2hEQ2hUM3plMjJuSQpYR1ZTNTgrUUlGNFpOTlRzN3BKbjhic2dqZWRVRDcySzAyYTJWTE9OWUdWQkNDR3o4eVNZLzBNd2tNN3JHbERvCmlkTVFPUEJsRmFUZm1UM2UzWTV5OGI3VXBVNlZjbHJ0QW9JQkFRQ2QwMmZuaU9maEdWR1VJWk9pckJ0Q0g0dFUKb0Q1ZVltVjlnNGt2dWNnWDV3TS9nWkx0bXBIRDJ3S21lUnpSSXFqTEZqNXlIbFpYZ2xkSzdtY0N2aE85aGNLWgp1QUcwZkFxTFpNWENiRnQ1VE5sVTY2c001K1Q5L1hPU001YnkzRDc3MXRqb2JGTjdKV2dSeVlqZnRJQUpYQUJNCitXYXJVdGRZeDJaVHFiSTltNk4xSktHbVJVTlgyd01laE1sWGEvUVYwNWxoR1FiMTh3aFM5RTFlL2hlNnpKMFEKVzR5ZDZIZURlRUxwTCtid01YRkppWVp3S2NmanM2bTNpVXI5L3hoY3kxWmN0UnNvb2d0R1NVSGM4VEVaZ2YxYgpnVFNDckZ4ZVZJdDEvWkNFajAvZVBYT0Vrd3lpWjNoTmlvM2xoMFVncmFscGZVU2U5enhGR2J5SllIODQKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K\n    token: 9bs427dr3sb52f9lrhnf7z1fxw6fwaooyu46s984hg56x0dc67w5zxkw57ws3mapf7no2bqdizglu8g7bje9kutago94waidohfu6m7lm63htnug6dl22tquy92agvou\n",
# #             "kubelet_identity": [
# #               {
# #                 "client_id": "7ca72d09-a4d8-47c4-9d22-6486668a346e",
# #                 "object_id": "3fdece31-0f9e-4373-a64c-f47a98eb9da1",
# #                 "user_assigned_identity_id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-aks-cluster-agentpool"
# #               }
# #             ],
# #             "kubernetes_version": "1.31",
# #             "linux_profile": [
# #               {
# #                 "admin_username": "",
# #                 "ssh_key": []
# #               }
# #             ],
# #             "location": "westeurope",
# #             "microsoft_defender": [],
# #             "name": "my-aks-cluster",
# #             "network_profile": [
# #               {
# #                 "dns_service_ip": "10.0.0.10",
# #                 "docker_bridge_cidr": "",
# #                 "load_balancer_sku": "standard",
# #                 "network_plugin": "azure",
# #                 "network_policy": "none",
# #                 "pod_cidr": "",
# #                 "service_cidr": "10.0.0.0/16"
# #               }
# #             ],
# #             "node_resource_group": "MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope",
# #             "node_resource_group_id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope",
# #             "oidc_issuer_enabled": true,
# #             "oidc_issuer_url": "https://westeurope.oic.prod-aks.azure.com/a9f4aef9-8df7-4cc3-99a8-e85824715025/9a508e8a-5714-4dee-89b1-ce62333d4f05/",
# #             "oms_agent": null,
# #             "open_service_mesh_enabled": null,
# #             "private_cluster_enabled": null,
# #             "private_fqdn": "",
# #             "resource_group_name": "Dataplatform-Group-Monitoring",
# #             "role_based_access_control_enabled": true,
# #             "service_mesh_profile": [],
# #             "service_principal": [
# #               {
# #                 "client_id": "msi"
# #               }
# #             ],
# #             "storage_profile": [
# #               {
# #                 "blob_driver_enabled": false,
# #                 "disk_driver_enabled": true,
# #                 "file_driver_enabled": true,
# #                 "snapshot_controller_enabled": true
# #               }
# #             ],
# #             "tags": {
# #               "Environment": "dev"
# #             },
# #             "timeouts": null,
# #             "windows_profile": [
# #               {
# #                 "admin_username": "azureuser"
# #               }
# #             ]
# #           },
# #           "sensitive_attributes": []
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "data",
# #       "type": "azurerm_resource_group",
# #       "name": "main",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring",
# #             "location": "westeurope",
# #             "managed_by": "",
# #             "name": "Dataplatform-Group-Monitoring",
# #             "tags": {},
# #             "timeouts": null
# #           },
# #           "sensitive_attributes": []
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "data",
# #       "type": "external",
# #       "name": "elastic_password",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/external\"]",
# #       "instances": []
# #     },
# #     {
# #       "mode": "data",
# #       "type": "external",
# #       "name": "enrollment_token",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/external\"]",
# #       "instances": []
# #     },
# #     {
# #       "mode": "data",
# #       "type": "external",
# #       "name": "verification_code",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/external\"]",
# #       "instances": []
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "azurerm_kubernetes_cluster",
# #       "name": "aks",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 2,
# #           "attributes": {
# #             "aci_connector_linux": [],
# #             "api_server_access_profile": [],
# #             "auto_scaler_profile": [],
# #             "automatic_upgrade_channel": "",
# #             "azure_active_directory_role_based_access_control": [],
# #             "azure_policy_enabled": null,
# #             "confidential_computing": [],
# #             "cost_analysis_enabled": false,
# #             "current_kubernetes_version": "1.31.7",
# #             "default_node_pool": [
# #               {
# #                 "auto_scaling_enabled": false,
# #                 "capacity_reservation_group_id": "",
# #                 "fips_enabled": false,
# #                 "gpu_instance": "",
# #                 "host_encryption_enabled": false,
# #                 "host_group_id": "",
# #                 "kubelet_config": [],
# #                 "kubelet_disk_type": "OS",
# #                 "linux_os_config": [],
# #                 "max_count": 0,
# #                 "max_pods": 30,
# #                 "min_count": 0,
# #                 "name": "default",
# #                 "node_count": 1,
# #                 "node_labels": {},
# #                 "node_network_profile": [],
# #                 "node_public_ip_enabled": false,
# #                 "node_public_ip_prefix_id": "",
# #                 "only_critical_addons_enabled": false,
# #                 "orchestrator_version": "1.31",
# #                 "os_disk_size_gb": 128,
# #                 "os_disk_type": "Managed",
# #                 "os_sku": "Ubuntu",
# #                 "pod_subnet_id": "",
# #                 "proximity_placement_group_id": "",
# #                 "scale_down_mode": "Delete",
# #                 "snapshot_id": "",
# #                 "tags": {},
# #                 "temporary_name_for_rotation": "",
# #                 "type": "VirtualMachineScaleSets",
# #                 "ultra_ssd_enabled": false,
# #                 "upgrade_settings": [
# #                   {
# #                     "drain_timeout_in_minutes": 0,
# #                     "max_surge": "10%",
# #                     "node_soak_duration_in_minutes": 0
# #                   }
# #                 ],
# #                 "vm_size": "Standard_DS2_v2",
# #                 "vnet_subnet_id": "",
# #                 "workload_runtime": "",
# #                 "zones": []
# #               }
# #             ],
# #             "disk_encryption_set_id": "",
# #             "dns_prefix": "myaksdns",
# #             "dns_prefix_private_cluster": "",
# #             "edge_zone": "",
# #             "fqdn": "myaksdns-19jcks3u.hcp.westeurope.azmk8s.io",
# #             "http_application_routing_enabled": null,
# #             "http_application_routing_zone_name": null,
# #             "http_proxy_config": [],
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.ContainerService/managedClusters/my-aks-cluster",
# #             "identity": [
# #               {
# #                 "identity_ids": [],
# #                 "principal_id": "a86225ae-4313-4143-a23d-d98b5c7cff4f",
# #                 "tenant_id": "a9f4aef9-8df7-4cc3-99a8-e85824715025",
# #                 "type": "SystemAssigned"
# #               }
# #             ],
# #             "image_cleaner_enabled": null,
# #             "image_cleaner_interval_hours": null,
# #             "ingress_application_gateway": [],
# #             "key_management_service": [],
# #             "key_vault_secrets_provider": [],
# #             "kube_admin_config": [],
# #             "kube_admin_config_raw": "",
# #             "kube_config": [
# #               {
# #                 "client_certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZIVENDQXdXZ0F3SUJBZ0lRTmZKZ1lQeGJpMkJENHIwK0o5c1NHREFOQmdrcWhraUc5dzBCQVFzRkFEQU4KTVFzd0NRWURWUVFERXdKallUQWVGdzB5TlRBMU1UUXhNRFUzTURaYUZ3MHlOekExTVRReE1UQTNNRFphTURBeApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1SVXdFd1lEVlFRREV3eHRZWE4wWlhKamJHbGxiblF3CmdnSWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUNEd0F3Z2dJS0FvSUNBUUMrbm4rZmNGYngyZGJjRVV2SEhQTkEKZWcvZFFaKy8vZkU3L3kvcjlZRGRiWnhZcTVtOFdidytoTklPUUNUM2M1eklPeGJRME1rOXdSVHhxNjlaVHlTRgp4Q2NWL0xVaU9KS1BRWFBjcGQ5M2ZaeTY1Uzl1UXI1YXdla1BFUFI0ZnhkbVBQMi9zTCtPdlhkQlp6UU9rSWNqCnFMN1JNTm80NFU4STA3bXhrMEVEYXVtdDNPM3NJRmtNUmVIRW91Unl2VjZUOHI5aVB2eWNKakpZSWJQbEM1Y3IKWm5xM3hZelN4OVdDRk8venR5d0lSOXMxTFNjZFNHRHlyUmNEZSttYzYxL0c0L0prUnd4Z0dnU3pGRVVoSEE5dAoxU2V6V245V3VENnYvWUNKUVlsUjU0Z0pXcjh1TXJITGUwdlZad2tNa0I1eitTK1I2Q3ZSa2hMZHdiL0p1bWZTCnVRRjIvMW9tUTFDbm1wUjdpUzlyYk4wRzVtZGxJY245L3gzaTI0NnVuWWIxVnlRSmxFTk1VOHVIM2wxTXYzWkMKSGFLdDE5OWxGNkpIb0RSY0JjUVdEU1dhN1FMSTZKcGpqS2c1Mnp0QzlOSHFLTzFBVWNsMnE4NmR3dE5hWVlRRgpvNkg1NXJ2Q1NGc2F4RXdQUUZqajZnOUtTcjhXbzlGZmpwNHc1MzROSVdkemJsWHBOU0hyeVMvcG9kN1dnWHVrClVyN1FxOUNGb1l6SmZuVGVSMUUzTkZDODExYlc2L3ZRUEphVUgyNEJ2SXpUQlEzSGFqNFZTdXl5Zzc0OXRpSisKcGZtVVFiN3F3b1IwNmVkZEZlK1dUZHMwSXpkekdlVjBJVm80WmppU0JFanhUejRVSGZoUU1BeStPWVFlVUVhcwowUEpZVkxVYllPNVBDMS9sRzZPSlFRSURBUUFCbzFZd1ZEQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0V3WURWUjBsCkJBd3dDZ1lJS3dZQkJRVUhBd0l3REFZRFZSMFRBUUgvQkFJd0FEQWZCZ05WSFNNRUdEQVdnQlIzRG40UlNsNU4Kbkt0NjBuNXoxdCtRcnozem1EQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FnRUF6NGhyaUhhS0pDaUhhQW5JMWJUZwpPVHNmTit6YlNTdEx2cVBwZjhJcGZPQ0lJS0xRNFBJTkJCTzlqbi9IcjVDcnJXNlJwSWUxTEp6bW5tWUlxeUhyCkdObkdxZmFXMHVSMDBUaFpvY3R5UVRYMlBOZHhqY3F5SCtST1JncnV0TmRDKzFhZ29IeW5XYVYvdmU3V08rZGgKMVpCbTgwV1ZKMGVNL0F1RGN0MTBzYmFMRXpuZHRGTnpqN0QvQWVoeHZWYWUrcVNpa2sxOFdtY3FBRHAzRE1VOQppMmk4T1JaaU4ra094OXFVUktEVFo4bVR1L28wdmczUktvNXBjeEtLcDhyQ1BCakVkSEphU3BkL2tTWEdlOVlwCmlrcWJvcXFvUHlnbW5IUk1FeFZGTFRweFFWYXYvZWF4dDFDaWFWTmw1bTVXUXEwL2JTV1plazA4V1VVaGREbEgKNnZUSDJ3a0orL0srUmsxSDV6SlJVK3ZJaXpRcExyS2FtVFA0UEp4cmRWYVUyMkVzcTJycVBqOFlDVGhuVHBGMApWQzJNdlpVTS82L3pNaUJleFRXSlVHcjNNWHVjVW43ZHptRmoyTnFQVFl3Qloyb0kzTFhCcDV2dXp5ZEsyZ21VCnMzU0ZJNWx1eVl5U3ZGSmd3RTROa3dyVHFaK2I4YktUOGZwWDdSY0l3M3oxN0FCekxzSG1VSjl6Zzk5SXdqMHcKVW5PcUhNZnpESkFnN2xhbmQ1RzVQMHQ4N3Zqa3F5U2JHZHRxZEE4Tml0aUpGUDFVdzN2Q0ltNVovZmFNdEkzQwp1Y1R4ZDN6M2w4VWV4M2Y0Y0RSbmozVWNMMzFsbC9Gc1NWbWUrdFY3V2tUdXRieEd0bEF3UzFORGhtdHhRbVpQCnlQdWk0Vnh5QWhVeUsrTzZsRmZuWEE4PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
# #                 "client_key": "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBdnA1L24zQlc4ZG5XM0JGTHh4enpRSG9QM1VHZnYvM3hPLzh2Ni9XQTNXMmNXS3VaCnZGbThQb1RTRGtBazkzT2N5RHNXME5ESlBjRVU4YXV2V1U4a2hjUW5GZnkxSWppU2owRnozS1hmZDMyY3V1VXYKYmtLK1dzSHBEeEQwZUg4WFpqejl2N0MvanIxM1FXYzBEcENISTZpKzBURGFPT0ZQQ05PNXNaTkJBMnJwcmR6dAo3Q0JaREVYaHhLTGtjcjFlay9LL1lqNzhuQ1l5V0NHejVRdVhLMlo2dDhXTTBzZlZnaFR2ODdjc0NFZmJOUzBuCkhVaGc4cTBYQTN2cG5PdGZ4dVB5WkVjTVlCb0VzeFJGSVJ3UGJkVW5zMXAvVnJnK3IvMkFpVUdKVWVlSUNWcS8KTGpLeHkzdEwxV2NKREpBZWMva3ZrZWdyMFpJUzNjRy95YnBuMHJrQmR2OWFKa05RcDVxVWU0a3ZhMnpkQnVabgpaU0hKL2Y4ZDR0dU9ycDJHOVZja0NaUkRURlBMaDk1ZFRMOTJRaDJpcmRmZlpSZWlSNkEwWEFYRUZnMGxtdTBDCnlPaWFZNHlvT2RzN1F2VFI2aWp0UUZISmRxdk9uY0xUV21HRUJhT2grZWE3d2toYkdzUk1EMEJZNCtvUFNrcS8KRnFQUlg0NmVNT2QrRFNGbmMyNVY2VFVoNjhrdjZhSGUxb0Y3cEZLKzBLdlFoYUdNeVg1MDNrZFJOelJRdk5kVwoxdXY3MER5V2xCOXVBYnlNMHdVTngybytGVXJzc29PK1BiWWlmcVg1bEVHKzZzS0VkT25uWFJYdmxrM2JOQ00zCmN4bmxkQ0ZhT0dZNGtnUkk4VTgrRkIzNFVEQU12am1FSGxCR3JORHlXRlMxRzJEdVR3dGY1UnVqaVVFQ0F3RUEKQVFLQ0FnQWR6ZHg0aW5FZHVZak51ZXFXUkdHSVdFMTRzOVVOaU9BYUdHbGV4SEVVcmhtL0IzMnZKSHk1YmIwRwpPMk5NU1loZkNsWWo2akU4OVo2WHR0ZGc2RzMyZUZnQUtSWU5Ocms3cXVrNXU3bTREaXplVUExZGVSUVlUcTlwCkNxYWUzSWhGRlE0NzFaL3Q2cFBsNXdRTnJ1MWlWdlVXOGtOOGwwWHJSR2VKYTFQRC9BaHpoZEt4azlFNGlRaW0KM1MxSS8zRDFRd1JIa1QrZ0RwemFpTkorNHBRTlZpV2o3RUI3aUlGS3FJbG9HdURJbnF1WW9lbTJ1MlZsTEVrbgo0MDBBbXhETG9VSjZDVjNXL05wMVFac1pkVEM0WkphamhXZlpvRTgwNXpjY3Z1R0FxK25xUklVVjdSazlqcGFwCjFFVm04SFhDZmxqQXdJTnhiaHlERGRNMThHNWhFQ3h3K0VSMjRXVVpaNVFnamRGMUJrMFBHRDRJd25FRTJBd2oKbFRYMFpqUmdZWnNNZGpNYis2R3dlRnVsR0puczlQNE14bVdGUjNibUhidXRKSFNQb1p6Znd6Q1pQdU5xVlBGZApmcGVZSkhQaFNvN3NIbkJwZURZRFhrdEhIOHV3RnNCT04wTC9JY01GZmdJUWovKzdZYlJVb3U1NWJRYy9YUHY2CjJvVlRIM1hGZlhlR0RrTlFpYU9KcWpRY1NCYWVyUE1kSU91WkhmLzJmNTBpdnVBUEx3WFU5NXRSVHF2YmI3cWkKU0xBMVBCdS9QVHdybXNBUk1QcFRab0V4cUh1ck1IaXVLOGp1aEZRY21OMEJZWDRIUGRjNU5pVzlqSXdjeFVrbQpKaUtxVG05bVFEMEFGWUMzUTU4ODZkT09SSnlsMjViTy93NnpFcTBNMEdYWWZENlcwUUtDQVFFQTVEazFZN3U0CmlFUWUzVE1xOE9GZkxxYVhlNGpoVWdLSHMvcFRVd1RBZHN1Y3QvSVZ6UXBLckRmN1JMT0pLQXV4TFROMHNnbW8KdlVWVGpkWFY2RVpjSW9nS1BIcWhtdTk3SllRbWVrQWUxM2Y5c0E0c0RkR1lxRXk4MHFJOElyR1FUK1RLZ3RYSApITjVoVGdud2RSeEc3TndIUVQxSVFFazFYTlBGYXd4VkVPcEh2SjZrSGxIVzlXUGNZK29CdHdyQjBSQVRRMUpuClVlb2lFR2R1MXRUUkdzTmFtak9YaHdpblRSVHI0clRSd05jOFoxaklRQlNidmh0TXAvNjh6cWlVNGRPUkwrSHgKeFh6dTlBNmt0a0JGUXNjeDZRaTlaNHNvVzhYTzU1ejlBWTlYTWZJK0hXSGxiMjkxbzJ0NzBSS3c3YXpnQ3NySApxeXJJd25mOVVtZld0UUtDQVFFQTFkR2xjbWxDNDNKay8wdjU0VzM2M0djRVloSnQ2aXFwZ2NDRE82Y2xJbjJHCkYxb3NUdkROSHpwT3hDNWpFNGZvTzBoN0JFQWZBc3NqZVRxbXlpRnBoRjlzWE9GSUhtaU1OUHVYcWhxVGd5ZjIKMnFZemZERUh5MmliUU5JU21mMU9rVS9pdW52ZWE2b2NzWUQ4OE1EMmw0YmxhMm1RVi9rVDdjMjR2dXRZUXFIZgpNTWRZaC9ub1lrWFYvSHRUdjhBdnZWSnpkVGM5ckxoQWRmc3dWUTgvT1c0YStnQmZwY2JETnlmZVJHZmxHZjAwCnFKQjV5R2w3aGNqclVrYjA5VHZRVklESXJFNFdkalN4dXlXSlhsTldDd3FqaUdGVkxqT1c2UlVjL1dBdnh2K0oKZkNBSVo3OCtzdllQT1ZLcTc5cG9qcnpNZGFTZkV2alRhNzJXVnVqVDNRS0NBUUFiUnY4cm1XODMwalNDS2JCegpNK3lsYmNIalFQdjFTbG9mMThhSHdLU2tUamZBQUk0OGdJTm1UQmFiSW40OUxCQ1VIM2RPSkR0bnk5WnR1R1lsCnFlc3ZNV1ZQenpScmlUNEZ3T0s4YjlkLzExYVo2VWU0cXhsODNCY2hjY1NRUFByTG9jUFdtV2gvK2RCVmZIaWgKOXF3L2VSamc0a3MxYThxVityVzQwck9FSHd4TjdnUWRuNWg2b2VIZ2kwS0ROeVR0TU9lc2Z6ZmNJWWpLdnlJUApTVVpvMVhxSnZhclp0OTRQSjNYK0ZiQ1FST2x5VExrNmQzd1ozN2RzeU5TV09xMzR3OG14bUdiR1BPVnVoQ1dKCnB1cmdUV0NZd3JPb29ZaEVWOE1nQ2JKdnNrc3dyQXhpaEtYZ2lNamRyR1lUR2hITmhvRU1xU251T21IZVpHc0IKbzJtVkFvSUJBUURINjU2elRDSmpnZ2xXLzFYajVxNUJOLzFNS1lrbUFyKzg5eUI5UFRvbWRwRlM4bGd0YzArSApYRUJiaERmVkFpVXNrUWVjb011ZUZBdldCUFlBVnA5UFN0MktOb1gxRUxIUHRGSkpsVkhKdHl0RG8xVE9VUlhGCnBjaE1JbCtNSmVFNVV5VmVVZ1ZVUzVsS2lwMTJDaVpHNWJWSzZrZ3hTVTNOOHFWRHRjOHZkaVMyZWgyWC9oMi8KRFNjWVRNT3dyV1Mxc3dzTFZSeFFpM0tTSGN4Q0srQmt0VU41NzdGKzBrcWpIcDdlL1Bta2hEQ2hUM3plMjJuSQpYR1ZTNTgrUUlGNFpOTlRzN3BKbjhic2dqZWRVRDcySzAyYTJWTE9OWUdWQkNDR3o4eVNZLzBNd2tNN3JHbERvCmlkTVFPUEJsRmFUZm1UM2UzWTV5OGI3VXBVNlZjbHJ0QW9JQkFRQ2QwMmZuaU9maEdWR1VJWk9pckJ0Q0g0dFUKb0Q1ZVltVjlnNGt2dWNnWDV3TS9nWkx0bXBIRDJ3S21lUnpSSXFqTEZqNXlIbFpYZ2xkSzdtY0N2aE85aGNLWgp1QUcwZkFxTFpNWENiRnQ1VE5sVTY2c001K1Q5L1hPU001YnkzRDc3MXRqb2JGTjdKV2dSeVlqZnRJQUpYQUJNCitXYXJVdGRZeDJaVHFiSTltNk4xSktHbVJVTlgyd01laE1sWGEvUVYwNWxoR1FiMTh3aFM5RTFlL2hlNnpKMFEKVzR5ZDZIZURlRUxwTCtid01YRkppWVp3S2NmanM2bTNpVXI5L3hoY3kxWmN0UnNvb2d0R1NVSGM4VEVaZ2YxYgpnVFNDckZ4ZVZJdDEvWkNFajAvZVBYT0Vrd3lpWjNoTmlvM2xoMFVncmFscGZVU2U5enhGR2J5SllIODQKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K",
# #                 "cluster_ca_certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUU2VENDQXRHZ0F3SUJBZ0lSQVBMdXlBNTllUnZkSFZLb2F2K0pyWjB3RFFZSktvWklodmNOQVFFTEJRQXcKRFRFTE1Ba0dBMVVFQXhNQ1kyRXdJQmNOTWpVd05URTBNVEExTnpBMldoZ1BNakExTlRBMU1UUXhNVEEzTURaYQpNQTB4Q3pBSkJnTlZCQU1UQW1OaE1JSUNJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBZzhBTUlJQ0NnS0NBZ0VBCjF0ZU5yeGNlQzRwUEtNUTE4cDNOZ3VaUVRlS2xSeGdvdFJjSTNkZVF1bjd5ZDR1L05JWDNubFNRTmN0MDBESk8KeTN0M21pSzVyMzZCbTZVbWFDQ3hTbHRHU3BGS0FWYVlLUEdabXUrVm1EbHZYcWVjYlhoY2xZM2x1WUI0Ynd0YgpEZS9KWnIxWFpyY3F1K0lKUEdaY1FwQ3UzZTd3ZjVwMEs1Y1JsbmNtQ3Z6K08zK1o5U2J6Z1JEeHhDWmZhRzBJCnNqYmcwUzg0RXVTQkJGbEJScG1vMVp6SFhnVWR2bHg2Q1NXZ2txeFRYaGlBU0tTVldveWlzODh6WVU4MGp0ckwKU3JzZmNoK3JDbXA3WFp0MnNXRDdNYlhIQXhqNFpJVWdqK3VhaS9EQmdhN3o1bHdWTmhUMG92eHBoMncyRUs0TQpKcmU2dWZsMzEwQllsYS9UbG5mUUpUczVuRkhWSlErdlVjOHVOZWNIdWI3MFc3cnBYY09rWW5oeTN5Vk1xZy9DCnoxMVZ0SVpUdzhuc251UGJRT051SVpobk1yVDU3UFhXZmQrV2tBa2N4WDd0NlM3Wm9iTkFhOEFHQUlqZVkzNE8KZ1hONTlpek5lMDVHOUpxaTZpL2x1Tjc2M3ZQYUtDQmlnRDN3QUN6bXl1TXRENWJmQTdKd0JxOFhBT2drRllYUAoxbmduTmRkNWN0NC83MTlIZUJmeisxd20yczdXTEtJOFdBYlQ2RVptaUZheWp4Q0dmcmdMQjBhMUNLOWN3QVlvCmQ0WGpmRVVhQ0tLNkxURzFsRHprVUdDZjRETWJuV2pvcExMalNuaXlOR2lCS0JYcy9VOVA1UFd0aGRaaWdGM2UKZ3VzQUdsbEJDckFXU2VFMkVSSVVuYzV5WUdDanZWdEVaVHQrc1JJaXBYc0NBd0VBQWFOQ01FQXdEZ1lEVlIwUApBUUgvQkFRREFnS2tNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdIUVlEVlIwT0JCWUVGSGNPZmhGS1hrMmNxM3JTCmZuUFczNUN2UGZPWU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQ0FRQjZVZkRyRXg0UVdyYzNHazNTUjRKRHJLUXEKam1pSWlIYS9SOUkrb3c1Y2c4cWxRenM1dG9Pb0oxc1BBTUx5Sm9rbW8yQ0ZlOTF2SkVnN0Qyd3RLOHhCb3RyNwpXWDdNWktFeDhmVnJXYTlrMDhSVHpmMk8vL2JaN01lSk1VeFJXajJSSGdoQ0JXVlc2SWVVdFpER0RqK1lWeFZWCnR4cm5PWkN6QlQ3bmJmUy9xTURWWjVNVHlsR3JRcFJQMnpuejBZTzNsK1dYNFdNc2pKN0VFUElLMEdEczhsck0KSlJSbFlkR1FUZi9vNXlPamtFbVdTMklYY09lUmFaaS8wdVJhZUdkOWhGREY1RVlzUFZwSXJBdlIyWHlzY3Y4aApPVzh3YWpZa2hRSnB6aHlNTTByMGliQXYxeUVvYXVTSzREOHY0NkFBU0FvVGthQ0M5d3hBQlBFRmZuVTQzS2xxCmhvN09MMU8yS1RUcEt0Y3Z6aURzc3lXZFZFSmFMQ2tSM1k2Vzltc0RNRnlNODRnMjJKd0RUa2h1ZEZDWUcrMG4KZWx2dXB1SDFhRHhsaFBlRTM4eWxQOU03TGdsM3crMXAwMXN6TTZzQmFBUjYvNjk1SWxzYmZDZUFrNmRKZkNxcgpWZlVmdDJlVEJFdkRKT2ZIWGZRaCtsQzQyV0pqc0ZoZDhSTGVLU09YSDlZUzRTU0syNnBIS2ZnTTNiVkJVdzh2CjRwWjB6a2lTak1jMll0U2pmSUdYUlE3Z2E3QzdwYW1Cb2NBZTB6YUxoaHg5SXBCUmdMNXIrd0lIblRFNHlIeloKQUc0cVpLS0ZJODRMRzJLb1BoaHRiWFpXTTZWNXRyZHBlWjFrQjZNU1FhV0k3Sml0VFkxanAwTXc0TG9UY3J5aApTbW4rZURTL2xuSjJ4TnRzeEE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
# #                 "host": "https://myaksdns-19jcks3u.hcp.westeurope.azmk8s.io:443",
# #                 "password": "9bs427dr3sb52f9lrhnf7z1fxw6fwaooyu46s984hg56x0dc67w5zxkw57ws3mapf7no2bqdizglu8g7bje9kutago94waidohfu6m7lm63htnug6dl22tquy92agvou",
# #                 "username": "clusterUser_Dataplatform-Group-Monitoring_my-aks-cluster"
# #               }
# #             ],
# #             "kube_config_raw": "apiVersion: v1\nclusters:\n- cluster:\n    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUU2VENDQXRHZ0F3SUJBZ0lSQVBMdXlBNTllUnZkSFZLb2F2K0pyWjB3RFFZSktvWklodmNOQVFFTEJRQXcKRFRFTE1Ba0dBMVVFQXhNQ1kyRXdJQmNOTWpVd05URTBNVEExTnpBMldoZ1BNakExTlRBMU1UUXhNVEEzTURaYQpNQTB4Q3pBSkJnTlZCQU1UQW1OaE1JSUNJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBZzhBTUlJQ0NnS0NBZ0VBCjF0ZU5yeGNlQzRwUEtNUTE4cDNOZ3VaUVRlS2xSeGdvdFJjSTNkZVF1bjd5ZDR1L05JWDNubFNRTmN0MDBESk8KeTN0M21pSzVyMzZCbTZVbWFDQ3hTbHRHU3BGS0FWYVlLUEdabXUrVm1EbHZYcWVjYlhoY2xZM2x1WUI0Ynd0YgpEZS9KWnIxWFpyY3F1K0lKUEdaY1FwQ3UzZTd3ZjVwMEs1Y1JsbmNtQ3Z6K08zK1o5U2J6Z1JEeHhDWmZhRzBJCnNqYmcwUzg0RXVTQkJGbEJScG1vMVp6SFhnVWR2bHg2Q1NXZ2txeFRYaGlBU0tTVldveWlzODh6WVU4MGp0ckwKU3JzZmNoK3JDbXA3WFp0MnNXRDdNYlhIQXhqNFpJVWdqK3VhaS9EQmdhN3o1bHdWTmhUMG92eHBoMncyRUs0TQpKcmU2dWZsMzEwQllsYS9UbG5mUUpUczVuRkhWSlErdlVjOHVOZWNIdWI3MFc3cnBYY09rWW5oeTN5Vk1xZy9DCnoxMVZ0SVpUdzhuc251UGJRT051SVpobk1yVDU3UFhXZmQrV2tBa2N4WDd0NlM3Wm9iTkFhOEFHQUlqZVkzNE8KZ1hONTlpek5lMDVHOUpxaTZpL2x1Tjc2M3ZQYUtDQmlnRDN3QUN6bXl1TXRENWJmQTdKd0JxOFhBT2drRllYUAoxbmduTmRkNWN0NC83MTlIZUJmeisxd20yczdXTEtJOFdBYlQ2RVptaUZheWp4Q0dmcmdMQjBhMUNLOWN3QVlvCmQ0WGpmRVVhQ0tLNkxURzFsRHprVUdDZjRETWJuV2pvcExMalNuaXlOR2lCS0JYcy9VOVA1UFd0aGRaaWdGM2UKZ3VzQUdsbEJDckFXU2VFMkVSSVVuYzV5WUdDanZWdEVaVHQrc1JJaXBYc0NBd0VBQWFOQ01FQXdEZ1lEVlIwUApBUUgvQkFRREFnS2tNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdIUVlEVlIwT0JCWUVGSGNPZmhGS1hrMmNxM3JTCmZuUFczNUN2UGZPWU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQ0FRQjZVZkRyRXg0UVdyYzNHazNTUjRKRHJLUXEKam1pSWlIYS9SOUkrb3c1Y2c4cWxRenM1dG9Pb0oxc1BBTUx5Sm9rbW8yQ0ZlOTF2SkVnN0Qyd3RLOHhCb3RyNwpXWDdNWktFeDhmVnJXYTlrMDhSVHpmMk8vL2JaN01lSk1VeFJXajJSSGdoQ0JXVlc2SWVVdFpER0RqK1lWeFZWCnR4cm5PWkN6QlQ3bmJmUy9xTURWWjVNVHlsR3JRcFJQMnpuejBZTzNsK1dYNFdNc2pKN0VFUElLMEdEczhsck0KSlJSbFlkR1FUZi9vNXlPamtFbVdTMklYY09lUmFaaS8wdVJhZUdkOWhGREY1RVlzUFZwSXJBdlIyWHlzY3Y4aApPVzh3YWpZa2hRSnB6aHlNTTByMGliQXYxeUVvYXVTSzREOHY0NkFBU0FvVGthQ0M5d3hBQlBFRmZuVTQzS2xxCmhvN09MMU8yS1RUcEt0Y3Z6aURzc3lXZFZFSmFMQ2tSM1k2Vzltc0RNRnlNODRnMjJKd0RUa2h1ZEZDWUcrMG4KZWx2dXB1SDFhRHhsaFBlRTM4eWxQOU03TGdsM3crMXAwMXN6TTZzQmFBUjYvNjk1SWxzYmZDZUFrNmRKZkNxcgpWZlVmdDJlVEJFdkRKT2ZIWGZRaCtsQzQyV0pqc0ZoZDhSTGVLU09YSDlZUzRTU0syNnBIS2ZnTTNiVkJVdzh2CjRwWjB6a2lTak1jMll0U2pmSUdYUlE3Z2E3QzdwYW1Cb2NBZTB6YUxoaHg5SXBCUmdMNXIrd0lIblRFNHlIeloKQUc0cVpLS0ZJODRMRzJLb1BoaHRiWFpXTTZWNXRyZHBlWjFrQjZNU1FhV0k3Sml0VFkxanAwTXc0TG9UY3J5aApTbW4rZURTL2xuSjJ4TnRzeEE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==\n    server: https://myaksdns-19jcks3u.hcp.westeurope.azmk8s.io:443\n  name: my-aks-cluster\ncontexts:\n- context:\n    cluster: my-aks-cluster\n    user: clusterUser_Dataplatform-Group-Monitoring_my-aks-cluster\n  name: my-aks-cluster\ncurrent-context: my-aks-cluster\nkind: Config\npreferences: {}\nusers:\n- name: clusterUser_Dataplatform-Group-Monitoring_my-aks-cluster\n  user:\n    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZIVENDQXdXZ0F3SUJBZ0lRTmZKZ1lQeGJpMkJENHIwK0o5c1NHREFOQmdrcWhraUc5dzBCQVFzRkFEQU4KTVFzd0NRWURWUVFERXdKallUQWVGdzB5TlRBMU1UUXhNRFUzTURaYUZ3MHlOekExTVRReE1UQTNNRFphTURBeApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1SVXdFd1lEVlFRREV3eHRZWE4wWlhKamJHbGxiblF3CmdnSWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUNEd0F3Z2dJS0FvSUNBUUMrbm4rZmNGYngyZGJjRVV2SEhQTkEKZWcvZFFaKy8vZkU3L3kvcjlZRGRiWnhZcTVtOFdidytoTklPUUNUM2M1eklPeGJRME1rOXdSVHhxNjlaVHlTRgp4Q2NWL0xVaU9KS1BRWFBjcGQ5M2ZaeTY1Uzl1UXI1YXdla1BFUFI0ZnhkbVBQMi9zTCtPdlhkQlp6UU9rSWNqCnFMN1JNTm80NFU4STA3bXhrMEVEYXVtdDNPM3NJRmtNUmVIRW91Unl2VjZUOHI5aVB2eWNKakpZSWJQbEM1Y3IKWm5xM3hZelN4OVdDRk8venR5d0lSOXMxTFNjZFNHRHlyUmNEZSttYzYxL0c0L0prUnd4Z0dnU3pGRVVoSEE5dAoxU2V6V245V3VENnYvWUNKUVlsUjU0Z0pXcjh1TXJITGUwdlZad2tNa0I1eitTK1I2Q3ZSa2hMZHdiL0p1bWZTCnVRRjIvMW9tUTFDbm1wUjdpUzlyYk4wRzVtZGxJY245L3gzaTI0NnVuWWIxVnlRSmxFTk1VOHVIM2wxTXYzWkMKSGFLdDE5OWxGNkpIb0RSY0JjUVdEU1dhN1FMSTZKcGpqS2c1Mnp0QzlOSHFLTzFBVWNsMnE4NmR3dE5hWVlRRgpvNkg1NXJ2Q1NGc2F4RXdQUUZqajZnOUtTcjhXbzlGZmpwNHc1MzROSVdkemJsWHBOU0hyeVMvcG9kN1dnWHVrClVyN1FxOUNGb1l6SmZuVGVSMUUzTkZDODExYlc2L3ZRUEphVUgyNEJ2SXpUQlEzSGFqNFZTdXl5Zzc0OXRpSisKcGZtVVFiN3F3b1IwNmVkZEZlK1dUZHMwSXpkekdlVjBJVm80WmppU0JFanhUejRVSGZoUU1BeStPWVFlVUVhcwowUEpZVkxVYllPNVBDMS9sRzZPSlFRSURBUUFCbzFZd1ZEQU9CZ05WSFE4QkFmOEVCQU1DQmFBd0V3WURWUjBsCkJBd3dDZ1lJS3dZQkJRVUhBd0l3REFZRFZSMFRBUUgvQkFJd0FEQWZCZ05WSFNNRUdEQVdnQlIzRG40UlNsNU4Kbkt0NjBuNXoxdCtRcnozem1EQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FnRUF6NGhyaUhhS0pDaUhhQW5JMWJUZwpPVHNmTit6YlNTdEx2cVBwZjhJcGZPQ0lJS0xRNFBJTkJCTzlqbi9IcjVDcnJXNlJwSWUxTEp6bW5tWUlxeUhyCkdObkdxZmFXMHVSMDBUaFpvY3R5UVRYMlBOZHhqY3F5SCtST1JncnV0TmRDKzFhZ29IeW5XYVYvdmU3V08rZGgKMVpCbTgwV1ZKMGVNL0F1RGN0MTBzYmFMRXpuZHRGTnpqN0QvQWVoeHZWYWUrcVNpa2sxOFdtY3FBRHAzRE1VOQppMmk4T1JaaU4ra094OXFVUktEVFo4bVR1L28wdmczUktvNXBjeEtLcDhyQ1BCakVkSEphU3BkL2tTWEdlOVlwCmlrcWJvcXFvUHlnbW5IUk1FeFZGTFRweFFWYXYvZWF4dDFDaWFWTmw1bTVXUXEwL2JTV1plazA4V1VVaGREbEgKNnZUSDJ3a0orL0srUmsxSDV6SlJVK3ZJaXpRcExyS2FtVFA0UEp4cmRWYVUyMkVzcTJycVBqOFlDVGhuVHBGMApWQzJNdlpVTS82L3pNaUJleFRXSlVHcjNNWHVjVW43ZHptRmoyTnFQVFl3Qloyb0kzTFhCcDV2dXp5ZEsyZ21VCnMzU0ZJNWx1eVl5U3ZGSmd3RTROa3dyVHFaK2I4YktUOGZwWDdSY0l3M3oxN0FCekxzSG1VSjl6Zzk5SXdqMHcKVW5PcUhNZnpESkFnN2xhbmQ1RzVQMHQ4N3Zqa3F5U2JHZHRxZEE4Tml0aUpGUDFVdzN2Q0ltNVovZmFNdEkzQwp1Y1R4ZDN6M2w4VWV4M2Y0Y0RSbmozVWNMMzFsbC9Gc1NWbWUrdFY3V2tUdXRieEd0bEF3UzFORGhtdHhRbVpQCnlQdWk0Vnh5QWhVeUsrTzZsRmZuWEE4PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==\n    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBdnA1L24zQlc4ZG5XM0JGTHh4enpRSG9QM1VHZnYvM3hPLzh2Ni9XQTNXMmNXS3VaCnZGbThQb1RTRGtBazkzT2N5RHNXME5ESlBjRVU4YXV2V1U4a2hjUW5GZnkxSWppU2owRnozS1hmZDMyY3V1VXYKYmtLK1dzSHBEeEQwZUg4WFpqejl2N0MvanIxM1FXYzBEcENISTZpKzBURGFPT0ZQQ05PNXNaTkJBMnJwcmR6dAo3Q0JaREVYaHhLTGtjcjFlay9LL1lqNzhuQ1l5V0NHejVRdVhLMlo2dDhXTTBzZlZnaFR2ODdjc0NFZmJOUzBuCkhVaGc4cTBYQTN2cG5PdGZ4dVB5WkVjTVlCb0VzeFJGSVJ3UGJkVW5zMXAvVnJnK3IvMkFpVUdKVWVlSUNWcS8KTGpLeHkzdEwxV2NKREpBZWMva3ZrZWdyMFpJUzNjRy95YnBuMHJrQmR2OWFKa05RcDVxVWU0a3ZhMnpkQnVabgpaU0hKL2Y4ZDR0dU9ycDJHOVZja0NaUkRURlBMaDk1ZFRMOTJRaDJpcmRmZlpSZWlSNkEwWEFYRUZnMGxtdTBDCnlPaWFZNHlvT2RzN1F2VFI2aWp0UUZISmRxdk9uY0xUV21HRUJhT2grZWE3d2toYkdzUk1EMEJZNCtvUFNrcS8KRnFQUlg0NmVNT2QrRFNGbmMyNVY2VFVoNjhrdjZhSGUxb0Y3cEZLKzBLdlFoYUdNeVg1MDNrZFJOelJRdk5kVwoxdXY3MER5V2xCOXVBYnlNMHdVTngybytGVXJzc29PK1BiWWlmcVg1bEVHKzZzS0VkT25uWFJYdmxrM2JOQ00zCmN4bmxkQ0ZhT0dZNGtnUkk4VTgrRkIzNFVEQU12am1FSGxCR3JORHlXRlMxRzJEdVR3dGY1UnVqaVVFQ0F3RUEKQVFLQ0FnQWR6ZHg0aW5FZHVZak51ZXFXUkdHSVdFMTRzOVVOaU9BYUdHbGV4SEVVcmhtL0IzMnZKSHk1YmIwRwpPMk5NU1loZkNsWWo2akU4OVo2WHR0ZGc2RzMyZUZnQUtSWU5Ocms3cXVrNXU3bTREaXplVUExZGVSUVlUcTlwCkNxYWUzSWhGRlE0NzFaL3Q2cFBsNXdRTnJ1MWlWdlVXOGtOOGwwWHJSR2VKYTFQRC9BaHpoZEt4azlFNGlRaW0KM1MxSS8zRDFRd1JIa1QrZ0RwemFpTkorNHBRTlZpV2o3RUI3aUlGS3FJbG9HdURJbnF1WW9lbTJ1MlZsTEVrbgo0MDBBbXhETG9VSjZDVjNXL05wMVFac1pkVEM0WkphamhXZlpvRTgwNXpjY3Z1R0FxK25xUklVVjdSazlqcGFwCjFFVm04SFhDZmxqQXdJTnhiaHlERGRNMThHNWhFQ3h3K0VSMjRXVVpaNVFnamRGMUJrMFBHRDRJd25FRTJBd2oKbFRYMFpqUmdZWnNNZGpNYis2R3dlRnVsR0puczlQNE14bVdGUjNibUhidXRKSFNQb1p6Znd6Q1pQdU5xVlBGZApmcGVZSkhQaFNvN3NIbkJwZURZRFhrdEhIOHV3RnNCT04wTC9JY01GZmdJUWovKzdZYlJVb3U1NWJRYy9YUHY2CjJvVlRIM1hGZlhlR0RrTlFpYU9KcWpRY1NCYWVyUE1kSU91WkhmLzJmNTBpdnVBUEx3WFU5NXRSVHF2YmI3cWkKU0xBMVBCdS9QVHdybXNBUk1QcFRab0V4cUh1ck1IaXVLOGp1aEZRY21OMEJZWDRIUGRjNU5pVzlqSXdjeFVrbQpKaUtxVG05bVFEMEFGWUMzUTU4ODZkT09SSnlsMjViTy93NnpFcTBNMEdYWWZENlcwUUtDQVFFQTVEazFZN3U0CmlFUWUzVE1xOE9GZkxxYVhlNGpoVWdLSHMvcFRVd1RBZHN1Y3QvSVZ6UXBLckRmN1JMT0pLQXV4TFROMHNnbW8KdlVWVGpkWFY2RVpjSW9nS1BIcWhtdTk3SllRbWVrQWUxM2Y5c0E0c0RkR1lxRXk4MHFJOElyR1FUK1RLZ3RYSApITjVoVGdud2RSeEc3TndIUVQxSVFFazFYTlBGYXd4VkVPcEh2SjZrSGxIVzlXUGNZK29CdHdyQjBSQVRRMUpuClVlb2lFR2R1MXRUUkdzTmFtak9YaHdpblRSVHI0clRSd05jOFoxaklRQlNidmh0TXAvNjh6cWlVNGRPUkwrSHgKeFh6dTlBNmt0a0JGUXNjeDZRaTlaNHNvVzhYTzU1ejlBWTlYTWZJK0hXSGxiMjkxbzJ0NzBSS3c3YXpnQ3NySApxeXJJd25mOVVtZld0UUtDQVFFQTFkR2xjbWxDNDNKay8wdjU0VzM2M0djRVloSnQ2aXFwZ2NDRE82Y2xJbjJHCkYxb3NUdkROSHpwT3hDNWpFNGZvTzBoN0JFQWZBc3NqZVRxbXlpRnBoRjlzWE9GSUhtaU1OUHVYcWhxVGd5ZjIKMnFZemZERUh5MmliUU5JU21mMU9rVS9pdW52ZWE2b2NzWUQ4OE1EMmw0YmxhMm1RVi9rVDdjMjR2dXRZUXFIZgpNTWRZaC9ub1lrWFYvSHRUdjhBdnZWSnpkVGM5ckxoQWRmc3dWUTgvT1c0YStnQmZwY2JETnlmZVJHZmxHZjAwCnFKQjV5R2w3aGNqclVrYjA5VHZRVklESXJFNFdkalN4dXlXSlhsTldDd3FqaUdGVkxqT1c2UlVjL1dBdnh2K0oKZkNBSVo3OCtzdllQT1ZLcTc5cG9qcnpNZGFTZkV2alRhNzJXVnVqVDNRS0NBUUFiUnY4cm1XODMwalNDS2JCegpNK3lsYmNIalFQdjFTbG9mMThhSHdLU2tUamZBQUk0OGdJTm1UQmFiSW40OUxCQ1VIM2RPSkR0bnk5WnR1R1lsCnFlc3ZNV1ZQenpScmlUNEZ3T0s4YjlkLzExYVo2VWU0cXhsODNCY2hjY1NRUFByTG9jUFdtV2gvK2RCVmZIaWgKOXF3L2VSamc0a3MxYThxVityVzQwck9FSHd4TjdnUWRuNWg2b2VIZ2kwS0ROeVR0TU9lc2Z6ZmNJWWpLdnlJUApTVVpvMVhxSnZhclp0OTRQSjNYK0ZiQ1FST2x5VExrNmQzd1ozN2RzeU5TV09xMzR3OG14bUdiR1BPVnVoQ1dKCnB1cmdUV0NZd3JPb29ZaEVWOE1nQ2JKdnNrc3dyQXhpaEtYZ2lNamRyR1lUR2hITmhvRU1xU251T21IZVpHc0IKbzJtVkFvSUJBUURINjU2elRDSmpnZ2xXLzFYajVxNUJOLzFNS1lrbUFyKzg5eUI5UFRvbWRwRlM4bGd0YzArSApYRUJiaERmVkFpVXNrUWVjb011ZUZBdldCUFlBVnA5UFN0MktOb1gxRUxIUHRGSkpsVkhKdHl0RG8xVE9VUlhGCnBjaE1JbCtNSmVFNVV5VmVVZ1ZVUzVsS2lwMTJDaVpHNWJWSzZrZ3hTVTNOOHFWRHRjOHZkaVMyZWgyWC9oMi8KRFNjWVRNT3dyV1Mxc3dzTFZSeFFpM0tTSGN4Q0srQmt0VU41NzdGKzBrcWpIcDdlL1Bta2hEQ2hUM3plMjJuSQpYR1ZTNTgrUUlGNFpOTlRzN3BKbjhic2dqZWRVRDcySzAyYTJWTE9OWUdWQkNDR3o4eVNZLzBNd2tNN3JHbERvCmlkTVFPUEJsRmFUZm1UM2UzWTV5OGI3VXBVNlZjbHJ0QW9JQkFRQ2QwMmZuaU9maEdWR1VJWk9pckJ0Q0g0dFUKb0Q1ZVltVjlnNGt2dWNnWDV3TS9nWkx0bXBIRDJ3S21lUnpSSXFqTEZqNXlIbFpYZ2xkSzdtY0N2aE85aGNLWgp1QUcwZkFxTFpNWENiRnQ1VE5sVTY2c001K1Q5L1hPU001YnkzRDc3MXRqb2JGTjdKV2dSeVlqZnRJQUpYQUJNCitXYXJVdGRZeDJaVHFiSTltNk4xSktHbVJVTlgyd01laE1sWGEvUVYwNWxoR1FiMTh3aFM5RTFlL2hlNnpKMFEKVzR5ZDZIZURlRUxwTCtid01YRkppWVp3S2NmanM2bTNpVXI5L3hoY3kxWmN0UnNvb2d0R1NVSGM4VEVaZ2YxYgpnVFNDckZ4ZVZJdDEvWkNFajAvZVBYT0Vrd3lpWjNoTmlvM2xoMFVncmFscGZVU2U5enhGR2J5SllIODQKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K\n    token: 9bs427dr3sb52f9lrhnf7z1fxw6fwaooyu46s984hg56x0dc67w5zxkw57ws3mapf7no2bqdizglu8g7bje9kutago94waidohfu6m7lm63htnug6dl22tquy92agvou\n",
# #             "kubelet_identity": [
# #               {
# #                 "client_id": "7ca72d09-a4d8-47c4-9d22-6486668a346e",
# #                 "object_id": "3fdece31-0f9e-4373-a64c-f47a98eb9da1",
# #                 "user_assigned_identity_id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-aks-cluster-agentpool"
# #               }
# #             ],
# #             "kubernetes_version": "1.31",
# #             "linux_profile": [],
# #             "local_account_disabled": false,
# #             "location": "westeurope",
# #             "maintenance_window": [],
# #             "maintenance_window_auto_upgrade": [],
# #             "maintenance_window_node_os": [],
# #             "microsoft_defender": [],
# #             "monitor_metrics": [],
# #             "name": "my-aks-cluster",
# #             "network_profile": [
# #               {
# #                 "dns_service_ip": "10.0.0.10",
# #                 "ip_versions": [
# #                   "IPv4"
# #                 ],
# #                 "load_balancer_profile": [
# #                   {
# #                     "backend_pool_type": "NodeIPConfiguration",
# #                     "effective_outbound_ips": [
# #                       "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope/providers/Microsoft.Network/publicIPAddresses/73c69892-45e8-4427-bf5d-7c35c3e2f43b"
# #                     ],
# #                     "idle_timeout_in_minutes": 0,
# #                     "managed_outbound_ip_count": 1,
# #                     "managed_outbound_ipv6_count": 0,
# #                     "outbound_ip_address_ids": [],
# #                     "outbound_ip_prefix_ids": [],
# #                     "outbound_ports_allocated": 0
# #                   }
# #                 ],
# #                 "load_balancer_sku": "standard",
# #                 "nat_gateway_profile": [],
# #                 "network_data_plane": "azure",
# #                 "network_mode": "",
# #                 "network_plugin": "azure",
# #                 "network_plugin_mode": "",
# #                 "network_policy": "",
# #                 "outbound_type": "loadBalancer",
# #                 "pod_cidr": "",
# #                 "pod_cidrs": [],
# #                 "service_cidr": "10.0.0.0/16",
# #                 "service_cidrs": [
# #                   "10.0.0.0/16"
# #                 ]
# #               }
# #             ],
# #             "node_os_upgrade_channel": "NodeImage",
# #             "node_resource_group": "MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope",
# #             "node_resource_group_id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/MC_Dataplatform-Group-Monitoring_my-aks-cluster_westeurope",
# #             "oidc_issuer_enabled": true,
# #             "oidc_issuer_url": "https://westeurope.oic.prod-aks.azure.com/a9f4aef9-8df7-4cc3-99a8-e85824715025/9a508e8a-5714-4dee-89b1-ce62333d4f05/",
# #             "oms_agent": [],
# #             "open_service_mesh_enabled": null,
# #             "portal_fqdn": "myaksdns-19jcks3u.portal.hcp.westeurope.azmk8s.io",
# #             "private_cluster_enabled": false,
# #             "private_cluster_public_fqdn_enabled": false,
# #             "private_dns_zone_id": "",
# #             "private_fqdn": "",
# #             "resource_group_name": "Dataplatform-Group-Monitoring",
# #             "role_based_access_control_enabled": true,
# #             "run_command_enabled": true,
# #             "service_mesh_profile": [],
# #             "service_principal": [],
# #             "sku_tier": "Free",
# #             "storage_profile": [],
# #             "support_plan": "KubernetesOfficial",
# #             "tags": {
# #               "Environment": "dev"
# #             },
# #             "timeouts": null,
# #             "upgrade_override": [],
# #             "web_app_routing": [],
# #             "windows_profile": [
# #               {
# #                 "admin_password": "",
# #                 "admin_username": "azureuser",
# #                 "gmsa": [],
# #                 "license": ""
# #               }
# #             ],
# #             "workload_autoscaler_profile": [],
# #             "workload_identity_enabled": false
# #           },
# #           "sensitive_attributes": [],
# #           "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo1NDAwMDAwMDAwMDAwLCJkZWxldGUiOjU0MDAwMDAwMDAwMDAsInJlYWQiOjMwMDAwMDAwMDAwMCwidXBkYXRlIjo1NDAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIyIn0="
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "azurerm_network_security_group",
# #       "name": "AKSsg",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/networkSecurityGroups/SecurityGroupGeneral",
# #             "location": "westeurope",
# #             "name": "SecurityGroupGeneral",
# #             "resource_group_name": "Dataplatform-Group-Monitoring",
# #             "security_rule": [
# #               {
# #                 "access": "Allow",
# #                 "description": "",
# #                 "destination_address_prefix": "*",
# #                 "destination_address_prefixes": [],
# #                 "destination_application_security_group_ids": [],
# #                 "destination_port_range": "22",
# #                 "destination_port_ranges": [],
# #                 "direction": "Inbound",
# #                 "name": "ssh",
# #                 "priority": 105,
# #                 "protocol": "Tcp",
# #                 "source_address_prefix": "*",
# #                 "source_address_prefixes": [],
# #                 "source_application_security_group_ids": [],
# #                 "source_port_range": "*",
# #                 "source_port_ranges": []
# #               },
# #               {
# #                 "access": "Allow",
# #                 "description": "",
# #                 "destination_address_prefix": "*",
# #                 "destination_address_prefixes": [],
# #                 "destination_application_security_group_ids": [],
# #                 "destination_port_range": "5044",
# #                 "destination_port_ranges": [],
# #                 "direction": "Inbound",
# #                 "name": "AgentToLogtash",
# #                 "priority": 102,
# #                 "protocol": "Tcp",
# #                 "source_address_prefix": "*",
# #                 "source_address_prefixes": [],
# #                 "source_application_security_group_ids": [],
# #                 "source_port_range": "*",
# #                 "source_port_ranges": []
# #               },
# #               {
# #                 "access": "Allow",
# #                 "description": "",
# #                 "destination_address_prefix": "*",
# #                 "destination_address_prefixes": [],
# #                 "destination_application_security_group_ids": [],
# #                 "destination_port_range": "5601",
# #                 "destination_port_ranges": [],
# #                 "direction": "Inbound",
# #                 "name": "AgentToKibanaWhenFleet",
# #                 "priority": 103,
# #                 "protocol": "Tcp",
# #                 "source_address_prefix": "*",
# #                 "source_address_prefixes": [],
# #                 "source_application_security_group_ids": [],
# #                 "source_port_range": "*",
# #                 "source_port_ranges": []
# #               },
# #               {
# #                 "access": "Allow",
# #                 "description": "",
# #                 "destination_address_prefix": "*",
# #                 "destination_address_prefixes": [],
# #                 "destination_application_security_group_ids": [],
# #                 "destination_port_range": "8220",
# #                 "destination_port_ranges": [],
# #                 "direction": "Inbound",
# #                 "name": "AgentToFleet",
# #                 "priority": 100,
# #                 "protocol": "Tcp",
# #                 "source_address_prefix": "*",
# #                 "source_address_prefixes": [],
# #                 "source_application_security_group_ids": [],
# #                 "source_port_range": "*",
# #                 "source_port_ranges": []
# #               },
# #               {
# #                 "access": "Allow",
# #                 "description": "",
# #                 "destination_address_prefix": "*",
# #                 "destination_address_prefixes": [],
# #                 "destination_application_security_group_ids": [],
# #                 "destination_port_range": "9200",
# #                 "destination_port_ranges": [],
# #                 "direction": "Inbound",
# #                 "name": "AgentToElastic",
# #                 "priority": 101,
# #                 "protocol": "Tcp",
# #                 "source_address_prefix": "*",
# #                 "source_address_prefixes": [],
# #                 "source_application_security_group_ids": [],
# #                 "source_port_range": "*",
# #                 "source_port_ranges": []
# #               },
# #               {
# #                 "access": "Allow",
# #                 "description": "",
# #                 "destination_address_prefix": "*",
# #                 "destination_address_prefixes": [],
# #                 "destination_application_security_group_ids": [],
# #                 "destination_port_range": "9200",
# #                 "destination_port_ranges": [],
# #                 "direction": "Inbound",
# #                 "name": "FleetToElastic",
# #                 "priority": 104,
# #                 "protocol": "Tcp",
# #                 "source_address_prefix": "*",
# #                 "source_address_prefixes": [],
# #                 "source_application_security_group_ids": [],
# #                 "source_port_range": "*",
# #                 "source_port_ranges": []
# #               }
# #             ],
# #             "tags": {},
# #             "timeouts": null
# #           },
# #           "sensitive_attributes": [],
# #           "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxODAwMDAwMDAwMDAwLCJkZWxldGUiOjE4MDAwMDAwMDAwMDAsInJlYWQiOjMwMDAwMDAwMDAwMCwidXBkYXRlIjoxODAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIwIn0="
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "azurerm_public_ip",
# #       "name": "agent_public_ip",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "allocation_method": "Static",
# #             "ddos_protection_mode": "VirtualNetworkInherited",
# #             "ddos_protection_plan_id": null,
# #             "domain_name_label": null,
# #             "domain_name_label_scope": null,
# #             "edge_zone": "",
# #             "fqdn": null,
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/publicIPAddresses/AgentPubIP",
# #             "idle_timeout_in_minutes": 4,
# #             "ip_address": "108.143.25.71",
# #             "ip_tags": {},
# #             "ip_version": "IPv4",
# #             "location": "westeurope",
# #             "name": "AgentPubIP",
# #             "public_ip_prefix_id": null,
# #             "resource_group_name": "Dataplatform-Group-Monitoring",
# #             "reverse_fqdn": null,
# #             "sku": "Standard",
# #             "sku_tier": "Regional",
# #             "tags": {},
# #             "timeouts": null,
# #             "zones": []
# #           },
# #           "sensitive_attributes": [],
# #           "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxODAwMDAwMDAwMDAwLCJkZWxldGUiOjE4MDAwMDAwMDAwMDAsInJlYWQiOjMwMDAwMDAwMDAwMCwidXBkYXRlIjoxODAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIwIn0="
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "azurerm_public_ip",
# #       "name": "fleet_public_ip",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "allocation_method": "Static",
# #             "ddos_protection_mode": "VirtualNetworkInherited",
# #             "ddos_protection_plan_id": null,
# #             "domain_name_label": null,
# #             "domain_name_label_scope": null,
# #             "edge_zone": "",
# #             "fqdn": null,
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/publicIPAddresses/FleetPubIP",
# #             "idle_timeout_in_minutes": 4,
# #             "ip_address": "108.143.48.73",
# #             "ip_tags": {},
# #             "ip_version": "IPv4",
# #             "location": "westeurope",
# #             "name": "FleetPubIP",
# #             "public_ip_prefix_id": null,
# #             "resource_group_name": "Dataplatform-Group-Monitoring",
# #             "reverse_fqdn": null,
# #             "sku": "Standard",
# #             "sku_tier": "Regional",
# #             "tags": {},
# #             "timeouts": null,
# #             "zones": []
# #           },
# #           "sensitive_attributes": [],
# #           "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxODAwMDAwMDAwMDAwLCJkZWxldGUiOjE4MDAwMDAwMDAwMDAsInJlYWQiOjMwMDAwMDAwMDAwMCwidXBkYXRlIjoxODAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIwIn0="
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "azurerm_virtual_network",
# #       "name": "vnet",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "address_space": [
# #               "10.0.0.0/16"
# #             ],
# #             "bgp_community": "",
# #             "ddos_protection_plan": [],
# #             "dns_servers": [],
# #             "edge_zone": "",
# #             "encryption": [],
# #             "flow_timeout_in_minutes": 0,
# #             "guid": "969e100c-b1cd-48e1-a8f1-3d7f635a7bfe",
# #             "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/virtualNetworks/vnet-mon-innovationlab",
# #             "location": "westeurope",
# #             "name": "vnet-mon-innovationlab",
# #             "private_endpoint_vnet_policies": "Disabled",
# #             "resource_group_name": "Dataplatform-Group-Monitoring",
# #             "subnet": [
# #               {
# #                 "address_prefixes": [
# #                   "10.0.1.0/24"
# #                 ],
# #                 "default_outbound_access_enabled": true,
# #                 "delegation": [],
# #                 "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/virtualNetworks/vnet-mon-innovationlab/subnets/aks-subnet",
# #                 "name": "aks-subnet",
# #                 "private_endpoint_network_policies": "Disabled",
# #                 "private_link_service_network_policies_enabled": true,
# #                 "route_table_id": "",
# #                 "security_group": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/networkSecurityGroups/SecurityGroupGeneral",
# #                 "service_endpoint_policy_ids": [],
# #                 "service_endpoints": []
# #               },
# #               {
# #                 "address_prefixes": [
# #                   "10.0.2.0/24"
# #                 ],
# #                 "default_outbound_access_enabled": true,
# #                 "delegation": [],
# #                 "id": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/virtualNetworks/vnet-mon-innovationlab/subnets/agent-subnet",
# #                 "name": "agent-subnet",
# #                 "private_endpoint_network_policies": "Disabled",
# #                 "private_link_service_network_policies_enabled": true,
# #                 "route_table_id": "",
# #                 "security_group": "/subscriptions/642dd095-927a-4bdf-9152-d4f6609d0207/resourceGroups/Dataplatform-Group-Monitoring/providers/Microsoft.Network/networkSecurityGroups/SecurityGroupGeneral",
# #                 "service_endpoint_policy_ids": [],
# #                 "service_endpoints": []
# #               }
# #             ],
# #             "tags": {},
# #             "timeouts": null
# #           },
# #           "sensitive_attributes": [],
# #           "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxODAwMDAwMDAwMDAwLCJkZWxldGUiOjE4MDAwMDAwMDAwMDAsInJlYWQiOjMwMDAwMDAwMDAwMCwidXBkYXRlIjoxODAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIwIn0="
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "local_file",
# #       "name": "agent_vm_private_key",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "content": "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA3f6Ui1SmNwXTJMO7e/xhpMwjyhiOjbG2jxRWW+SVWm2L89NZ\nTGnOtM1GpQaQCvJq7HdD8wutxev4mAKS3PogiRQhvHgTrxzutObSW8rgdiyYAoSO\nUp7sfgd4Yfng9iLaqJ0DP1odJNI/QcCRcRokRUmkrnapTrLDKQDhOsjWZ3r4jzmM\ni6jo8srFN83YrkCxFhswjADmayfut2AM1DQEuPzTEHaAa2oRcA0SOoffkR2LenNH\nwgmoIGQnjLQy2ECwxF7Ax5gUP5YyRhIfj9/ME9/Ax/t+GQwF5W78RCUHAyyXAaF5\nwZnHiVsaAuyiwYdk45qDauTEMG5/SXPZ7qXZHQIDAQABAoIBAAJrb55j1M/4DfNy\nTWKDlLjhdL5o2BzumUkj9UZZI9DxgrtXTBDg0lz2zn9RUVPyjScjVv1Dh6hcSGsN\nFCFjzzj58YgxXYg6GNal8W2zX2ZKWXnQN2Y/zzTBy2vIongXAdUhU6i8Hbc0siB7\nAzAoEx8iN1ujdXhNyyzGPVjmWYKVN6+d3fRNEwnIWL2aePEcYBzc8XSoAfX81kB7\nbsRti8oNWbN6RwNNPELq9Y09r5SbvNLWY8SGuEHXhIa9vxEviQ1Yknpb6TCvwr2X\nWZBn5+MP1Dq2xk3xd8jSvaKX28mcDqMN+0SOqUhjJ+cBc09HknI2ivcbk8XxSqdM\nCxszcaECgYEA89O9XUONIZ0U/lJFPr62C7e8p+Ip4NtMMiPyeKhQ8g3dZb1v+JrB\nhIpyRgSTntxAIldu8rHYTeaQUSBjbIC9Nd4XzjDH+eZBJFXIn7M+cgVdlQW7G2eN\nArmxUaC6UPGOUlqyVxdzjaeE0D63HkddKJwDVExSHR6l06iY3OJlmqkCgYEA6RPO\nSYCaKfCClJ9VwWMQXA4Srst7DmdQmdGKR2jRb0YCudbqZsGjF6crDhSKPMdEWUgX\nllFcrJIRldKYCnUpj9jptqU/XG819ijgzEiSbxfO/3vjjzusBsUOnWDSJTyPP1sY\nWkI+5FUTtJ/EZYPDmWo8zzMqDKl5IuBG9D1j51UCgYA47TWoAa6Aq5EMM58RICuW\nnsZAGBCY+/pVNolU3E9RxCTtrQXocBFAZaZ6bHUewOOEYQ95QEZ1IaCOIFa2LXR/\nkCPUsxTtZnHNDu4xQwMQUepgcZ8Wrd2BRmN84F6/qTYGSkCbDtGev/7FM+9C9Xxt\nj8dDNjJxtAcZXKKb54u7SQKBgGwWOzvq35NDbcrueR5NinCmNhPJWS+8yawLeEzV\nVwp7NRhpihpNAg0eAOFutQyqfA/LVuTmpkuBEZahKtDutG948Ck7SL7c8/FL07Po\nk7/hEqV4Fnd9/LDHAZgKJmoOQ3/mBs0Um4XXzmOdE77f8/1ZPwn3eDCXBw4dY8ow\nDfxhAoGBAOeikq/9hbqSxzkdDfKguEaCyG2dlhT3QNvGIADQM5lb3x7GuDyER29A\nGeNfiTZbvdrGozxu6QCsdwUUTBuIvH3jiNIYEK692bV/MrWK91o3UON3GF+v1KLf\n7BgtLfanOcNsy/HgH4H/bXqMPT2FiMOmhGgDcgWqF4AtEstbGIFg\n-----END RSA PRIVATE KEY-----\n",
# #             "content_base64": null,
# #             "content_base64sha256": "iTCqyNAR4O8flF3D1hiir0t7DPkwNjjSDbM0A9YgoO8=",
# #             "content_base64sha512": "FLpxSxlhbMI5u+vIrm7KDi60CrLC4AMqF4VXis5S8MIbve4dlEHqPXYOAqSeb0+A+f3L4x3fQPIFrYR3zeRbbg==",
# #             "content_md5": "c47aa8f733f13a1896a3352d2d486df4",
# #             "content_sha1": "414561dec1e97175e831d5a0fcef72d5814aa5e3",
# #             "content_sha256": "8930aac8d011e0ef1f945dc3d618a2af4b7b0cf9303638d20db33403d620a0ef",
# #             "content_sha512": "14ba714b19616cc239bbebc8ae6eca0e2eb40ab2c2e0032a1785578ace52f0c21bbdee1d9441ea3d760e02a49e6f4f80f9fdcbe31ddf40f205ad8477cde45b6e",
# #             "directory_permission": "0777",
# #             "file_permission": "0600",
# #             "filename": "./ssh/agent_vm_id_rsa",
# #             "id": "414561dec1e97175e831d5a0fcef72d5814aa5e3",
# #             "sensitive_content": null,
# #             "source": null
# #           },
# #           "sensitive_attributes": [
# #             [
# #               {
# #                 "type": "get_attr",
# #                 "value": "content"
# #               }
# #             ]
# #           ],
# #           "dependencies": [
# #             "local_file.create_ssh_folder",
# #             "tls_private_key.agent_vm_key"
# #           ]
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "local_file",
# #       "name": "agent_vm_public_key",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "content": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd/pSLVKY3BdMkw7t7/GGkzCPKGI6NsbaPFFZb5JVabYvz01lMac60zUalBpAK8mrsd0PzC63F6/iYApLc+iCJFCG8eBOvHO605tJbyuB2LJgChI5Snux+B3hh+eD2ItqonQM/Wh0k0j9BwJFxGiRFSaSudqlOssMpAOE6yNZneviPOYyLqOjyysU3zdiuQLEWGzCMAOZrJ+63YAzUNAS4/NMQdoBrahFwDRI6h9+RHYt6c0fCCaggZCeMtDLYQLDEXsDHmBQ/ljJGEh+P38wT38DH+34ZDAXlbvxEJQcDLJcBoXnBmceJWxoC7KLBh2TjmoNq5MQwbn9Jc9nupdkd\n",
# #             "content_base64": null,
# #             "content_base64sha256": "CezO67FrL9RCyfVqkF0tVRcjSMjPlzDtCP5jmnhakBk=",
# #             "content_base64sha512": "ZtjLnQARgwh3GKKvyUEdu9lGO3+QcwIw+k18dCBLBeZXVuaDA4Fio71QrWrOQ67F9dZTBGKtTzkhGLb4O2487Q==",
# #             "content_md5": "7977c635d6f802816f13497197fbe641",
# #             "content_sha1": "6a7c1fda322efc933387431061fbd556c40c1789",
# #             "content_sha256": "09ecceebb16b2fd442c9f56a905d2d55172348c8cf9730ed08fe639a785a9019",
# #             "content_sha512": "66d8cb9d001183087718a2afc9411dbbd9463b7f90730230fa4d7c74204b05e65756e683038162a3bd50ad6ace43aec5f5d6530462ad4f392118b6f83b6e3ced",
# #             "directory_permission": "0777",
# #             "file_permission": "0777",
# #             "filename": "./ssh/agent_vm_id_rsa.pub",
# #             "id": "6a7c1fda322efc933387431061fbd556c40c1789",
# #             "sensitive_content": null,
# #             "source": null
# #           },
# #           "sensitive_attributes": [],
# #           "dependencies": [
# #             "local_file.create_ssh_folder",
# #             "tls_private_key.agent_vm_key"
# #           ]
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "local_file",
# #       "name": "create_ssh_folder",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "content": "",
# #             "content_base64": null,
# #             "content_base64sha256": "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
# #             "content_base64sha512": "z4PhNX7vuL3xVChQ1m2AB9Yg5AULVxXcg/SpIdNs6c5H0NE8XYXysP+DGNKHfuwvY7kxvUdBeoGlODJ6+SfaPg==",
# #             "content_md5": "d41d8cd98f00b204e9800998ecf8427e",
# #             "content_sha1": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
# #             "content_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
# #             "content_sha512": "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
# #             "directory_permission": "0777",
# #             "file_permission": "0777",
# #             "filename": "./ssh/.placeholder",
# #             "id": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
# #             "sensitive_content": null,
# #             "source": null
# #           },
# #           "sensitive_attributes": []
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "local_file",
# #       "name": "fleet_vm_private_key",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "content": "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAsxM+vppuEje6rr0FoOL6UYX4oqnP7onJv51l9Yw9V3yT4KGQ\n3Q1Oee0g+zf9qh+mpy6hzcuv6152VEXHs7pKt+RchhXK/B70LgrqlmH8e5sOnbCG\n+rFIJCVemOFwg1xFuV8Ik4gorNYVYoMgIFiEIWr/0IrAc6k9E0qy3l1ZbDBbsNxH\nGOQ/Z/wbCNgrQjs/PY34udIzLOw8e1nXCotemprnu8TTSy4XJblfiYdNQm/NEXcF\nAOKTrMvyMRjcsbWBBrY4JhH/IyE7PgxNRqesIwWWTnwO1QmwGuKpsieT86slJYLc\nVKkt9KQ/MkYFlv9JuA3ikqqFXPPK1IGymdKOxwIDAQABAoIBAFawveLK4vdpyDOY\naTWiPBkkOKISgAlT5fmfqoDNI9MLCZGo1XbV3sRSwfEsAV6O1QBBKG52qVLR14nj\ngBJnYI2WfR4iRbJ5D6+MdFVZ2T9DaLd5AlcxZKGu/5UWKgBFtrFPKtk1BK/rMc4P\neYl/IHQHFxFvYkx7xQfmVSIl4cjn7njgOycKMUw6yM8QBtHgl2kiJL9iyP2K0F2p\nC24/0mRF3fcm2nwnWeqCSKpt92+Eckx/0Y3yyudiZL9nKXcs0IwpU0mbK7LSkbGT\nm+Lk2MvDaSenKxhEhJjHWCmrk3t1a5iuGVO5HkOCHyc0dZIdjVp8B+CUyq+CrPYq\nl/TEORUCgYEA5D78i30NxjxQDjuSpxVK8dCeuolj3oS7ZCORZCmKiHlfjWKbXHSa\nBrdRlVCSohQz1ifJS96xuhDKUse6Y1N7Eg+qD/8sXfNTp8QX7nKDiNl4lCo4Doj3\navFBjgpe7si5CJRVAOQHV4Zz8Vtk39VsAgrV/E24uIVjvl1mXFD9yGsCgYEAyNmh\nkb6pIIaMUYjWARFX8iryNIfIApnetjtHtSrIqcgyYeFpdDtbZjnFHDGAw1wAmkT5\nVT3dVFIe1uAReiC8iBeL2DaYcpF+8Jpo15nTKxS+74zdc2CS3cjg/plUkFdrK3lE\n6xEj9TVeMvNxVWglX3SgqwSb/A0V0wP4ZLaC2hUCgYEAmIvETBHbV+dNdgW4wTTI\n7w8IVxGmDr1VZNsku/XLoeTEyQDjZwqDOwPgYdQE/JBWCMZ0keGXlQzNvD/Cwcm0\nkmCnv6NC6tPK0HCNsg8U/CykmxoQdx5xhicSMjWaNysuB57jpQHCKmwxJ1l29OZ2\nFnNZixQC5kg4Xq2b0Q1MYFsCgYBi7Y7/UoHLW3pRzqxZ6kj/JtgVt6t0XIWuDJTN\nTz13Ivxt6bEfZv0l5N6JfHiHwREq6z5EFiymE6zM+aCiHu29uptO69U62R9FM0jg\nqQux9I33P9LzuWWdiAwKW0ujrOtEhn7DqbWkWZ0ES5RPFPUTh0Z79dE+3NMbFKGM\nOblJ4QKBgEAFmMFy4mosWDNeoLQtk+Sj0gE74WIl20HN1j2hBFWDxSqNwwrM1SDx\nX52ug/2nRXdO/KRIGwF4CLHMMZNvYbPMWziN3PC7QEetob5JUGBEYJpJM9G6iom/\n6GIaL2gPs0mBKUpW2QreiN5djFSIo7LRr9dyDt46keSUfwJ5xQUV\n-----END RSA PRIVATE KEY-----\n",
# #             "content_base64": null,
# #             "content_base64sha256": "rwrBE6B5/s4yeQ1Uc8YMkCBOrDh9LRTSZPvwMwNei/k=",
# #             "content_base64sha512": "RZCX9qtuxGNn1cyICrUagtD3fk7OGNpRYoAfrYDcmDvwj3cGU+WxoejLfQHJdy3ROVscu0OuLykZL2/aYJTeJg==",
# #             "content_md5": "e06680edc57ba03c60b38baa4957d3ad",
# #             "content_sha1": "9bf37c0f55c0d9a4fc65bd48b4e0d3edb90ff87d",
# #             "content_sha256": "af0ac113a079fece32790d5473c60c90204eac387d2d14d264fbf033035e8bf9",
# #             "content_sha512": "459097f6ab6ec46367d5cc880ab51a82d0f77e4ece18da5162801fad80dc983bf08f770653e5b1a1e8cb7d01c9772dd1395b1cbb43ae2f29192f6fda6094de26",
# #             "directory_permission": "0777",
# #             "file_permission": "0600",
# #             "filename": "./ssh/fleet_vm_id_rsa",
# #             "id": "9bf37c0f55c0d9a4fc65bd48b4e0d3edb90ff87d",
# #             "sensitive_content": null,
# #             "source": null
# #           },
# #           "sensitive_attributes": [
# #             [
# #               {
# #                 "type": "get_attr",
# #                 "value": "content"
# #               }
# #             ]
# #           ],
# #           "dependencies": [
# #             "local_file.create_ssh_folder",
# #             "tls_private_key.fleet_vm_key"
# #           ]
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "local_file",
# #       "name": "fleet_vm_public_key",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "content": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzEz6+mm4SN7quvQWg4vpRhfiiqc/uicm/nWX1jD1XfJPgoZDdDU557SD7N/2qH6anLqHNy6/rXnZURcezukq35FyGFcr8HvQuCuqWYfx7mw6dsIb6sUgkJV6Y4XCDXEW5XwiTiCis1hVigyAgWIQhav/QisBzqT0TSrLeXVlsMFuw3EcY5D9n/BsI2CtCOz89jfi50jMs7Dx7WdcKi16amue7xNNLLhcluV+Jh01Cb80RdwUA4pOsy/IxGNyxtYEGtjgmEf8jITs+DE1Gp6wjBZZOfA7VCbAa4qmyJ5PzqyUlgtxUqS30pD8yRgWW/0m4DeKSqoVc88rUgbKZ0o7H\n",
# #             "content_base64": null,
# #             "content_base64sha256": "MGYQ35sEzXln/ncvOc7b3OCnHQv8wscRwQufritE44A=",
# #             "content_base64sha512": "THEEN4j+ZCHiY3XqHoHegT2S4+lr/2ZFiaTuuvDdYNnDZhEebR5FMjZixQwy0QtVI2RL5JfTw4JocvkJjp1XBA==",
# #             "content_md5": "11899f3bbfeed58169d755fe2475c346",
# #             "content_sha1": "6a2fff5953623f64969225ab3c7708a47d3e42dd",
# #             "content_sha256": "306610df9b04cd7967fe772f39cedbdce0a71d0bfcc2c711c10b9fae2b44e380",
# #             "content_sha512": "4c71043788fe6421e26375ea1e81de813d92e3e96bff664589a4eebaf0dd60d9c366111e6d1e45323662c50c32d10b5523644be497d3c3826872f9098e9d5704",
# #             "directory_permission": "0777",
# #             "file_permission": "0777",
# #             "filename": "./ssh/fleet_vm_id_rsa.pub",
# #             "id": "6a2fff5953623f64969225ab3c7708a47d3e42dd",
# #             "sensitive_content": null,
# #             "source": null
# #           },
# #           "sensitive_attributes": [],
# #           "dependencies": [
# #             "local_file.create_ssh_folder",
# #             "tls_private_key.fleet_vm_key"
# #           ]
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "null_resource",
# #       "name": "set_subscription",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
# #       "instances": [
# #         {
# #           "schema_version": 0,
# #           "attributes": {
# #             "id": "4966855763932782161",
# #             "triggers": null
# #           },
# #           "sensitive_attributes": []
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "tls_private_key",
# #       "name": "agent_vm_key",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/tls\"]",
# #       "instances": [
# #         {
# #           "schema_version": 1,
# #           "attributes": {
# #             "algorithm": "RSA",
# #             "ecdsa_curve": "P224",
# #             "id": "c8fb80674c30c895cb86cf6bf6178f4b01756814",
# #             "private_key_openssh": "-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdz\nc2gtcnNhAAAAAwEAAQAAAQEA3f6Ui1SmNwXTJMO7e/xhpMwjyhiOjbG2jxRWW+SV\nWm2L89NZTGnOtM1GpQaQCvJq7HdD8wutxev4mAKS3PogiRQhvHgTrxzutObSW8rg\ndiyYAoSOUp7sfgd4Yfng9iLaqJ0DP1odJNI/QcCRcRokRUmkrnapTrLDKQDhOsjW\nZ3r4jzmMi6jo8srFN83YrkCxFhswjADmayfut2AM1DQEuPzTEHaAa2oRcA0SOoff\nkR2LenNHwgmoIGQnjLQy2ECwxF7Ax5gUP5YyRhIfj9/ME9/Ax/t+GQwF5W78RCUH\nAyyXAaF5wZnHiVsaAuyiwYdk45qDauTEMG5/SXPZ7qXZHQAAA7hJc5jtSXOY7QAA\nAAdzc2gtcnNhAAABAQDd/pSLVKY3BdMkw7t7/GGkzCPKGI6NsbaPFFZb5JVabYvz\n01lMac60zUalBpAK8mrsd0PzC63F6/iYApLc+iCJFCG8eBOvHO605tJbyuB2LJgC\nhI5Snux+B3hh+eD2ItqonQM/Wh0k0j9BwJFxGiRFSaSudqlOssMpAOE6yNZneviP\nOYyLqOjyysU3zdiuQLEWGzCMAOZrJ+63YAzUNAS4/NMQdoBrahFwDRI6h9+RHYt6\nc0fCCaggZCeMtDLYQLDEXsDHmBQ/ljJGEh+P38wT38DH+34ZDAXlbvxEJQcDLJcB\noXnBmceJWxoC7KLBh2TjmoNq5MQwbn9Jc9nupdkdAAAAAwEAAQAAAQACa2+eY9TP\n+A3zck1ig5S44XS+aNgc7plJI/VGWSPQ8YK7V0wQ4NJc9s5/UVFT8o0nI1b9Q4eo\nXEhrDRQhY884+fGIMV2IOhjWpfFts19mSll50DdmP880wctryKJ4FwHVIVOovB23\nNLIgewMwKBMfIjdbo3V4Tcssxj1Y5lmClTevnd30TRMJyFi9mnjxHGAc3PF0qAH1\n/NZAe27EbYvKDVmzekcDTTxC6vWNPa+Um7zS1mPEhrhB14SGvb8RL4kNWJJ6W+kw\nr8K9l1mQZ+fjD9Q6tsZN8XfI0r2il9vJnA6jDftEjqlIYyfnAXNPR5JyNor3G5PF\n8UqnTAsbM3GhAAAAgQDnopKv/YW6ksc5HQ3yoLhGgshtnZYU90DbxiAA0DOZW98e\nxrg8hEdvQBnjX4k2W73axqM8bukArHcFFEwbiLx944jSGBCuvdm1fzK1ivdaN1Dj\ndxhfr9Si3+wYLS32pznDbMvx4B+B/216jD09hYjDpoRoA3IFqheALRLLWxiBYAAA\nAIEA89O9XUONIZ0U/lJFPr62C7e8p+Ip4NtMMiPyeKhQ8g3dZb1v+JrBhIpyRgST\nntxAIldu8rHYTeaQUSBjbIC9Nd4XzjDH+eZBJFXIn7M+cgVdlQW7G2eNArmxUaC6\nUPGOUlqyVxdzjaeE0D63HkddKJwDVExSHR6l06iY3OJlmqkAAACBAOkTzkmAminw\ngpSfVcFjEFwOEq7Lew5nUJnRikdo0W9GArnW6mbBoxenKw4UijzHRFlIF5ZRXKyS\nEZXSmAp1KY/Y6balP1xvNfYo4MxIkm8Xzv974487rAbFDp1g0iU8jz9bGFpCPuRV\nE7SfxGWDw5lqPM8zKgypeSLgRvQ9Y+dVAAAAAAEC\n-----END OPENSSH PRIVATE KEY-----\n",
# #             "private_key_pem": "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA3f6Ui1SmNwXTJMO7e/xhpMwjyhiOjbG2jxRWW+SVWm2L89NZ\nTGnOtM1GpQaQCvJq7HdD8wutxev4mAKS3PogiRQhvHgTrxzutObSW8rgdiyYAoSO\nUp7sfgd4Yfng9iLaqJ0DP1odJNI/QcCRcRokRUmkrnapTrLDKQDhOsjWZ3r4jzmM\ni6jo8srFN83YrkCxFhswjADmayfut2AM1DQEuPzTEHaAa2oRcA0SOoffkR2LenNH\nwgmoIGQnjLQy2ECwxF7Ax5gUP5YyRhIfj9/ME9/Ax/t+GQwF5W78RCUHAyyXAaF5\nwZnHiVsaAuyiwYdk45qDauTEMG5/SXPZ7qXZHQIDAQABAoIBAAJrb55j1M/4DfNy\nTWKDlLjhdL5o2BzumUkj9UZZI9DxgrtXTBDg0lz2zn9RUVPyjScjVv1Dh6hcSGsN\nFCFjzzj58YgxXYg6GNal8W2zX2ZKWXnQN2Y/zzTBy2vIongXAdUhU6i8Hbc0siB7\nAzAoEx8iN1ujdXhNyyzGPVjmWYKVN6+d3fRNEwnIWL2aePEcYBzc8XSoAfX81kB7\nbsRti8oNWbN6RwNNPELq9Y09r5SbvNLWY8SGuEHXhIa9vxEviQ1Yknpb6TCvwr2X\nWZBn5+MP1Dq2xk3xd8jSvaKX28mcDqMN+0SOqUhjJ+cBc09HknI2ivcbk8XxSqdM\nCxszcaECgYEA89O9XUONIZ0U/lJFPr62C7e8p+Ip4NtMMiPyeKhQ8g3dZb1v+JrB\nhIpyRgSTntxAIldu8rHYTeaQUSBjbIC9Nd4XzjDH+eZBJFXIn7M+cgVdlQW7G2eN\nArmxUaC6UPGOUlqyVxdzjaeE0D63HkddKJwDVExSHR6l06iY3OJlmqkCgYEA6RPO\nSYCaKfCClJ9VwWMQXA4Srst7DmdQmdGKR2jRb0YCudbqZsGjF6crDhSKPMdEWUgX\nllFcrJIRldKYCnUpj9jptqU/XG819ijgzEiSbxfO/3vjjzusBsUOnWDSJTyPP1sY\nWkI+5FUTtJ/EZYPDmWo8zzMqDKl5IuBG9D1j51UCgYA47TWoAa6Aq5EMM58RICuW\nnsZAGBCY+/pVNolU3E9RxCTtrQXocBFAZaZ6bHUewOOEYQ95QEZ1IaCOIFa2LXR/\nkCPUsxTtZnHNDu4xQwMQUepgcZ8Wrd2BRmN84F6/qTYGSkCbDtGev/7FM+9C9Xxt\nj8dDNjJxtAcZXKKb54u7SQKBgGwWOzvq35NDbcrueR5NinCmNhPJWS+8yawLeEzV\nVwp7NRhpihpNAg0eAOFutQyqfA/LVuTmpkuBEZahKtDutG948Ck7SL7c8/FL07Po\nk7/hEqV4Fnd9/LDHAZgKJmoOQ3/mBs0Um4XXzmOdE77f8/1ZPwn3eDCXBw4dY8ow\nDfxhAoGBAOeikq/9hbqSxzkdDfKguEaCyG2dlhT3QNvGIADQM5lb3x7GuDyER29A\nGeNfiTZbvdrGozxu6QCsdwUUTBuIvH3jiNIYEK692bV/MrWK91o3UON3GF+v1KLf\n7BgtLfanOcNsy/HgH4H/bXqMPT2FiMOmhGgDcgWqF4AtEstbGIFg\n-----END RSA PRIVATE KEY-----\n",
# #             "private_key_pem_pkcs8": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDd/pSLVKY3BdMk\nw7t7/GGkzCPKGI6NsbaPFFZb5JVabYvz01lMac60zUalBpAK8mrsd0PzC63F6/iY\nApLc+iCJFCG8eBOvHO605tJbyuB2LJgChI5Snux+B3hh+eD2ItqonQM/Wh0k0j9B\nwJFxGiRFSaSudqlOssMpAOE6yNZneviPOYyLqOjyysU3zdiuQLEWGzCMAOZrJ+63\nYAzUNAS4/NMQdoBrahFwDRI6h9+RHYt6c0fCCaggZCeMtDLYQLDEXsDHmBQ/ljJG\nEh+P38wT38DH+34ZDAXlbvxEJQcDLJcBoXnBmceJWxoC7KLBh2TjmoNq5MQwbn9J\nc9nupdkdAgMBAAECggEAAmtvnmPUz/gN83JNYoOUuOF0vmjYHO6ZSSP1Rlkj0PGC\nu1dMEODSXPbOf1FRU/KNJyNW/UOHqFxIaw0UIWPPOPnxiDFdiDoY1qXxbbNfZkpZ\nedA3Zj/PNMHLa8iieBcB1SFTqLwdtzSyIHsDMCgTHyI3W6N1eE3LLMY9WOZZgpU3\nr53d9E0TCchYvZp48RxgHNzxdKgB9fzWQHtuxG2Lyg1Zs3pHA008Qur1jT2vlJu8\n0tZjxIa4QdeEhr2/ES+JDViSelvpMK/CvZdZkGfn4w/UOrbGTfF3yNK9opfbyZwO\now37RI6pSGMn5wFzT0eScjaK9xuTxfFKp0wLGzNxoQKBgQDz071dQ40hnRT+UkU+\nvrYLt7yn4ing20wyI/J4qFDyDd1lvW/4msGEinJGBJOe3EAiV27ysdhN5pBRIGNs\ngL013hfOMMf55kEkVcifsz5yBV2VBbsbZ40CubFRoLpQ8Y5SWrJXF3ONp4TQPrce\nR10onANUTFIdHqXTqJjc4mWaqQKBgQDpE85JgJop8IKUn1XBYxBcDhKuy3sOZ1CZ\n0YpHaNFvRgK51upmwaMXpysOFIo8x0RZSBeWUVyskhGV0pgKdSmP2Om2pT9cbzX2\nKODMSJJvF87/e+OPO6wGxQ6dYNIlPI8/WxhaQj7kVRO0n8Rlg8OZajzPMyoMqXki\n4Eb0PWPnVQKBgDjtNagBroCrkQwznxEgK5aexkAYEJj7+lU2iVTcT1HEJO2tBehw\nEUBlpnpsdR7A44RhD3lARnUhoI4gVrYtdH+QI9SzFO1mcc0O7jFDAxBR6mBxnxat\n3YFGY3zgXr+pNgZKQJsO0Z6//sUz70L1fG2Px0M2MnG0Bxlcopvni7tJAoGAbBY7\nO+rfk0Ntyu55Hk2KcKY2E8lZL7zJrAt4TNVXCns1GGmKGk0CDR4A4W61DKp8D8tW\n5OamS4ERlqEq0O60b3jwKTtIvtzz8UvTs+iTv+ESpXgWd338sMcBmAomag5Df+YG\nzRSbhdfOY50Tvt/z/Vk/Cfd4MJcHDh1jyjAN/GECgYEA56KSr/2FupLHOR0N8qC4\nRoLIbZ2WFPdA28YgANAzmVvfHsa4PIRHb0AZ41+JNlu92sajPG7pAKx3BRRMG4i8\nfeOI0hgQrr3ZtX8ytYr3WjdQ43cYX6/Uot/sGC0t9qc5w2zL8eAfgf9teow9PYWI\nw6aEaANyBaoXgC0Sy1sYgWA=\n-----END PRIVATE KEY-----\n",
# #             "public_key_fingerprint_md5": "5a:e9:97:ec:54:f1:20:ac:09:04:a7:f6:eb:91:7a:54",
# #             "public_key_fingerprint_sha256": "SHA256:BHDh8a8BrMEklet6RocJSJ731ZO0GfIlyb9zFvNOOac",
# #             "public_key_openssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDd/pSLVKY3BdMkw7t7/GGkzCPKGI6NsbaPFFZb5JVabYvz01lMac60zUalBpAK8mrsd0PzC63F6/iYApLc+iCJFCG8eBOvHO605tJbyuB2LJgChI5Snux+B3hh+eD2ItqonQM/Wh0k0j9BwJFxGiRFSaSudqlOssMpAOE6yNZneviPOYyLqOjyysU3zdiuQLEWGzCMAOZrJ+63YAzUNAS4/NMQdoBrahFwDRI6h9+RHYt6c0fCCaggZCeMtDLYQLDEXsDHmBQ/ljJGEh+P38wT38DH+34ZDAXlbvxEJQcDLJcBoXnBmceJWxoC7KLBh2TjmoNq5MQwbn9Jc9nupdkd\n",
# #             "public_key_pem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3f6Ui1SmNwXTJMO7e/xh\npMwjyhiOjbG2jxRWW+SVWm2L89NZTGnOtM1GpQaQCvJq7HdD8wutxev4mAKS3Pog\niRQhvHgTrxzutObSW8rgdiyYAoSOUp7sfgd4Yfng9iLaqJ0DP1odJNI/QcCRcRok\nRUmkrnapTrLDKQDhOsjWZ3r4jzmMi6jo8srFN83YrkCxFhswjADmayfut2AM1DQE\nuPzTEHaAa2oRcA0SOoffkR2LenNHwgmoIGQnjLQy2ECwxF7Ax5gUP5YyRhIfj9/M\nE9/Ax/t+GQwF5W78RCUHAyyXAaF5wZnHiVsaAuyiwYdk45qDauTEMG5/SXPZ7qXZ\nHQIDAQAB\n-----END PUBLIC KEY-----\n",
# #             "rsa_bits": 2048
# #           },
# #           "sensitive_attributes": []
# #         }
# #       ]
# #     },
# #     {
# #       "mode": "managed",
# #       "type": "tls_private_key",
# #       "name": "fleet_vm_key",
# #       "provider": "provider[\"registry.terraform.io/hashicorp/tls\"]",
# #       "instances": [
# #         {
# #           "schema_version": 1,
# #           "attributes": {
# #             "algorithm": "RSA",
# #             "ecdsa_curve": "P224",
# #             "id": "126d32419e5d7896102cbc357398b73a03247393",
# #             "private_key_openssh": "-----BEGIN OPENSSH PRIVATE KEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdz\nc2gtcnNhAAAAAwEAAQAAAQEAsxM+vppuEje6rr0FoOL6UYX4oqnP7onJv51l9Yw9\nV3yT4KGQ3Q1Oee0g+zf9qh+mpy6hzcuv6152VEXHs7pKt+RchhXK/B70LgrqlmH8\ne5sOnbCG+rFIJCVemOFwg1xFuV8Ik4gorNYVYoMgIFiEIWr/0IrAc6k9E0qy3l1Z\nbDBbsNxHGOQ/Z/wbCNgrQjs/PY34udIzLOw8e1nXCotemprnu8TTSy4XJblfiYdN\nQm/NEXcFAOKTrMvyMRjcsbWBBrY4JhH/IyE7PgxNRqesIwWWTnwO1QmwGuKpsieT\n86slJYLcVKkt9KQ/MkYFlv9JuA3ikqqFXPPK1IGymdKOxwAAA7hOPQveTj0L3gAA\nAAdzc2gtcnNhAAABAQCzEz6+mm4SN7quvQWg4vpRhfiiqc/uicm/nWX1jD1XfJPg\noZDdDU557SD7N/2qH6anLqHNy6/rXnZURcezukq35FyGFcr8HvQuCuqWYfx7mw6d\nsIb6sUgkJV6Y4XCDXEW5XwiTiCis1hVigyAgWIQhav/QisBzqT0TSrLeXVlsMFuw\n3EcY5D9n/BsI2CtCOz89jfi50jMs7Dx7WdcKi16amue7xNNLLhcluV+Jh01Cb80R\ndwUA4pOsy/IxGNyxtYEGtjgmEf8jITs+DE1Gp6wjBZZOfA7VCbAa4qmyJ5PzqyUl\ngtxUqS30pD8yRgWW/0m4DeKSqoVc88rUgbKZ0o7HAAAAAwEAAQAAAQBWsL3iyuL3\nacgzmGk1ojwZJDiiEoAJU+X5n6qAzSPTCwmRqNV21d7EUsHxLAFejtUAQShudqlS\n0deJ44ASZ2CNln0eIkWyeQ+vjHRVWdk/Q2i3eQJXMWShrv+VFioARbaxTyrZNQSv\n6zHOD3mJfyB0BxcRb2JMe8UH5lUiJeHI5+544DsnCjFMOsjPEAbR4JdpIiS/Ysj9\nitBdqQtuP9JkRd33Jtp8J1nqgkiqbfdvhHJMf9GN8srnYmS/Zyl3LNCMKVNJmyuy\n0pGxk5vi5NjLw2knpysYRISYx1gpq5N7dWuYrhlTuR5Dgh8nNHWSHY1afAfglMqv\ngqz2Kpf0xDkVAAAAgEAFmMFy4mosWDNeoLQtk+Sj0gE74WIl20HN1j2hBFWDxSqN\nwwrM1SDxX52ug/2nRXdO/KRIGwF4CLHMMZNvYbPMWziN3PC7QEetob5JUGBEYJpJ\nM9G6iom/6GIaL2gPs0mBKUpW2QreiN5djFSIo7LRr9dyDt46keSUfwJ5xQUVAAAA\ngQDkPvyLfQ3GPFAOO5KnFUrx0J66iWPehLtkI5FkKYqIeV+NYptcdJoGt1GVUJKi\nFDPWJ8lL3rG6EMpSx7pjU3sSD6oP/yxd81OnxBfucoOI2XiUKjgOiPdq8UGOCl7u\nyLkIlFUA5AdXhnPxW2Tf1WwCCtX8Tbi4hWO+XWZcUP3IawAAAIEAyNmhkb6pIIaM\nUYjWARFX8iryNIfIApnetjtHtSrIqcgyYeFpdDtbZjnFHDGAw1wAmkT5VT3dVFIe\n1uAReiC8iBeL2DaYcpF+8Jpo15nTKxS+74zdc2CS3cjg/plUkFdrK3lE6xEj9TVe\nMvNxVWglX3SgqwSb/A0V0wP4ZLaC2hUAAAAAAQID\n-----END OPENSSH PRIVATE KEY-----\n",
# #             "private_key_pem": "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAsxM+vppuEje6rr0FoOL6UYX4oqnP7onJv51l9Yw9V3yT4KGQ\n3Q1Oee0g+zf9qh+mpy6hzcuv6152VEXHs7pKt+RchhXK/B70LgrqlmH8e5sOnbCG\n+rFIJCVemOFwg1xFuV8Ik4gorNYVYoMgIFiEIWr/0IrAc6k9E0qy3l1ZbDBbsNxH\nGOQ/Z/wbCNgrQjs/PY34udIzLOw8e1nXCotemprnu8TTSy4XJblfiYdNQm/NEXcF\nAOKTrMvyMRjcsbWBBrY4JhH/IyE7PgxNRqesIwWWTnwO1QmwGuKpsieT86slJYLc\nVKkt9KQ/MkYFlv9JuA3ikqqFXPPK1IGymdKOxwIDAQABAoIBAFawveLK4vdpyDOY\naTWiPBkkOKISgAlT5fmfqoDNI9MLCZGo1XbV3sRSwfEsAV6O1QBBKG52qVLR14nj\ngBJnYI2WfR4iRbJ5D6+MdFVZ2T9DaLd5AlcxZKGu/5UWKgBFtrFPKtk1BK/rMc4P\neYl/IHQHFxFvYkx7xQfmVSIl4cjn7njgOycKMUw6yM8QBtHgl2kiJL9iyP2K0F2p\nC24/0mRF3fcm2nwnWeqCSKpt92+Eckx/0Y3yyudiZL9nKXcs0IwpU0mbK7LSkbGT\nm+Lk2MvDaSenKxhEhJjHWCmrk3t1a5iuGVO5HkOCHyc0dZIdjVp8B+CUyq+CrPYq\nl/TEORUCgYEA5D78i30NxjxQDjuSpxVK8dCeuolj3oS7ZCORZCmKiHlfjWKbXHSa\nBrdRlVCSohQz1ifJS96xuhDKUse6Y1N7Eg+qD/8sXfNTp8QX7nKDiNl4lCo4Doj3\navFBjgpe7si5CJRVAOQHV4Zz8Vtk39VsAgrV/E24uIVjvl1mXFD9yGsCgYEAyNmh\nkb6pIIaMUYjWARFX8iryNIfIApnetjtHtSrIqcgyYeFpdDtbZjnFHDGAw1wAmkT5\nVT3dVFIe1uAReiC8iBeL2DaYcpF+8Jpo15nTKxS+74zdc2CS3cjg/plUkFdrK3lE\n6xEj9TVeMvNxVWglX3SgqwSb/A0V0wP4ZLaC2hUCgYEAmIvETBHbV+dNdgW4wTTI\n7w8IVxGmDr1VZNsku/XLoeTEyQDjZwqDOwPgYdQE/JBWCMZ0keGXlQzNvD/Cwcm0\nkmCnv6NC6tPK0HCNsg8U/CykmxoQdx5xhicSMjWaNysuB57jpQHCKmwxJ1l29OZ2\nFnNZixQC5kg4Xq2b0Q1MYFsCgYBi7Y7/UoHLW3pRzqxZ6kj/JtgVt6t0XIWuDJTN\nTz13Ivxt6bEfZv0l5N6JfHiHwREq6z5EFiymE6zM+aCiHu29uptO69U62R9FM0jg\nqQux9I33P9LzuWWdiAwKW0ujrOtEhn7DqbWkWZ0ES5RPFPUTh0Z79dE+3NMbFKGM\nOblJ4QKBgEAFmMFy4mosWDNeoLQtk+Sj0gE74WIl20HN1j2hBFWDxSqNwwrM1SDx\nX52ug/2nRXdO/KRIGwF4CLHMMZNvYbPMWziN3PC7QEetob5JUGBEYJpJM9G6iom/\n6GIaL2gPs0mBKUpW2QreiN5djFSIo7LRr9dyDt46keSUfwJ5xQUV\n-----END RSA PRIVATE KEY-----\n",
# #             "private_key_pem_pkcs8": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCzEz6+mm4SN7qu\nvQWg4vpRhfiiqc/uicm/nWX1jD1XfJPgoZDdDU557SD7N/2qH6anLqHNy6/rXnZU\nRcezukq35FyGFcr8HvQuCuqWYfx7mw6dsIb6sUgkJV6Y4XCDXEW5XwiTiCis1hVi\ngyAgWIQhav/QisBzqT0TSrLeXVlsMFuw3EcY5D9n/BsI2CtCOz89jfi50jMs7Dx7\nWdcKi16amue7xNNLLhcluV+Jh01Cb80RdwUA4pOsy/IxGNyxtYEGtjgmEf8jITs+\nDE1Gp6wjBZZOfA7VCbAa4qmyJ5PzqyUlgtxUqS30pD8yRgWW/0m4DeKSqoVc88rU\ngbKZ0o7HAgMBAAECggEAVrC94sri92nIM5hpNaI8GSQ4ohKACVPl+Z+qgM0j0wsJ\nkajVdtXexFLB8SwBXo7VAEEobnapUtHXieOAEmdgjZZ9HiJFsnkPr4x0VVnZP0No\nt3kCVzFkoa7/lRYqAEW2sU8q2TUEr+sxzg95iX8gdAcXEW9iTHvFB+ZVIiXhyOfu\neOA7JwoxTDrIzxAG0eCXaSIkv2LI/YrQXakLbj/SZEXd9ybafCdZ6oJIqm33b4Ry\nTH/RjfLK52Jkv2cpdyzQjClTSZsrstKRsZOb4uTYy8NpJ6crGESEmMdYKauTe3Vr\nmK4ZU7keQ4IfJzR1kh2NWnwH4JTKr4Ks9iqX9MQ5FQKBgQDkPvyLfQ3GPFAOO5Kn\nFUrx0J66iWPehLtkI5FkKYqIeV+NYptcdJoGt1GVUJKiFDPWJ8lL3rG6EMpSx7pj\nU3sSD6oP/yxd81OnxBfucoOI2XiUKjgOiPdq8UGOCl7uyLkIlFUA5AdXhnPxW2Tf\n1WwCCtX8Tbi4hWO+XWZcUP3IawKBgQDI2aGRvqkghoxRiNYBEVfyKvI0h8gCmd62\nO0e1KsipyDJh4Wl0O1tmOcUcMYDDXACaRPlVPd1UUh7W4BF6ILyIF4vYNphykX7w\nmmjXmdMrFL7vjN1zYJLdyOD+mVSQV2sreUTrESP1NV4y83FVaCVfdKCrBJv8DRXT\nA/hktoLaFQKBgQCYi8RMEdtX5012BbjBNMjvDwhXEaYOvVVk2yS79cuh5MTJAONn\nCoM7A+Bh1AT8kFYIxnSR4ZeVDM28P8LBybSSYKe/o0Lq08rQcI2yDxT8LKSbGhB3\nHnGGJxIyNZo3Ky4HnuOlAcIqbDEnWXb05nYWc1mLFALmSDherZvRDUxgWwKBgGLt\njv9SgctbelHOrFnqSP8m2BW3q3Rcha4MlM1PPXci/G3psR9m/SXk3ol8eIfBESrr\nPkQWLKYTrMz5oKIe7b26m07r1TrZH0UzSOCpC7H0jfc/0vO5ZZ2IDApbS6Os60SG\nfsOptaRZnQRLlE8U9ROHRnv10T7c0xsUoYw5uUnhAoGAQAWYwXLiaixYM16gtC2T\n5KPSATvhYiXbQc3WPaEEVYPFKo3DCszVIPFfna6D/adFd078pEgbAXgIscwxk29h\ns8xbOI3c8LtAR62hvklQYERgmkkz0bqKib/oYhovaA+zSYEpSlbZCt6I3l2MVIij\nstGv13IO3jqR5JR/AnnFBRU=\n-----END PRIVATE KEY-----\n",
# #             "public_key_fingerprint_md5": "2d:e6:5d:c0:cb:08:91:ba:04:9a:70:b2:4d:9a:5d:b3",
# #             "public_key_fingerprint_sha256": "SHA256:697cp+nMLMC084cPuqB+Ios3yYftMKE3Y3GNP18PiMI",
# #             "public_key_openssh": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzEz6+mm4SN7quvQWg4vpRhfiiqc/uicm/nWX1jD1XfJPgoZDdDU557SD7N/2qH6anLqHNy6/rXnZURcezukq35FyGFcr8HvQuCuqWYfx7mw6dsIb6sUgkJV6Y4XCDXEW5XwiTiCis1hVigyAgWIQhav/QisBzqT0TSrLeXVlsMFuw3EcY5D9n/BsI2CtCOz89jfi50jMs7Dx7WdcKi16amue7xNNLLhcluV+Jh01Cb80RdwUA4pOsy/IxGNyxtYEGtjgmEf8jITs+DE1Gp6wjBZZOfA7VCbAa4qmyJ5PzqyUlgtxUqS30pD8yRgWW/0m4DeKSqoVc88rUgbKZ0o7H\n",
# #             "public_key_pem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsxM+vppuEje6rr0FoOL6\nUYX4oqnP7onJv51l9Yw9V3yT4KGQ3Q1Oee0g+zf9qh+mpy6hzcuv6152VEXHs7pK\nt+RchhXK/B70LgrqlmH8e5sOnbCG+rFIJCVemOFwg1xFuV8Ik4gorNYVYoMgIFiE\nIWr/0IrAc6k9E0qy3l1ZbDBbsNxHGOQ/Z/wbCNgrQjs/PY34udIzLOw8e1nXCote\nmprnu8TTSy4XJblfiYdNQm/NEXcFAOKTrMvyMRjcsbWBBrY4JhH/IyE7PgxNRqes\nIwWWTnwO1QmwGuKpsieT86slJYLcVKkt9KQ/MkYFlv9JuA3ikqqFXPPK1IGymdKO\nxwIDAQAB\n-----END PUBLIC KEY-----\n",
# #             "rsa_bits": 2048
# #           },
# #           "sensitive_attributes": []
# #         }
# #       ]
# #     }
# #   ],
# #   "check_results": null
# # }
