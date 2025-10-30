module p1_v

pub fn f(n int) int {
    if n % 2 == 0 {
        return n / 2
    }
    return 3 * n + 1
}

pub fn count_collatz(m int) int {
    mut cnt := 0
    mut n := m
    for n != 1 {
        n = f(n)
        cnt++
        // protección contra ciclos infinitos no esperados
        if cnt > 1_000_000 {
            break
        }
    }
    return cnt
}
