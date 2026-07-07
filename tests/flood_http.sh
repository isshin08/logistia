#!/bin/bash
echo "=== Flood HTTP sur web-server ==="
for i in $(seq 1 200); do
  curl -s http://192.168.20.20/api/anomalie > /dev/null
  curl -s http://192.168.20.20/api/stock > /dev/null
done
echo "✅ 400 requêtes envoyées"
