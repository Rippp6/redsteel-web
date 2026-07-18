# Red Steel Landing — Agent Guide

**Versión:** 5.0 | **Fecha:** 2026-07-18

---

## ⚡ QUICK REFERENCE

| Quiero... | Tool |
|---|---|
| **Ver estado de WordPress** | `docker_ps` + `docker_logs container=redsteel-wp tail=20` |
| **Ver estado del VPS** | `mcp_health` |
| **Diagnóstico automático** | `mcp_diagnostics` |
| **Deployar cambios** | `mcp_deploy repo=redsteel_landing message="..." confirm=true` |
| **Consultar la DB** | `wp_db_query sql="SELECT ..."` |
| **Ver plugins** | `wp_plugins` |
| **Ver tema** | `wp_theme` |
| **Reiniciar WordPress** | `docker_restart container=redsteel-wp confirm=true` |
| **Ejecutar WP-CLI** | `docker_exec container=redsteel-wp command="wp ..."` |
| **Leer docker-compose** | `project_config action=read project=redsteel_landing file=docker-compose.yml` |

---

## 1. Infraestructura Docker

| Contenedor | Imagen | Puerto |
|---|---|---|
| `redsteel-wp` | wordpress:6.7 | 8088→80 |
| `redsteel-db` | mysql:8.0 | 3306 |

Archivos en `/opt/redsteel/` (owner: `redsteel`, permisos `2775`). No usa PM2 — Docker compose maneja los contenedores.

---

## 2. Deploy

```bash
# Un paso — no tiene build, usa docker compose
mcp_deploy repo=redsteel_landing message="fix: descripción" confirm=true

# O manual
git_commit repo=redsteel_landing -m "fix: ..."
git_push repo=redsteel_landing
vps_exec command="git -C /opt/redsteel pull" scope=mcp
vps_exec command="docker compose -f /opt/redsteel/docker-compose.yml up -d" scope=mcp
```

---

## 3. Diagnóstico

```bash
docker_ps                                    # Containers
docker_logs container=redsteel-wp tail=30    # Logs WP
docker_logs container=redsteel-db tail=30    # Logs MySQL
mcp_health                                   # Estado VPS
```

---

## 4. Operaciones comunes

```bash
# Consultar DB
wp_db_query sql="SELECT post_title FROM wp_posts WHERE post_status='publish' LIMIT 10"

# Ver plugins activos
wp_plugins

# Backup manual
docker_exec container=redsteel-db command="mysqldump -u wordpress -p\$MYSQL_ROOT_PASSWORD wordpress > /tmp/backup.sql"

# Ver espacio
server_diskspace
```
