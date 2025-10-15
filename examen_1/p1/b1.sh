#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Uso: $0 <cadena> <posiciones>"
  exit 1
fi

cadena="$1"
posiciones="$2"
longitud=${#cadena}

# Casos base
if [ "$posiciones" -eq 0 ] || [ "$longitud" -eq 0 ]; then
  echo "$cadena"
  exit 0
fi

# Optimización con módulo
k_efectivo=$((posiciones % longitud))

# Bucle que simula la recursión k_efectivo veces
for ((i = 0; i < k_efectivo; i++)); do
  # w = a.x
  primer_caracter="${cadena:0:1}"
  resto_cadena="${cadena:1}"

  # nueva_cadena = x ++ [a]
  cadena="${resto_cadena}${primer_caracter}"
done

echo "$cadena"
