# MyTONProvider Grafana Dashboards

Provisioned Grafana dashboards for monitoring TON storage providers using PostgreSQL as a datasource, served via Nginx with automatic SSL certificates.  

---

## Project structure

```
.
├─ nginx/
│  └─ user_conf.d/                # custom Nginx configs
├─ certbot/
│  └─ letsencrypt/                # Certbot certificates storage
├─ grafana/
│  ├─ dashboards/                 # exported Grafana dashboards in JSON
│  └─ provisioning/               # Grafana provisioning configs
│     ├─ dashboards.yml           # defines how dashboards are provisioned
│     └─ datasources/
│        └─ postgres.yml          # PostgreSQL datasource definition
├─ docker-compose.yml             # containerized Grafana + Nginx + Certbot
└─ .env.example                   # environment variables template
```

- **nginx/** — reverse proxy configuration for Grafana.  
- **certbot/** — directory for automatically issued SSL certificates.  
- **grafana/dashboards/** — exported dashboards in JSON format.  
- **grafana/provisioning/** — auto-provisioning configs for Grafana.  

---

## Environment variables

Copy `.env.example` → `.env` and configure:

```.env
# Grafana admin
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=changeme
GF_USERS_ALLOW_SIGN_UP=false

# Grafana server settings
GF_SERVER_ROOT_URL=https://grafana.mytonprovider.org
GF_SERVER_DOMAIN=grafana.mytonprovider.org
GF_SERVER_ENFORCE_DOMAIN=true
GF_SERVER_SERVE_FROM_SUB_PATH=false

# PostgreSQL connection
PG_HOST=localhost
PG_PORT=5432
PG_USER=pguser
PG_PASSWORD=secret
PG_DB=mydb

# Certbot email for SSL renewal
CERTBOT_EMAIL=admin@example.com
```

---

## Run services

Start Grafana, Nginx, and Certbot:

```bash
docker compose up -d
```

After startup:

* Grafana is available at **[https://grafana.mytonprovider.org](https://grafana.mytonprovider.org)**
* SSL certificates are automatically issued and renewed by Certbot.

Login with the credentials specified in your `.env` file.

---

## Permissions on folders

Grafana inside the container runs as UID `472`.
Ensure the mounted folders are accessible:

```bash
chown -R 472:472 ./grafana/dashboards ./grafana/provisioning
```

---

## License

This project is licensed under [Apache-2.0](LICENSE).
