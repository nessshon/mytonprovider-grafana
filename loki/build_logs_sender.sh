#!/bin/bash

ALLOY_VERSION="1.4.2"
ALLOY_DEB="alloy-${ALLOY_VERSION}-1.amd64.deb"
ALLOY_URL="https://github.com/grafana/alloy/releases/download/v${ALLOY_VERSION}/${ALLOY_DEB}"
WORK_DIR="/opt/storage/alloy"
CONFIG_FILE="/etc/alloy/config.alloy"
LOKI_URL="https://grafana.mytonprovider.org/loki/api/v1/push"

mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

wget "${ALLOY_URL}"
dpkg -i "${ALLOY_DEB}"

apt update
apt install -y alloy

cat > "${CONFIG_FILE}" <<EOF
local.file_match "app_logs" {
  path_targets = [
    {
      __path__ = "/var/log/mytonstorage.app/*.log",
      app      = "gateway",
      host     = constants.hostname,
      env      = "prod",
    },
    {
      __path__ = "/var/log/mytonstorage_backend.app/*.log",
      app      = "mtso",
      host     = constants.hostname,
      env      = "prod",
    },
  ]
}

loki.source.file "app_logs" {
  targets    = local.file_match.app_logs.targets
  forward_to = [loki.process.json_logs.receiver]
}

loki.process "json_logs" {
  stage.json {
    expressions = {
      level   = "level",
      message = "msg",
    }
  }
  stage.labels {
    values = {
      level = "",
    }
  }
  forward_to = [loki.write.remote.receiver]
}

loki.write "remote" {
  endpoint {
    url = "${LOKI_URL}"
    basic_auth {
      username = "${LOGIN}"
      password = "${PASSWORD}"
    }
  }
}
EOF

systemctl enable alloy
systemctl restart alloy
systemctl status alloy

echo "Alloy setup completed."
echo """
You can check loki using: 
curl -s -u "${LOGIN}:${PASSWORD}" "https://grafana.mytonprovider.org/loki/api/v1/labels"

Should output something like:
{"status":"success","data":["__stream_shard__","app","env","filename","host","level","service_name"]}
"""
