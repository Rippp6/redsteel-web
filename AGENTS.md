# Red Steel Landing — Agent Guide

**Versión:** 4.0
**Fecha:** 2026-07-17

---

## 1. ¿Qué es el Landing?

Landing page de Red Steel. WordPress + MySQL corriendo en Docker Compose. No tiene build step — con `docker compose up -d` se aplican los cambios.

---

## 2. El VPS — cómo funciona

```
/opt/
├── redsteel/         owner=redsteel:redsteel             permisos=2775   puerto=8088
├── portal/           owner=portal:portal                 permisos=2775   puerto=3000
├── mcp/              owner=mcp:mcp                       permisos=2775   puerto=3090
├── estructurarte/    owner=estructurarte:estructurarte   permisos=2775   puerto=3001
├── proxy/            owner=root:root                     permisos=755    NPM
└── wa-api/           owner=root:root                     permisos=755    WhatsApp
```

**El MCP (usuario `mcp`) tiene acceso al grupo `redsteel` y `docker`.** Puede leer/escribir archivos en `/opt/redsteel/` y ejecutar comandos en los contenedores Docker.

**No usa PM2.** Los contenedores Docker se inician con `docker compose up -d` y se reinician solos (`restart: unless-stopped` en docker-compose.yml).

---

## 3. Infraestructura Docker

| Contenedor | Imagen | Puerto interno | Descripción |
|---|---|---|---|
| `redsteel-wp` | `wordpress:6.7` | 80 | WordPress |
| `redsteel-db` | `mysql:8.0` | 3306 | MySQL |

- Red interna: `redsteel_default`
- Red externa: `proxy_default` (conecta con Nginx Proxy Manager)
- Volúmenes: `redsteel_db` (MySQL data), `redsteel_wp` (wp-content)
- URL pública: `https://redsteel.com.ar`

---

## 4. Herramientas MCP

### WordPress

| Tool | Uso |
|---|---|
| `wp_config` | Leer wp-config.php desde el contenedor |
| `wp_plugins` | Listar plugins instalados |
| `wp_theme` | Ver tema activo |
| `wp_db_check` | Stats: tablas, users, posts, pages |
| `wp_db_query sql="SELECT ..."` | Ejecutar SELECT en MySQL |

### Docker

| Tool | Uso |
|---|---|
| `docker_ps` | Ver todos los contenedores |
| `docker_inspect container=redsteel-wp` | Detalles del contenedor |
| `docker_logs container=redsteel-wp tail=100` | Logs de WordPress |
| `docker_logs container=redsteel-db tail=50` | Logs de MySQL |
| `docker_restart container=redsteel-wp confirm=true` | Reiniciar WordPress |
| `docker_exec container=redsteel-wp command="wp plugin list"` | Ejecutar WP-CLI |

### Archivos (root=redsteel_landing)

`list_dir`, `read_file`, `tree`, `search_code`, `write_file`, `edit_file`, `delete_file`, `file_exists`, `file_info`

### PM2 & Diagnóstico (todos los servicios)

| Tool | Uso |
|---|---|
| `mcp_health` | **Dashboard unificado.** PM2 status + puertos + errores + disco + memoria. Un solo llamado. |
| `service_control action=status project=mcp` | Ver si el MCP está corriendo |
| `service_control action=status project=portal` | Ver si el Portal está corriendo |
| `service_control action=restart project=mcp confirm=true` | Reiniciar MCP si no responde |

### Configuración

| Tool | Uso |
|---|---|
| `project_config action=list project=redsteel_landing` | Listar archivos de configuración |
| `project_config action=read project=redsteel_landing file=docker-compose.yml` | Leer docker-compose.yml |

`git_status`, `git_diff`, `git_log`, `git_pull`, `git_push`, `git_commit`

### VPS

| Tool | Ejemplo |
|---|---|
| `vps_exec` | `vps_exec command="docker compose -f /opt/redsteel/docker-compose.yml up -d" scope=mcp` |
| `vps_info` | Info del VPS |
| `server_diskspace` | Espacio en disco |

---

## 5. Flujo de trabajo

```
# 1. Editar archivos
read_file root=redsteel_landing file=docker-compose.yml
edit_file root=redsteel_landing path=docker-compose.yml ...

# 2. No hay build — solo commit y deploy
git_commit repo=redsteel_landing -m "fix: descripción"
git_push repo=redsteel_landing

# 3. Pull en VPS
vps_exec command="git -C /opt/redsteel pull" scope=mcp

# 4. Redeploy Docker
vps_exec command="docker compose -f /opt/redsteel/docker-compose.yml up -d" scope=mcp

# 5. Verificar
docker_ps
docker_logs container=redsteel-wp tail=20
```

---

## 6. Operaciones comunes

```
# Ver estado
docker_ps
docker_logs container=redsteel-wp tail=50

# Reiniciar WordPress
docker_restart container=redsteel-wp confirm=true

# Consultar la DB de WordPress
wp_db_query sql="SELECT post_title FROM wp_posts WHERE post_status='publish' LIMIT 10"

# Ver plugins activos
wp_plugins

# Backup manual de MySQL
docker_exec container=redsteel-db command="mysqldump -u wordpress -pwordpress wordpress" > /tmp/wp_backup.sql

# Ver espacio en disco
server_diskspace
```

---

## 7. Diagnóstico

```
# Dashboard (un solo llamado)
mcp_health          # PM2 + puertos + errores + disco + memoria

# ¿Está corriendo WordPress?
docker_ps
docker_logs container=redsteel-wp tail=30

# ¿Responde?
vps_exec command="curl -s -o /dev/null -w '%{http_code}' http://localhost:8088" scope=mcp

# Logs de MySQL
docker_logs container=redsteel-db tail=30

# ¿El MCP está vivo? (necesario para usar las tools)
service_control action=status project=mcp

# Espacio en disco
server_diskspace
```
