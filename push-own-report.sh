#!/bin/bash

# --------------------
# Variablen definieren
# --------------------

USER="debian"
SERVER_IP="86.119.30.195"

REPO_URL="https://clone-token:glpat-Hw4JUcuCPssqM-BZ_88U@gitlab.fhnw.ch/cloud/cloud/platforms_to_build.git"

LOCAL_FILE="./plattform-4-storage//own_report.md"
REMOTE_DIR="/home/debian/platforms_to_build/04-storage/own_report.md"

# --------------------
# SSH-Befehl ausführen
# --------------------

echo "Führe SSH-Befehle auf ${USER}@${SERVER_IP} aus..."

ssh "${USER}@${SERVER_IP}" << EOF
    echo "Aktualisiere Paketlisten..."
    sudo apt update

    echo "Installiere Git..."
    sudo apt install -y git

    echo "Klone das Git-Repository..."
    pwd
    git clone "${REPO_URL}"
EOF

# --------------------
# SCP-Befehl ausführen
# --------------------

echo "Kopiere ${LOCAL_FILE} nach ${USER}@${SERVER_IP}:${REMOTE_DIR}..."

scp "${LOCAL_FILE}" "${USER}@${SERVER_IP}:${REMOTE_DIR}"

# Überprüfen, ob der SCP-Befehl erfolgreich war
if [ $? -eq 0 ]; then
    echo "Datei erfolgreich kopiert."
else
    echo "Fehler beim Kopieren der Datei." >&2
    exit 1
fi

echo "Skript erfolgreich abgeschlossen."
