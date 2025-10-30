module p4_v

// (c) Versión iterativa (programación dinámica, bottom-up) de F_{α,β}.
// F(n) = n                      si 0 ≤ n < α * β
//      = sum_{i=1..α} F(n - β * i)  si n ≥ α * β
//
// Esta implementación calcula F(0..n) en O(n * α) tiempo y O(n) espacio.
// Devuelve F(n).

pub fn f_iter(n int, a int, b int) int {
    if n < 0 {
        return 0
    }
    base := a * b
    if n < base {
        return n
    }
    mut dp := []int{len: n + 1, init: 0}
    // base cases
    for k in 0 .. base {
        dp[k] = k
    }
    // fill dp from base .. n
    for k := base ; k <= n ; k++ {
        mut s := 0
        // sum a terms F(k - b*i)
        for i := 1 ; i <= a ; i++ {
            idx := k - b * i
            // idx >= 0 because k >= base = a*b >= b*i
            s += dp[idx]
        }
        dp[k] = s
    }
    return dp[n]
}
