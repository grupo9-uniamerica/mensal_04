# Sistema de Gerenciamento de Salas - Infraestrutura como Código (IaC)

## 📋 Descrição
Este projeto implementa um sistema completo de gerenciamento de salas utilizando uma arquitetura moderna com frontend em Next.js, backend em Python e banco de dados MySQL. A infraestrutura é totalmente automatizada usando Terraform, Ansible e Kubernetes na Google Cloud Platform (GCP), com CI/CD implementado via GitHub Actions.

## 🚀 Tecnologias Utilizadas

### Infraestrutura
- Google Cloud Platform (GCP)
- Google Kubernetes Engine (GKE)
- Terraform
- Ansible
- GitHub Actions

### Aplicação
- Frontend: Next.js
- Backend: Python + FastAPI
- Banco de Dados: MySQL
- Containerização: Docker + Docker Compose
- Orquestração: Kubernetes

## 📁 Estrutura do Projeto

```
.
├── .github/
│   └── workflows/
│       ├── deploy_deploy-stage.yml    # Pipeline de CI/CD
│       └── iac-pipeline.yml           # Pipeline de IaC
├── ansible/
│   ├── inventory.ini                  # Configuração de hosts
│   └── playbook.yml                   # Automação de deploy
├── backend/
│   ├── Dockerfile                     # Containerização do backend
│   ├── models.py                      # Modelos do banco de dados
│   └── main.py                        # API FastAPI
├── frontend/
│   └── Dockerfile                     # Containerização do frontend
├── k8s/
│   └── dev/                           # Manifests Kubernetes
├── terraform/
│   ├── stage/
│   │   └── main.tf                    # Configuração do cluster GKE
│   └── prod/
└── docker-compose.yml                 # Configuração local
```

## 🔧 Pré-requisitos

### GCP
- Conta Google Cloud Platform ativa
- Projeto GCP criado
- Chave de serviço (JSON) para autenticação
- Bucket GCS para armazenamento do estado do Terraform

### GitHub
- Repositório configurado
- Secrets configurados:
  - `GCP_CREDENTIALS`: Chave de serviço GCP (base64)
  - `GCP_PROJECT_ID_STAGING`: ID do projeto GCP
  - `DOCKER_HUB_USERNAME`: Usuário Docker Hub
  - `DOCKER_HUB_PASSWORD`: Senha Docker Hub

## 🛠️ Configuração

### 1. Configurar GCP
```bash
# Criar bucket para estado do Terraform
gsutil mb -l southamerica-east1 gs://projeto-iac-tfstate
```

### 2. Configurar GitHub Secrets
Acesse Settings → Secrets → Actions e adicione:
- `GCP_CREDENTIALS`
- `GCP_PROJECT_ID_STAGING`
- `DOCKER_HUB_USERNAME`
- `DOCKER_HUB_PASSWORD`

### 3. Configurar Kubernetes
O cluster GKE é configurado com:
- 4 nós (e2-medium)
- Auto-scaling habilitado
- Network Policy ativada
- Node Pool com auto-repair e auto-upgrade

## 🔄 Pipeline de CI/CD

### Deploy para Stage
1. Trigger: Push na branch `stage`
2. Jobs:
   - Build e push das imagens Docker
   - Deploy no cluster GKE
   - Configuração dos namespaces
   - Aplicação dos manifests Kubernetes

## 📊 Banco de Dados

### Estrutura da Tabela Rooms
```sql
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔍 Acessando o Sistema

### URLs
- Frontend: http://[IP_EXTERNO]:3000
- Backend: http://[IP_EXTERNO]:8080
- Banco de Dados: 34.118.236.10:3306 (interno)

### Comandos Úteis
```bash
# Verificar pods
kubectl get pods -n frontend-dev
kubectl get pods -n backend-dev
kubectl get pods -n database-dev

# Acessar banco de dados
kubectl exec -it [POD_MYSQL] -n database-dev -- mysql -u root -p

# Verificar serviços
kubectl get services -n frontend-dev
kubectl get services -n backend-dev
kubectl get services -n database-dev
```

## 🔐 Segurança
- Network Policies ativadas no cluster
- Secrets gerenciados via Kubernetes Secrets
- Autenticação via chaves de serviço GCP
- Imagens Docker em repositório privado

## 📈 Monitoramento
- Logs disponíveis via kubectl logs
- Métricas do cluster via GCP Console
- Health checks configurados nos deployments

## 🔄 Manutenção
- Auto-scaling configurado
- Auto-repair e auto-upgrade ativos
- Rolling updates configurados
- Backup do estado do Terraform no GCS

## 🤝 Contribuição
1. Fork o projeto
2. Crie sua branch de feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📝 Licença
Este projeto está sob a licença MIT.
