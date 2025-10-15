#!/bin/bash

source ./p3_logic.sh

setUp() {
    bs_init 8
}

test_init_sets_correct_size() {
    bs_init 16
    local total_size=$((2 ** TOTAL_MEMORY_ORDER))
    assertEquals "El tamaño total debe ser 16" 16 "$total_size"
}

test_reserve_success() {
    bs_reserve 4 "A"
    bs_show | grep -q "A"
    assertEquals "El bloque A debe estar reservado" 0 $?
}

test_reserve_fail_too_large() {
    bs_reserve 16 "B"
    assertNotEquals "No debe reservar un bloque demasiado grande" 0 $?
}

test_reserve_duplicate_name() {
    bs_reserve 2 "C"
    bs_reserve 2 "C"
    local count
    count=$(bs_show | grep -c "C")
    assertEquals "No debe permitir nombres duplicados" 1 "$count"
}

test_free_success() {
    bs_reserve 2 "D"
    bs_free "D"
    bs_show | grep -q "D"
    assertNotEquals "El bloque D debe haberse liberado" 0 $?
}

test_free_nonexistent() {
    bs_free "ZZ"
    assertNotEquals "Liberar un nombre inexistente debe fallar" 0 $?
}

test_show_output() {
    output=$(bs_show)
    assertContains "La salida de bs_show debe mencionar bloques" "$output" "Bloque"
}

test_fragmentation_and_merge() {
    bs_reserve 2 "E"
    bs_reserve 2 "F"
    bs_free "E"
    bs_free "F"
    output=$(bs_show)
    assertContains "Debe haber un bloque grande libre tras fusionar" "$output" "Libre"
}

test_full_allocation_and_free() {
    bs_reserve 8 "G"
    bs_show | grep -q "G"
    assertEquals "Debe poder reservar toda la memoria" 0 $?
    bs_free "G"
    bs_show | grep -q "G"
    assertNotEquals "Debe poder liberar toda la memoria" 0 $?
}

. ../shunit2