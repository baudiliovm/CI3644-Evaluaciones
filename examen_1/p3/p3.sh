#!/bin/bash
# buddy_main.sh - Interfaz de usuario para el Buddy System.

# Incluir la lógica del gestor de memoria
source ./p3_logic.sh

# Validación del argumento inicial
if [ "$#" -ne 1 ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Uso: $0 <cantidad_total_de_bloques>"
  echo "La cantidad debe ser una potencia de 2."
  exit 1
fi

TOTAL_MEM_REQUESTED=$1
TOTAL_MEM_ACTUAL=$(next_power_of_2 "$TOTAL_MEM_REQUESTED")

if [ "$TOTAL_MEM_REQUESTED" -ne "$TOTAL_MEM_ACTUAL" ]; then
  echo "Advertencia: El tamaño se ajustó a la siguiente potencia de 2: $TOTAL_MEM_ACTUAL"
fi

# Inicializar el sistema
bs_init "$TOTAL_MEM_ACTUAL"

echo "Gestor de memoria inicializado con $TOTAL_MEM_ACTUAL bloques."
echo "Comandos disponibles: RESERVAR <cant> <nombre>, LIBERAR <nombre>, MOSTRAR, SALIR"

# Bucle principal de comandos
while true; do
  read -r -p "Accion> " cmd args

  case $cmd in
  RESERVAR)
    set -- $args # Separa los argumentos
    if [ "$#" -ne 2 ]; then
      echo "ERROR: Uso: RESERVAR <cantidad> <nombre>"
    else
      bs_reserve "$1" "$2"
    fi
    ;;
  LIBERAR)
    set -- $args
    if [ "$#" -ne 1 ]; then
      echo "ERROR: Uso: LIBERAR <nombre>"
    else
      bs_free "$1"
    fi
    ;;
  MOSTRAR)
    bs_show
    ;;
  SALIR)
    echo "Saliendo..."
    exit 0
    ;;
  *)
    if [ -n "$cmd" ]; then
      echo "ERROR: Comando desconocido '$cmd'"
    fi
    ;;
  esac
done
