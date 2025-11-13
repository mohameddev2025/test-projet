#!/bin/bash

set -e

echo "=== Vérification de la Quality Gate ==="

SONAR_HOST_URL="http://localhost:9000"
SONAR_PROJECT_KEY="DevWeb-Clients"
SONAR_LOGIN="sqp_3637b64a0ee1f4b618a69778c8422e43960e817e"

# Attendre que l'analyse soit traitée
sleep 30

# Récupérer le statut de la Quality Gate via l'API SonarQube
QUALITY_GATE_STATUS=$(curl -s -u "$SONAR_LOGIN:" \
  "$SONAR_HOST_URL/api/qualitygates/project_status?projectKey=$SONAR_PROJECT_KEY" \
  | jq -r '.projectStatus.status')

echo "Statut de la Quality Gate: $QUALITY_GATE_STATUS"

if [ "$QUALITY_GATE_STATUS" = "OK" ]; then
    echo "✅ La Quality Gate est passée avec succès"
    exit 0
else
    echo "❌ La Quality Gate a échoué"
    
    # Récupérer les détails de l'échec
    curl -s -u "$SONAR_LOGIN:" \
      "$SONAR_HOST_URL/api/qualitygates/project_status?projectKey=$SONAR_PROJECT_KEY" \
      | jq '.projectStatus.conditions'
    
    # Bloquer le merge en sortant avec un code d'erreur
    exit 1
fi