module p4_v

// (b) Versión "recursiva de cola" (tail-like) para F_{α,β}.
// Nota: la suma sobre i=1..α se hace en posición de cola via un helper.
// Cada término sigue requiriendo calcular F(n - β*i) (aquí usamos memoización
// para que la implementación sea práctica).
//
// Firma pública: f_tail(n, a, b, mut memo)
// memo debe ser un map[int]int pasado por referencia para reutilizar resultados.

pub fn f_tail(n int, a int, b int, mut memo map[int]int) int {
    if n >= 0 && n < a * b {
        memo[n] = n
        return n
    }
    return f_tail_helper(n, a, b, 1, 0, mut memo)
}

fn f_tail_helper(n int, a int, b int, i int, acc int, mut memo map[int]int) int {
    if i > a {
        return acc
    }
    key := n - b * i
    mut val := 0
    if v := memo[key] {
        val = v
    } else {
        val = f_tail(key, a, b, mut memo)
        memo[key] = val
    }
    return f_tail_helper(n, a, b, i + 1, acc + val, mut memo)
}

