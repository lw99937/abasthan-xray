#!/bin/sh
# Generates the xray config at container start from environment variables.
# UUID and WS_PATH are set as environment variables on the platform
# (never baked into the image).
# PORT defaults to 3000; the platform assigns the real port via the PORT env var.
set -e

UUID="${UUID:?UUID env var is required}"
WS_PATH="${WS_PATH:-/tk-exc}"
PORT="${PORT:-3000}"

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF

exec /usr/local/bin/xray run -c /etc/xray/config.json
