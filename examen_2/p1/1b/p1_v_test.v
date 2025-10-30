module p1_v

fn test_count_collatz_example() {
    assert count_collatz(42) == 8
}

fn test_mergesort_basic() {
    arr := [3,1,4,1,5,9]
    sorted := mergesort(arr)
    assert sorted == [1,1,3,4,5,9]
}