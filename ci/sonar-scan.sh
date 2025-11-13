#!/bin/bash

set -e

echo "=== Installation et configuration de SonarScanner ==="

# Installer SonarScanner
if ! command -v sonar-scanner &> /dev/null; then
    echo "Installation de SonarScanner..."
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
    unzip sonar-scanner-cli-5.0.1.3006-linux.zip
    export PATH=$PWD/sonar-scanner-5.0.1.3006-linux/bin:$PATH
else
    echo "SonarScanner déjà installé"
fi

# Variables d'environnement
SONAR_HOST_URL="http://localhost:9000"
SONAR_PROJECT_KEY="DevWeb-Clients"
SONAR_LOGIN="sqp_3637b64a0ee1f4b618a69778c8422e43960e817e"

echo "=== Début de l'analyse SonarQube ==="

# Exécuter l'analyse SonarQube
sonar-scanner \
  -Dsonar.projectKey=$SONAR_PROJECT_KEY \
  -Dsonar.projectName="DevWeb-Clients" \
  -Dsonar.projectVersion=1.0 \
  -Dsonar.sources=. \
  -Dsonar.host.url=$SONAR_HOST_URL \
  -Dsonar.login=$SONAR_LOGIN \
  -Dsonar.sourceEncoding=UTF-8 \
  -Dsonar.scm.provider=git \
  -Dsonar.qualitygate.wait=true

echo "=== Analyse SonarQube terminée ==="

# Vérification du statut de sortie
if [ $? -eq 0 ]; then
    echo "✅ L'analyse SonarQube a réussi"
else
    echo "❌ L'analyse SonarQube a échoué"
    exit 1
fi