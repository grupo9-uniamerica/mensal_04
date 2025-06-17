# 🏢 Sistema de Gerenciamento de Salas - Infraestrutura como Código (IaC)

## 📋 Descrição
Este projeto implementa um sistema completo de gerenciamento de salas utilizando uma arquitetura moderna com frontend em Next.js, backend em Python FastAPI e banco de dados MySQL. A infraestrutura é totalmente automatizada usando Terraform, Ansible e Kubernetes na Google Cloud Platform (GCP), com CI/CD implementado via GitHub Actions.

O sistema permite:
- ✅ Gerenciamento completo de salas (criar, listar, excluir)
- ✅ Sistema de reservas com verificação de disponibilidade
- ✅ Autenticação JWT segura
- ✅ Interface moderna e responsiva
- ✅ Monitoramento com Prometheus e Grafana
- ✅ Deploy automatizado em múltiplos ambientes

## 🏗️ Arquitetura

### Ambientes
- **Stage**: Projeto GCP `projeto-iac-462123` - Ambiente de desenvolvimento e testes
- **Produção**: Projeto GCP `projeto-iac-461322` - Ambiente de produção

### Componentes da Infraestrutura

#### Stage (VM + Docker Compose)
- **VM**: Ubuntu 22.04 LTS (e2-medium)
- **Aplicação**: Docker Compose com frontend, backend e MySQL
- **Monitoramento**: Prometheus + Grafana + Node Exporter
- **Backend**: FastAPI com autenticação JWT
- **Frontend**: Next.js com interface moderna

#### Produção (GKE)
- **Cluster**: Google Kubernetes Engine (GKE)
- **Nodes**: 4 nós e2-medium com auto-scaling
- **Orquestração**: Kubernetes com namespaces separados
- **Monitoramento**: Métricas nativas do GKE
- **Segurança**: Network Policies ativadas

## 🚀 Tecnologias Utilizadas

### Infraestrutura
- **Google Cloud Platform (GCP)**
  - Google Kubernetes Engine (GKE)
  - Compute Engine (VM)
  - Cloud Storage (GCS) - Estado do Terraform
- **Terraform** - Provisionamento de infraestrutura
- **Ansible** - Configuração e deploy na VM
- **GitHub Actions** - CI/CD pipelines

### Aplicação
- **Frontend**: Next.js 14 + TypeScript + Styled Components
- **Backend**: Python + FastAPI + JWT Authentication
- **Banco de Dados**: MySQL 8.0
- **Containerização**: Docker + Docker Compose
- **Orquestração**: Kubernetes (produção)

### Monitoramento
- **Prometheus** - Coleta de métricas
- **Grafana** - Visualização e dashboards
- **Node Exporter** - Métricas do sistema

## 📁 Estrutura do Projeto

```
Semanal01/
├── .github/workflows/           # Pipelines de CI/CD
│   ├── deploy_deploy-stage.yml  # Deploy para stage
│   ├── build_deploy-prod.yml    # Deploy para produção
│   └── iac-prod.yml            # IaC para produção
├── ansible/                     # Automação com Ansible
│   ├── files/                   # Arquivos para stage
│   ├── files_prod/              # Arquivos para produção
│   ├── inventory.ini            # Configuração de hosts
│   └── playbook.yml             # Automação de deploy
├── backend/                     # API FastAPI
│   ├── app.py                   # Aplicação principal
│   ├── database.py              # Conexão com banco
│   ├── models.py                # Modelos de dados
│   ├── requirements.txt         # Dependências Python
│   └── Dockerfile               # Containerização
├── frontend/                    # Aplicação Next.js
│   ├── app/                     # Páginas da aplicação
│   ├── package.json             # Dependências Node.js
│   └── Dockerfile               # Containerização
├── k8s/                         # Manifests Kubernetes
│   ├── dev/                     # Configurações para desenvolvimento
│   ├── producao/                # Configurações para produção
│   └── monitoring/              # Configurações de monitoramento
├── terraform/                   # Infraestrutura como Código
│   ├── stage/                   # Configuração para stage
│   └── main.tf                  # Configuração para produção
├── banco/                       # Configuração do banco local
└── docker-compose.yml           # Configuração local
```

## 🔧 Pré-requisitos

### GCP
- Conta Google Cloud Platform ativa
- Dois projetos GCP criados:
  - `projeto-iac-462123` (Stage)
  - `projeto-iac-461322` (Produção)
- Chaves de serviço (JSON) para autenticação
- Buckets GCS para armazenamento do estado do Terraform:
  - `projeto-iac-tfstate-loungegario-stage` (Stage)
  - `projeto-iac-tfstate-loungegario` (Produção)

### GitHub
- Repositório configurado
- Secrets configurados:
  - `GCP_CREDENTIALS`: Chave de serviço GCP (base64)
  - `GCP_PROJECT_ID_STAGING`: ID do projeto GCP stage
  - `GCP_PROJECT_ID`: ID do projeto GCP produção
  - `GCP_SA_KEY`: Chave de serviço GCP produção
  - `DOCKER_HUB_USERNAME`: Usuário Docker Hub
  - `DOCKER_HUB_PASSWORD`: Senha Docker Hub
  - `SSH_PUBLIC_KEY`: Chave pública SSH
  - `SSH_PRIVATE_KEY`: Chave privada SSH

## 🛠️ Configuração

### 1. Configurar GCP

#### Stage
```bash
# Criar bucket para estado do Terraform
gsutil mb -l southamerica-east1 gs://projeto-iac-tfstate-loungegario-stage
```

#### Produção
```bash
# Criar bucket para estado do Terraform
gsutil mb -l southamerica-east1 gs://projeto-iac-tfstate-loungegario
```

### 2. Configurar GitHub Secrets
Acesse Settings → Secrets → Actions e adicione todos os secrets listados acima.

### 3. Configurar Kubernetes (Produção)
O cluster GKE é configurado com:
- **4 nós** (e2-medium)
- **Auto-scaling** habilitado
- **Network Policy** ativada
- **Node Pool** com auto-repair e auto-upgrade
- **Monitoring** e **Logging** habilitados

## 🔄 Pipelines de CI/CD

### Pipeline Stage
**Trigger**: Push na branch `stage`

1. **Infraestrutura**:
   - Provisiona VM Ubuntu na GCP
   - Configura firewalls e regras de segurança
   - Aplica configurações via Ansible

2. **Deploy**:
   - Build e push das imagens Docker
   - Deploy via Docker Compose na VM
   - Configuração do monitoramento

### Pipeline Produção
**Trigger**: Push na branch `master`

1. **Infraestrutura**:
   - Provisiona cluster GKE
   - Configura node pools e políticas de rede
   - Aplica configurações de segurança

2. **Deploy**:
   - Build e push das imagens Docker
   - Deploy no cluster GKE
   - Configuração dos namespaces
   - Aplicação dos manifests Kubernetes

## 📊 Banco de Dados

### Estrutura das Tabelas

#### Tabela Rooms
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

#### Tabela Reservations
```sql
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
```

#### Tabela Users
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔍 API Endpoints

### Autenticação
- `POST /token/` - Login e obtenção de JWT

### Salas
- `GET /rooms/` - Listar todas as salas
- `POST /rooms/` - Criar nova sala (requer autenticação)
- `DELETE /rooms/{room_id}` - Excluir sala (requer autenticação)

### Reservas
- `GET /reservations/` - Listar todas as reservas
- `POST /reservations/` - Criar nova reserva
- `GET /reservations/check` - Verificar disponibilidade

### Monitoramento
- `GET /health` - Health check da aplicação
- `GET /metrics` - Métricas Prometheus

## 🔐 Segurança

### Autenticação
- **JWT Tokens** com expiração de 30 minutos
- **Bcrypt** para hash de senhas
- **OAuth2** com Bearer tokens

### Infraestrutura
- **Network Policies** ativadas no cluster GKE
- **Secrets** gerenciados via Kubernetes Secrets
- **Firewalls** configurados para portas específicas
- **Chaves SSH** para acesso às VMs

### Aplicação
- **CORS** configurado adequadamente
- **Validação** de dados com Pydantic
- **Sanitização** de inputs

## 📈 Monitoramento

### Stage (VM)
- **Prometheus**: Porta 9090 - Coleta de métricas
- **Grafana**: Porta 3001 - Dashboards
- **Node Exporter**: Porta 9100 - Métricas do sistema

### Produção (GKE)
- **GKE Monitoring**: Métricas nativas do cluster
- **GKE Logging**: Logs centralizados
- **Application Metrics**: Métricas da aplicação via Prometheus

### Dashboards Disponíveis
- **Sistema**: CPU, memória, disco, rede
- **Aplicação**: Requests, latência, erros
- **Banco de Dados**: Conexões, queries, performance

## 🔄 Manutenção

### Auto-scaling
- **GKE**: Auto-scaling baseado em CPU/memória
- **VM**: Configuração manual (pode ser automatizada)

### Backup
- **Estado Terraform**: Armazenado no GCS
- **Banco de Dados**: Backup manual (recomendado automatizar)
- **Configurações**: Versionadas no Git

### Updates
- **Rolling Updates**: Configurados no Kubernetes
- **Zero Downtime**: Deploy sem interrupção
- **Rollback**: Capacidade de reverter mudanças

## 🌐 Acessando o Sistema

### URLs Stage
- **Frontend**: http://[IP_VM]:3000
- **Backend**: http://[IP_VM]:8080
- **Prometheus**: http://[IP_VM]:9090
- **Grafana**: http://[IP_VM]:3001

### URLs Produção
- **Frontend**: http://[IP_LOAD_BALANCER]:3000
- **Backend**: http://[IP_LOAD_BALANCER]:8080
- **GKE Console**: https://console.cloud.google.com/kubernetes

### Comandos Úteis

#### Stage (VM)
```bash
# Acessar VM
ssh ubuntu@[IP_VM]

# Verificar containers
docker ps
docker-compose logs

# Acessar banco
docker exec -it mysql mysql -u root -p
```

#### Produção (GKE)
```bash
# Configurar kubectl
gcloud container clusters get-credentials cluster-prod --zone southamerica-east1-a --project projeto-iac-461322

# Verificar pods
kubectl get pods -n frontend
kubectl get pods -n backend
kubectl get pods -n database

# Verificar serviços
kubectl get services -n frontend
kubectl get services -n backend
kubectl get services -n database

# Acessar logs
kubectl logs -f deployment/frontend -n frontend
kubectl logs -f deployment/backend -n backend

# Acessar banco
kubectl exec -it [POD_MYSQL] -n database -- mysql -u root -p
```

## 🚨 Troubleshooting

### Problemas Comuns

#### Deploy Falha
1. Verificar logs do GitHub Actions
2. Verificar conectividade com GCP
3. Verificar secrets configurados
4. Verificar recursos disponíveis na GCP

#### Aplicação Não Responde
1. Verificar status dos pods/containers
2. Verificar conectividade do banco
3. Verificar logs da aplicação
4. Verificar configurações de rede

#### Monitoramento Não Funciona
1. Verificar se Prometheus está rodando
2. Verificar configuração do Grafana
3. Verificar conectividade entre serviços

## 🤝 Contribuição

1. **Fork** o projeto
2. Crie sua **branch de feature** (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. Abra um **Pull Request**

### Padrões de Código
- **Python**: PEP 8
- **TypeScript**: ESLint + Prettier
- **Terraform**: Terraform fmt
- **Commits**: Conventional Commits


**Desenvolvido com ❤️ usando tecnologias modernas de DevOps e Cloud Computing**
