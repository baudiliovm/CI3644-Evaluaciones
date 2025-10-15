#!/bin/bash
# buddy_logic.sh - Contiene toda la lógica del Buddy System.

# Estructuras de Datos
# Usaremos arrays asociativos para simular estructuras de datos más complejas.

# free_lists: Mantiene las listas de bloques libres, agrupados por su orden (potencia de 2).
#   Ej: free_lists[3]="8 24" -> Hay bloques libres de tamaño 8 (2^3) en las posiciones 8 y 24.
declare -gA free_lists

# allocated_blocks: Mapea un nombre de reserva a su dirección y orden.
#   Ej: allocated_blocks["mi_reserva"]="0,5" -> "mi_reserva" está en la dirección 0 y es de orden 5 (tamaño 32).
declare -gA allocated_blocks

# memory_map: Representa el estado de cada bloque en la memoria.
#   Ej: memory_map[8]=3 -> El bloque en la dirección 8 es de orden 3.
declare -gA memory_map

# TOTAL_MEMORY_ORDER: El orden de la memoria total. Si la memoria es 64, el orden es 6.
declare -g TOTAL_MEMORY_ORDER

# Funciones
# Función para encontrar la próxima potencia de 2
next_power_of_2() {
  local n=$1
  if [ $n -gt 0 ] && (((n & (n - 1)) == 0)); then
    echo $n
    return
  fi
  local p=1
  while ((p < n)); do
    p=$((p << 1))
  done
  echo $p
}

# Inicializa el gestor de memoria
bs_init() {
  local total_size=$1
  TOTAL_MEMORY_ORDER=$(echo "l($total_size)/l(2)" | bc -l | awk '{print int($1)}')

  # Limpiar estructuras de datos para un estado limpio (importante para tests)
  free_lists=()
  allocated_blocks=()
  memory_map=()

  # Al inicio, solo hay un bloque libre del tamaño total
  free_lists[$TOTAL_MEMORY_ORDER]="0"
  memory_map[0]=$TOTAL_MEMORY_ORDER
}

# Reserva un bloque de memoria
bs_reserve() {
  local req_size=$1
  local name="$2"

  # Validaciones
  if [[ -v allocated_blocks["$name"] ]]; then
    echo "ERROR: El nombre '$name' ya está en uso." >&2
    return 1
  fi

  local block_size
  block_size=$(next_power_of_2 "$req_size")
  local order=$(echo "l($block_size)/l(2)" | bc -l | awk '{print int($1)}')

  # Encontrar un bloque para asignar
  local alloc_order=$order
  while [[ -z "${free_lists[$alloc_order]}" && $alloc_order -le $TOTAL_MEMORY_ORDER ]]; do
    ((alloc_order++))
  done

  if [ $alloc_order -gt $TOTAL_MEMORY_ORDER ]; then
    echo "ERROR: No hay suficiente memoria disponible." >&2
    return 1
  fi

  # Tomar el primer bloque de la lista encontrada
  local block_addr
  block_addr=$(echo "${free_lists[$alloc_order]}" | awk '{print $1}')

  # Actualizar la lista de libres (eliminar el bloque tomado)
  free_lists[$alloc_order]=$(echo "${free_lists[$alloc_order]}" | sed "s/^$block_addr //; s/ $block_addr$//; s/ $block_addr / /")
  if [[ -z "${free_lists[$alloc_order]}" ]]; then
    unset free_lists[$alloc_order]
  fi

  # Dividir el bloque si es más grande de lo necesario
  while [ $alloc_order -gt $order ]; do
    ((alloc_order--))
    local buddy1_addr=$block_addr
    local buddy2_addr=$((block_addr + (2 ** alloc_order)))

    # Añadir el segundo buddy a la lista de libres
    free_lists[$alloc_order]="${free_lists[$alloc_order]}$buddy2_addr "
    memory_map[$buddy2_addr]=$alloc_order
    memory_map[$buddy1_addr]=$alloc_order
  done

  # Asignar el bloque
  allocated_blocks["$name"]="$block_addr,$order"
  echo "OK: Reservado '$name' en la dirección $block_addr con tamaño $block_size."
  return 0
}

# Libera un bloque de memoria
bs_free() {
  local name="$1"

  # Validación
  if ! [[ -v allocated_blocks["$name"] ]]; then
    echo "ERROR: No existe una reserva con el nombre '$name'." >&2
    return 1
  fi

  local addr_order=${allocated_blocks["$name"]}
  local addr=${addr_order%,*}
  local order=${addr_order#*,}

  unset allocated_blocks["$name"]

  # Iniciar proceso de fusión
  while [ $order -lt $TOTAL_MEMORY_ORDER ]; do
    local buddy_addr=$((addr ^ (2 ** order)))

    # Verificar si el buddy está libre
    local buddy_is_free=false
    if [[ -v free_lists[$order] ]] && [[ "${free_lists[$order]}" =~ (^| )$buddy_addr( |$) ]]; then
      buddy_is_free=true
    fi

    if ! $buddy_is_free; then
      # El buddy está ocupado, no se puede fusionar más
      break
    fi

    # El buddy está libre, fusionar
    # Quitar el buddy de la lista de libres
    free_lists[$order]=$(echo "${free_lists[$order]}" | sed "s/^$buddy_addr //; s/ $buddy_addr$//; s/ $buddy_addr / /")
    if [[ -z "${free_lists[$order]}" ]]; then
      unset free_lists[$order]
    fi

    # El nuevo bloque fusionado tendrá la dirección más baja
    addr=$([ $addr -lt $buddy_addr ] && echo $addr || echo $buddy_addr)
    ((order++))
  done

  # Añadir el bloque (posiblemente fusionado) a la lista de libres
  free_lists[$order]="${free_lists[$order]}$addr "
  memory_map[$addr]=$order

  echo "OK: Liberado '$name'."
  return 0
}

# Muestra el estado actual de la memoria
bs_show() {
  echo "--- Bloques Reservados ---"
  if [ ${#allocated_blocks[@]} -eq 0 ]; then
    echo "(Ninguno)"
  else
    for name in "${!allocated_blocks[@]}"; do
      local addr_order=${allocated_blocks[$name]}
      local addr=${addr_order%,*}
      local order=${addr_order#*,}
      local size=$((2 ** order))
      echo "  - $name: Dirección=$addr, Tamaño=$size"
    done
  fi

  echo "--- Bloques Libres por Tamaño (Orden) ---"
  if [ ${#free_lists[@]} -eq 0 ]; then
    echo "(Ninguno)"
  else
    for order in $(echo "${!free_lists[@]}" | tr ' ' '\n' | sort -n); do
      local size=$((2 ** order))
      echo "  - Tamaño $size (Orden $order): [${free_lists[$order]}]"
    done
  fi
}
