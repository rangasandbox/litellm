# LiteLLM Proxy

A self-hosted LLM gateway powered by [LiteLLM](https://docs.litellm.ai/), routing requests to Azure OpenAI via an OpenAI-compatible API.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) + Docker Compose

> **Docker Compose V1 vs V2:**
> - **V2 (modern):** `docker compose` (space)
> - **V1 (older):** `docker-compose` (hyphen)
> 
> Check your version: `docker compose version` or `docker-compose version`

## Setup (New Machine)

### 1. Clone the repo

```bash
git clone <your-repo-url>
cd litellm
```

### 2. Create your `.env` file

```bash
cp .env.example .env
```

Then fill in your credentials in `.env`:

```env
AZURE_API_KEY="your-azure-api-key"
AZURE_API_BASE="https://your-resource.openai.azure.com"
AZURE_API_VERSION="2024-02-15-preview"
LITELLM_MASTER_KEY="sk-your-secure-master-key"
```

> **Tip:** Generate a secure master key with:
> ```bash
> python3 -c "import secrets; print('sk-' + secrets.token_hex(32))"
> ```

### 3. Start the proxy

```bash
docker compose up -d
```

The proxy will be available at **http://localhost:4000**

### 4. Test it

```bash
bash test.sh
```

Or with curl directly:

```bash
curl http://localhost:4000/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-LITELLM_MASTER_KEY>" \
  -d '{
    "model": "gpt-5.4",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Docker Commands

| Action        | V2 (modern)                  | V1 (older)                      |
|---------------|------------------------------|---------------------------------|
| Start         | `docker compose up -d`       | `docker-compose up -d`          |
| Stop          | `docker compose down`        | `docker-compose down`           |
| Logs          | `docker compose logs -f`     | `docker-compose logs -f`        |
| Restart       | `docker compose restart`     | `docker-compose restart`        |

## Project Structure

```
litellm/
├── .env              # secrets (gitignored — create from .env.example)
├── .env.example      # template for required env vars
├── .gitignore
├── config.yaml       # LiteLLM proxy model config
├── docker-compose.yml
├── pyproject.toml
├── uv.lock
└── test.sh           # curl test script
```

## Adding More Models

Edit `config.yaml` to add more model deployments:

```yaml
model_list:
  - model_name: gpt-5.4
    litellm_params:
      model: azure/gpt-5.4
      api_base: os.environ/AZURE_API_BASE
      api_key: os.environ/AZURE_API_KEY
      api_version: os.environ/AZURE_API_VERSION
```

Then restart: `docker compose restart`
