# Red Steel Landing — Agent Guide

**Versión:** 1.0
**Fecha:** 2026-07-13
**Aplica a:** Todo agente de IA trabajando en la landing page.

---

## Proyecto

Landing page de Red Steel corriendo en WordPress + MySQL via Docker Compose.

| Dato | Valor |
|---|---|
| Path local | `C:\PORTAL\redsteel` |
| Path VPS | `/opt/redsteel` |
| Puerto | 8088 (mapeado a 80 interno) |
| URL | `https://redsteel.com.ar` |
| Contenedores | `redsteel-wp` (wordpress:latest), `redsteel-db` (mysql:8.0) |
| Proxy | Nginx Proxy Manager en `proxy_default` network |
| Repo | `https://github.com/Rippp6/redsteel-web.git` |

---

## Infraestructura

- **Docker Compose**: `docker-compose.yml` define ambos servicios
- **Red**: interna `redsteel_default` + externa `proxy_default` (NPM)
- **Volúmenes**: `redsteel_db` (MySQL), `redsteel_wp` (WordPress files)
- **Backups**: no automatizados (usar `backup_db` tool)
- **Healthchecks**: MySQL (mysqladmin ping), WordPress (curl localhost)

---

## Seguridad

- `.gitignore` ignora `.env`, `.bak`, volúmenes Docker, archivos IDE
- Las credenciales de DB están en `docker-compose.yml` (⚠️ rotar periódicamente)
- `FORCE_SSL_ADMIN` activado
- `WP_HOME` y `WP_SITEURL` configurados en `https://redsteel.com.ar`
- El formulario de leads público envía POST a `/api/leads/intake` del Portal

---

## Herramientas MCP relevantes

| Tool | Uso |
|---|---|
| `wp_config` | Ver wp-config.php |
| `wp_plugins` | Listar plugins |
| `wp_theme` | Ver tema activo |
| `wp_db_check` | Stats de la DB WordPress |
| `wp_db_query` | Queries SELECT/EXPLAIN en MySQL |
| `docker_ps` | Estado de contenedores |
| `docker_logs container=redsteel-wp` | Logs de WordPress |
| `docker_restart container=redsteel-wp` | Reiniciar WordPress |
| `ssh redsteel_landing` commands | Operar en `/opt/redsteel` |

---

## Deploy

```bash
cd /opt/redsteel && git pull && docker compose up -d
```
