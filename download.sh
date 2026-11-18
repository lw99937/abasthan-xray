#!/bin/sh
# Build step for PaaS hosts without Docker support (e.g. Abasthan):
# downloads the official Xray release binary and extracts it next to this script.
set -e
cd "$(dirname "$0")"
curl -L -o Xray-linux-64.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
if command -v unzip >/dev/null 2>&1; then
  unzip -o Xray-linux-64.zip xray
elif command -v python3 >/dev/null 2>&1; then
  python3 -c "import zipfile; zipfile.ZipFile('Xray-linux-64.zip').extract('xray')"
else
  echo "download.sh: neither unzip nor python3 available" >&2
  exit 1
fi
chmod +x xray
rm -f Xray-linux-64.zip
./xray version
