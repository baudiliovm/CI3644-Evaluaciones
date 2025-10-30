module p4_v

// (a) Implementación recursiva directa de F_{α,β} según la fórmula:
// F(n) = n                      si 0 ≤ n < α * β
//      = sum_{i=1..α} F(n - β * i)  si n ≥ α * β
//
// α = ((X + Y) % 5) + 3
// β = ((Y + Z) % 5) + 3

pub fn alpha_beta_from_carnet(x int, y int, z int) (int, int) {
    a := ((x + y) % 5) + 3
    b := ((y + z) % 5) + 3
    return a, b
}

// Implementación recursiva directa (traducción literal).
pub fn f_direct(n int, a int, b int) int {
    if n >= 0 && n < a * b {
        return n
    }
    mut s := 0
    for i in 1 .. a + 1 {
        s += f_direct(n - b * i, a, b)
    }
    return s
}

