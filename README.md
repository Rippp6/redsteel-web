# Red Steel — Landing Page

Landing page de Red Steel, empresa de Steel Frame.
WordPress + MySQL corriendo en Docker Compose sobre Hetzner VPS.

---

## Stack

- **WordPress** 6.7 (Apache)
- **MySQL** 8.0
- **Nginx Proxy Manager** (SSL, proxy reverso)
- **Docker Compose**

---

## Setup

1. Clonar el repo:
   ```bash
   git clone https://github.com/Rippp6/redsteel-web.git
   cd redsteel-web
   ```

2. Copiar `.env.example` a `.env` y configurar las credenciales:
   ```bash
   cp .env.example .env
   # Editar .env con credenciales reales
   ```

3. Levantar:
   ```bash
   docker compose up -d
   ```

4. WordPress disponible en `http://localhost:8088`. El proxy Nginx (NPM) enruta `https://redsteel.com.ar` al puerto 8088.

---

## Servicios

| Servicio | Imagen | Puerto |
|---|---|---|
| `redsteel-db` | `mysql:8.0` | 3306 (interno) |
| `redsteel-wp` | `wordpress:6.7` | 8088 → 80 |

---

## Deploy

```bash
cd /opt/redsteel && git pull && docker compose up -d
```

---

## Backups

No automatizados. Para backup manual de la DB:

```bash
docker exec redsteel-db mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" redsteel > backup_$(date +%Y%m%d).sql
```

---

## Integración con Portal

El formulario de leads público envía POST a `https://portal.redsteel.com.ar/api/leads/intake`.
