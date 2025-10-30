# Examen 2 - CI3644

Esta carpeta contiene las soluciones y pruebas correspondientes al Examen 2 de la materia CI3644 (Lenguajes de Programación).

## Estructura

- `p1/` — Pregunta 1
  - `1a/`
    - `a.txt` — Respuesta escrita (lenguaje V) sobre evaluación y orden de ejecución.
  - `1b/`
    - `1.v`, `2.v` — Implementaciones en V para la parte práctica de la P1.
    - `p1_v_test.v` — Pruebas en V para P1.

- `p2/` — Pregunta 2 (V)
  - `exp.v` — Implementación principal: evaluador de expresiones (prefijo/posfijo) con impresión infija mínima usando AST.
  - `p2_v_test.v` — Pruebas en V para validar parseo, evaluación y conversión a infijo.

- `p3/` — Pregunta 3 (Python)
  - `resp.py` — Implementación de los iteradores `suspenso`, `misterio` y del iterador ordenado (heap y selección). Incluye un demo en `__main__`.
  - `p3_v_test.py` — Pruebas con `pytest` que verifican salidas de `suspenso`, `misterio(5)` y del iterador ordenado.
  - `explicacion.txt` — Documento con la explicación paso a paso, trazas por marcos de pila y salidas esperadas.

- `p4/` — Pregunta 4 (V)
  - `a.v` — Implementación directa recursiva de F(α,β).
  - `b.v` — Variante tipo tail con memoización (recursiva) de F(α,β).
  - `c.v` — Variante iterativa/dinámica de F(α,β).
  - `p4_v_test.v` — Pruebas que comparan correctitud entre variantes y miden tiempos de referencia.

## Requisitos

- V (Vlang) instalado para compilar/ejecutar las soluciones y pruebas en V.
- Python 3.x y `pytest` para ejecutar las pruebas de P3.

## Cómo ejecutar las pruebas

- Pruebas en V (P1, P2, P4):

```bash
# Desde la carpeta del problema (por ejemplo p2):
cd p2
v test .
# (Opcional) con estadísticas
v -stats test .
```

- Pruebas en Python (P3):

```bash
cd p3
pytest -q
```

## Notas

- En P3, el demo en `resp.py` usa por defecto X=6, Y=6, Z=5 para mostrar las salidas de `suspenso` y `misterio(5)`, y ejemplifica el iterador ordenado sobre `[1,3,3,2,1]`.
- En P4, los parámetros (α, β) se determinan a partir de los valores X, Y, Z según el enunciado; las pruebas incluyen comparaciones entre las tres variantes y una pequeña medición de tiempos.
