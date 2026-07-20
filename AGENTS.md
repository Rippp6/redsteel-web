# Red Steel Landing — Agent Guide

**Versión:** 6.0 | **Fecha:** 2026-07-20

---

## ⚡ QUICK REFERENCE

| Quiero... | Tool |
|---|---|
| **Deployar** | `git_commit repo=redsteel_landing message="fix:..." push=true` → `mcp_deploy repo=redsteel_landing message="deploy" confirm=true` |
| **Ver estado WP** | `docker_ps` + `docker_logs container=redsteel-wp tail=20` |
| **Ver estado VPS** | `mcp_health` |
| **Consultar DB** | `wp_db_query sql="SELECT ..."` |
| **Ver plugins** | `wp_plugins` |
| **Reiniciar WP** | `docker_restart container=redsteel-wp confirm=true` |
| **Ejecutar WP-CLI** | `docker_exec container=redsteel-wp command="wp ..."` |
| **Ver docker-compose** | `project_config action=read project=redsteel_landing file=docker-compose.yml` |

---

## 🔄 WORKFLOW

```
PASO 1 — EDITAR
edit_file root=redsteel_landing path=docker-compose.yml oldString="..." newString="..."
# o cualquier archivo en /opt/redsteel/

PASO 2 — DEPLOY (no tiene build, usa docker compose)
git_commit repo=redsteel_landing message="fix: desc" push=true
mcp_deploy repo=redsteel_landing message="deploy" confirm=true

PASO 3 — VERIFICAR
docker_ps
docker_logs container=redsteel-wp tail=20
```

---

## 1. Infraestructura

| Contenedor | Imagen | Puerto |
|---|---|---|
| `redsteel-wp` | wordpress:6.7 | 8088→80 |
| `redsteel-db` | mysql:8.0 | 3306 |

No usa PM2 — Docker Compose maneja los contenedores.

---

## 2. Tools

| Categoría | Tools |
|---|---|
| **Deploy** | `mcp_deploy`, `force_sync` (si necesitás rebuild) |
| **Diagnóstico** | `mcp_health`, `mcp_diagnostics` |
| **WordPress** | `wp_config`, `wp_plugins`, `wp_theme`, `wp_db_check`, `wp_db_query` |
| **Docker** | `docker_ps`, `docker_inspect`, `docker_logs`, `docker_restart`, `docker_exec` |
| **Archivos** | `read_file`, `write_file`, `edit_file`, `search_and_replace` |
| **Git** | `git_status`, `git_commit`, `git_pull` (retry 3x) |
| **VPS** | `vps_exec`, `vps_info`, `server_diskspace` |
| **Config** | `project_config` |

---

## 3. Operaciones comunes

```bash
# Backup manual MySQL
docker_exec container=redsteel-db command="mysqldump -u wordpress -p\$MYSQL_ROOT_PASSWORD wordpress > /tmp/backup.sql"

# Ver espacio
server_diskspace
```
