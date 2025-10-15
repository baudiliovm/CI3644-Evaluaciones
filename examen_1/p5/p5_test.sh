#!/bin/bash

testSimpleExecutable() {
    td_define_program "app" "LOCAL"
    td_is_executable 'app'
    assertTrue "Un programa en LOCAL debe ser ejecutable" $?
}

testInterpreterChain() {
    td_define_program "myLispApp" "LISP"
    td_define_interpreter "Python" "LISP"
    td_define_interpreter "LOCAL" "Python"
    td_is_executable 'myLispApp'
    assertTrue "La cadena de intérpretes LISP->Python->LOCAL falló" $?
}

testTranslatorChain() {
    td_define_program "legacyCode" "PASCAL"
    td_define_translator "LOCAL" "PASCAL" "C"
    td_define_translator "LOCAL" "C" "LOCAL"
    td_is_executable 'legacyCode'
    assertTrue "La cadena de traductores PASCAL->C->LOCAL falló" $?
}

testNotExecutable() {
    td_define_program "isolatedApp" "Ada"
    td_is_executable 'isolatedApp'
    assertFalse "Un programa sin ruta a LOCAL no debería ser ejecutable" $?
}

testInfiniteCycle() {
    td_define_program "cyclicApp" "LangA"
    td_define_interpreter "LangB" "LangA"
    td_define_interpreter "LangA" "LangB"
    td_is_executable 'cyclicApp'
    assertFalse "El sistema no detectó un ciclo infinito no resoluble" $?
}


# setUp se ejecuta antes de cada prueba para garantizar un estado limpio.
setUp() {
    td_init
}

oneTimeSetUp() {
    source ./p5_logic.sh
}

# Cargar y ejecutar shunit2.
. ../shunit2