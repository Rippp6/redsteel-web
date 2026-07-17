# Red Steel Landing — Agent Guide

**Versión:** 3.0
**Fecha:** 2026-07-16
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
| Contenedores | `redsteel-wp` (wordpress:6.7), `redsteel-db` (mysql:8.0) |
| Proxy | Nginx Proxy Manager en `proxy_default` network |
| Repo | `https://github.com/Rippp6/redsteel-web.git` |

---

## Infraestructura

- **Docker Compose**: `docker-compose.yml` define ambos servicios
- **Red**: interna `redsteel_default` + externa `proxy_default` (NPM)
- **Volúmenes**: `redsteel_db` (MySQL), `redsteel_wp` (WordPress files)
- **Backups**: cron automático cada 24h en `/opt/redsteel/backups/`
- **Healthchecks**: MySQL (mysqladmin ping), WordPress (curl localhost)

---

## Seguridad

- `.gitignore` ignora `.env`, `.bak`, volúmenes Docker, archivos IDE
- Las credenciales de DB están en `docker-compose.yml` (rotar periódicamente)
- `FORCE_SSL_ADMIN` activado
- `WP_HOME` y `WP_SITEURL` configurados en `https://redsteel.com.ar`
- El formulario de leads público envía POST a `/api/leads/intake` del Portal

---

## Herramientas MCP

| Tool | Uso |
|---|---|
| `wp_config` | Ver wp-config.php desde el contenedor |
| `wp_plugins` | Listar plugins instalados |
| `wp_theme` | Ver tema activo |
| `wp_db_check` | Stats de la DB (tablas, users, posts, pages) |
| `wp_db_query sql="SELECT ..."` | Queries SELECT/EXPLAIN en MySQL |
| `docker_ps` | Estado de los contenedores |
| `docker_logs container=redsteel-wp tail=50` | Logs de WordPress |
| `docker_restart container=redsteel-wp confirm=true` | Reiniciar WordPress |
| `docker_exec container=redsteel-wp command="..."` | Ejecutar comando en el container |
| `vps_exec command="docker compose -f /opt/redsteel/docker-compose.yml up -d"` | Redeploy |
| `vps_exec command="git -C /opt/redsteel pull"` | Pull en VPS |
| `git_commit repo=redsteel_landing -m "..."` | Commit local |
| `git_push repo=redsteel_landing` | Push a GitHub |

---

## Flujo de trabajo

El agente trabaja **primero local** (`C:\PORTAL\redsteel\`) y después deploya al VPS con MCP:

```
1. Editar archivos localmente
2. git_commit repo=redsteel_landing -m "fix: descripción"
3. git_push repo=redsteel_landing
4. vps_exec command="git -C /opt/redsteel pull" scope=mcp
5. vps_exec command="docker compose -f /opt/redsteel/docker-compose.yml up -d" scope=mcp
```

**Nota:** WordPress no tiene build step. Con `docker compose up -d` alcanza para aplicar cambios de configuración o plugins. Cambios de contenido se hacen desde el admin WP.

---

## Operaciones comunes

```
# Ver logs de WordPress
docker_logs container=redsteel-wp tail=100

# Reiniciar después de cambiar wp-config
docker_restart container=redsteel-wp confirm=true

# Consultar la DB
wp_db_query sql="SELECT COUNT(*) FROM wp_posts WHERE post_status='publish'"

# Ver estado de containers
docker_ps

# Backup manual de la DB
docker_exec container=redsteel-db command="mysqldump -u wordpress -p\$MYSQL_ROOT_PASSWORD wordpress > /backup.sql"

# Ver procesos del VPS
vps_exec command="ps aux | grep docker" scope=mcp
```
