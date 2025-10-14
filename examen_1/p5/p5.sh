#!/bin/bash

source ./p5_logic.sh

td_init

echo "Simulador de T-Diagramas. Comandos disponibles:"
echo "  DEFINIR <TIPO> <args...>"
echo "    (TIPO: PROGRAMA, INTERPRETE, TRADUCTOR)"
echo "  EJECUTABLE <nombre_programa>"
echo "  SALIR"

while true; do
  read -r -p "Accion> " line
  read -r cmd type args <<<"$line"

  case $cmd in
  DEFINIR)
    read -r arg1 arg2 arg3 <<<"$args"
    case $type in
    PROGRAMA)
      td_define_program "$arg1" "$arg2"
      ;;
    INTERPRETE)
      td_define_interpreter "$arg1" "$arg2"
      ;;
    TRADUCTOR)
      td_define_translator "$arg1" "$arg2" "$arg3"
      ;;
    *) echo "ERROR: Tipo de definición desconocido. Use PROGRAMA, INTERPRETE o TRADUCTOR." ;;
    esac
    ;;
  EJECUTABLE)
    td_is_executable "$type" # El nombre del programa es el segundo argumento
    ;;
  SALIR)
    echo "Saliendo..."
    exit 0
    ;;
  *)
    if [ -n "$cmd" ]; then
      echo "ERROR: Comando desconocido. Use DEFINIR, EJECUTABLE o SALIR."
    fi
    ;;
  esac
done
