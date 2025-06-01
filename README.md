# Projeto IaC - Deploy Automático com Terraform, Ansible e Docker na GCP

## ✅ Descrição
Este projeto automatiza a infraestrutura e o deploy de uma aplicação composta por **frontend (Next.js)**, **backend (Python)** e **banco de dados MySQL** na **Google Cloud Platform** utilizando **Infrastructure as Code (IaC)** com **Terraform** e **Ansible**, além de **integração contínua** via **GitHub Actions**.

---

## ✅ Tecnologias Utilizadas

- Google Cloud Platform (GCP)
- Terraform
- Ansible
- Docker + Docker Compose
- GitHub Actions
- Next.js (Frontend)
- Python + Uvicorn (Backend)
- MySQL

---

## ✅ Estrutura do Repositório

.
├── ansible
│ ├── inventory.ini
│ └── playbook.yml
├── backend
│ └── Dockerfile
├── frontend
│ └── Dockerfile
├── k8s
├── terraform
│ ├── main.tf
├── .github
│ └── workflows
│ └── iac-pipeline.yml
---

## ✅ Pré-requisitos

- Conta no Google Cloud com projeto ativo.
- Criar chave de serviço (JSON) para autenticação.
- Criar um **bucket GCS** para armazenar o **`terraform.tfstate`**.
- Criar secrets no GitHub:

| Nome | Descrição |
|------|----------|
| `GCP_CREDENTIALS` | Arquivo `chave.json` codificado em **base64** |
| `SSH_PRIVATE_KEY` | Chave **privada** para acesso SSH à VM |
| `SSH_PUBLIC_KEY` | Chave **pública** usada no `metadata.ssh-keys` |

---

## ✅ Como configurar

### 🔹 1. Criar bucket no GCS

gsutil mb -l southamerica-east1 gs://projeto-iac-tfstate

### 🔹 2. Configurar backend remoto no main.tf

terraform {
  backend "gcs" {
    bucket = "projeto-iac-tfstate"
    prefix = "terraform/state"
  }
}

### 🔹 3. Configurar GitHub Secrets

Vá em Settings → Secrets → Actions.
Adicione os seguintes:
Nome	Valor
GCP_CREDENTIALS	Base64 da chave.json
SSH_PRIVATE_KEY	Sua id_rsa
SSH_PUBLIC_KEY	Sua id_rsa.pub

✅ Como funciona a pipeline
A pipeline é disparada a cada push na branch master.

Executa dois jobs:

➡️ infra
Cria chave.json e id_rsa.pub.

Inicializa e aplica o Terraform.

Provisiona a VM e as regras de firewall.

Obtém o IP público da VM.

➡️ deploy
Cria id_rsa para autenticação SSH.

Configura inventário Ansible.

Executa o Ansible Playbook que:

-Instala Docker e Docker Compose.

-Clona o repositório.

-Sobe os serviços com Docker Compose.

✅ Como rodar manualmente
Clone o repositório:
git clone <repo>
cd <repo>

Configure as variáveis e os secrets no GitHub.
Faça git push → pipeline será executada automaticamente.

✅ Como acessar o sistema
Após o deploy, o sistema estará disponível via IP público:

Frontend: http://<IP_PUBLICO>:3000

Backend: http://<IP_PUBLICO>:8080
