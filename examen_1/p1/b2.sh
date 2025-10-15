#!/bin/bash

if [ -z "$1" ]; then
  echo "Uso: $0 <archivo_matriz>"
  exit 1
fi

# Leer la matriz del archivo a un array asociativo de Bash
declare -A A
N=0
while read -r linea; do
  ((N++))
  C=0
  for valor in $linea; do
    ((C++))
    A[$N, $C]=$valor
  done
done <"$1"

# Calcular el producto C = A * A^T usando tres bucles anidados
for ((i = 1; i <= N; i++)); do
  for ((j = 1; j <= N; j++)); do

    suma_parcial=0
    for ((k = 1; k <= N; k++)); do
      val1=${A[$i, $k]}
      val2=${A[$j, $k]}
      producto=$((val1 * val2))
      suma_parcial=$((suma_parcial + producto))
    done

    # Imprimir el elemento de la matriz resultado
    printf "%s%s" "$suma_parcial" "$( ((j == N)) && echo "" || echo " ")"
  done
  echo
done
