#!/bin/sh
# Generates the xray config at container start from environment variables.
# UUID and WS_PATH are set as environment variables on the platform
# (never baked into the image/repo).
# PORT defaults to 3000; the platform assigns the real port via the PORT env var.
# Uses the ./xray binary downloaded by download.sh and a config file in the
# working directory (no /etc writes, so it also runs as a non-root user).
set -e
cd "$(dirname "$0")"

UUID="${UUID:?UUID env var is required}"
WS_PATH="${WS_PATH:-/tk-aba}"
PORT="${PORT:-3000}"

cat > ./xray-config.json <<EOF
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

exec ./xray run -c ./xray-config.json
