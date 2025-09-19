# MyTONProvider Grafana Dashboards

Provisioned Grafana dashboards for monitoring TON storage providers using PostgreSQL as a datasource.  

---

## Project structure

```

.
├─ dashboards/
│  ├─ main-providers.json         # main dashboard: global overview (CPU, RAM, Swap, Disk, Net, Ping)
│  └─ per-provider/               # dashboards focused on single metrics
│     ├─ cpu.json                 # CPU load (1m / 5m / 15m averages per provider)
│     ├─ disk.json                # Disk usage %, per-device load, IOPS
│     └─ ...
├─ provisioning/
│  ├─ dashboards.yml              # defines how dashboards are provisioned
│  └─ datasources/
│     └─ postgres.yml             # PostgreSQL datasource definition
├─ docker-compose.yml             # containerized Grafana service
└─ .env.example                   # environment variables template

````

- **dashboards/** — exported Grafana dashboards in JSON format.  
  - `main-providers.json` → single entry-point dashboard with overall provider metrics and dropdown provider selector.  
  - `per-provider/` → specialized dashboards for deeper analysis of a single metric across providers.  

- **provisioning/** — auto-provisioning configs for Grafana.  
  - `dashboards.yml` → ensures dashboards are loaded automatically at startup.  
  - `datasources/postgres.yml` → configures PostgreSQL as the datasource.  

- **docker-compose.yml** — runs Grafana with mounted configs and dashboards.  
- **.env.example** — template with credentials and database connection parameters.

---

## Environment variables

Copy `.env.example` → `.env` and configure:

```ini
# Grafana admin
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=changeme
GF_USERS_ALLOW_SIGN_UP=false

# PostgreSQL connection
PG_HOST=localhost
PG_PORT=5432
PG_USER=pguser
PG_PASSWORD=secret
PG_DB=db
````

---

## Run Grafana

Start Grafana with Docker Compose:

```bash
docker compose up -d
````

Once the container is running, Grafana will be accessible on port **3000**.

Login with the credentials specified in your `.env` file.

---

## Permissions on folders

Grafana inside the container runs as UID `472`.

Make sure the mounted `dashboards/` and `provisioning/` folders are accessible:

```bash
chown -R 472:472 ./dashboards ./provisioning
```

---

## License

This project is licensed under [Apache-2.0](LICENSE).