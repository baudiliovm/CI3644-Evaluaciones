#!/bin/bash

declare -gA PROGRAMS     # PROGRAMS[nombre]=lenguaje
declare -gA INTERPRETERS # INTERPRETERS[lenguaje]=lenguaje_base
declare -gA TRANSLATORS  # TRANSLATORS[origen]="destino,base"

# Funciones de Definición y Inicialización

# Inicializa todas las estructuras de datos.
td_init() {
  unset PROGRAMS
  unset INTERPRETERS
  unset TRANSLATORS
  unset CACHE_EXEC
  declare -gA PROGRAMS
  declare -gA INTERPRETERS
  declare -gA TRANSLATORS
  declare -gA CACHE_EXEC
}

td_define_program() {
  local name="$1" language="$2"
  if [ -z "$name" ] || [ -z "$language" ]; then return 1; fi
  PROGRAMS["$name"]="$language"
  echo "OK: Definido programa '$name' en lenguaje '$language'."
}

td_define_interpreter() {
  local base_lang="$1" target_lang="$2"
  if [ -z "$base_lang" ] || [ -z "$target_lang" ]; then return 1; fi
  INTERPRETERS["$target_lang"]="$base_lang"
  echo "OK: Definido intérprete para '$target_lang' escrito en '$base_lang'."
}

td_define_translator() {
  local base_lang="$1" source_lang="$2" dest_lang="$3"
  if [ -z "$base_lang" ] || [ -z "$source_lang" ] || [ -z "$dest_lang" ]; then return 1; fi
  TRANSLATORS["$source_lang"]="$dest_lang,$base_lang"
  echo "OK: Definido traductor de '$source_lang' a '$dest_lang' escrito en '$base_lang'."
}

# Lógica Principal: Búsqueda de Ejecutabilidad

# Cache para memorizar resultados y evitar recalcular.
declare -gA CACHE_EXEC

# Función principal que inicia la búsqueda.
td_is_executable() {
  local prog_name="$1"

  if ! [[ -v PROGRAMS["$prog_name"] ]]; then
    echo "ERROR: El programa '$prog_name' no está definido." >&2
    return 1
  fi

  local prog_lang=${PROGRAMS["$prog_name"]}
  CACHE_EXEC=() # Limpiar cache para cada nueva consulta

  if _can_execute "$prog_lang" "  "; then
    echo "SI: El programa '$prog_name' ('$prog_lang') es ejecutable."
    return 0
  else
    echo "NO: El programa '$prog_name' ('$prog_lang') NO es ejecutable."
    return 1
  fi
}

# Función recursiva de búsqueda con detección de ciclos.
_can_execute() {
  local lang_to_check="$1"
  local path_so_far="$2" # Se usa para imprimir el camino y detectar ciclos.

  # Caso base: Si el lenguaje es LOCAL, es directamente ejecutable.
  if [ "$lang_to_check" == "LOCAL" ]; then
    echo "$path_so_far-> ¡ÉXITO en LOCAL!"
    return 0
  fi

  # Si ya estamos intentando resolver este lenguaje en la ruta actual, hemos entrado en un bucle.
  if [[ "$path_so_far" =~ " $lang_to_check " ]]; then
    return 1 # Fallo por ciclo
  fi

  # Si ya calculamos el resultado para este lenguaje, lo reusamos.
  if [[ -v CACHE_EXEC["$lang_to_check"] ]]; then
    return ${CACHE_EXEC["$lang_to_check"]}
  fi

  local new_path="$path_so_far$lang_to_check "

  # Si existe un interprete o traductor, intentamos usarlos.
  if [[ -v INTERPRETERS["$lang_to_check"] ]]; then
    local base_lang=${INTERPRETERS["$lang_to_check"]}
    echo "$path_so_far-> Necesito ejecutar '$lang_to_check', intentando usar intérprete escrito en '$base_lang'..."
    if _can_execute "$base_lang" "$new_path"; then
      CACHE_EXEC["$lang_to_check"]=0
      return 0
    fi
  fi

  if [[ -v TRANSLATORS["$lang_to_check"] ]]; then
    local value=${TRANSLATORS["$lang_to_check"]}
    local dest_lang=${value%,*}
    local base_lang=${value#*,}

    echo "$path_so_far-> Necesito ejecutar '$lang_to_check', intentando usar traductor a '$dest_lang' escrito en '$base_lang'..."

    # Para usar el traductor, debemos poder ejecutar el traductor en sí MISMO
    # Y también poder ejecutar el resultado de la traducción. Es un Y lógico.
    echo "$path_so_far  (Paso 1: ¿Puedo ejecutar el traductor en '$base_lang'?)"
    if _can_execute "$base_lang" "$new_path"; then
      echo "$path_so_far  (Paso 2: Si, ahora ¿puedo ejecutar el resultado en '$dest_lang'?)"
      if _can_execute "$dest_lang" "$new_path"; then
        CACHE_EXEC["$lang_to_check"]=0 # Éxito
        return 0
      fi
    fi
  fi

  # Si ninguna vía tuvo éxito, este lenguaje no es ejecutable desde el estado actual.
  CACHE_EXEC["$lang_to_check"]=1 # Fallo
  return 1
}
