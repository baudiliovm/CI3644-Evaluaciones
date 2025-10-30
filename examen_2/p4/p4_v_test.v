module p4_v_test

import p4_v
import time

fn test_direct_vs_iter_small() {
    a, b := p4_v.alpha_beta_from_carnet(6, 6, 5)
    for n in 0 .. a * b + 6 {
        assert p4_v.f_direct(n, a, b) == p4_v.f_iter(n, a, b)
    }
}

fn test_tail_vs_iter_medium() {
    a, b := p4_v.alpha_beta_from_carnet(6, 6, 5)
    ns := [a * b + 5, a * b + 15, a * b + 40, a * b + 80]
    mut memo := map[int]int{}
    for n in ns {
        assert p4_v.f_tail(n, a, b, mut memo) == p4_v.f_iter(n, a, b)
    }
}

fn test_iter_base_cases_and_growth() {
    a, b := p4_v.alpha_beta_from_carnet(6, 6, 5)
    for n in 0 .. a * b {
        assert p4_v.f_iter(n, a, b) == n
    }
    assert p4_v.f_iter(a * b + 10, a, b) > p4_v.f_iter(a * b + 5, a, b)
}

fn test_timing_snapshot() {
    a, b := p4_v.alpha_beta_from_carnet(6, 6, 5)
    ns := [a * b + 5, a * b + 20]
    mut memo := map[int]int{}
    for n in ns {
        start := time.now()
        _ = p4_v.f_direct(n, a, b)
        println('direct,n=$n,elapsed=${time.since(start)}')
    }
    for n in ns {
        start := time.now()
        _ = p4_v.f_tail(n, a, b, mut memo)
        println('tail,n=$n,elapsed=${time.since(start)}')
    }
    for n in ns {
        start := time.now()
        _ = p4_v.f_iter(n, a, b)
        println('iter,n=$n,elapsed=${time.since(start)}')
    }
}