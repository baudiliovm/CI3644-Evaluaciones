def suspenso(a, b):
    """Generator: suspenso(a, b) as defined in the exam."""
    if not b:
        yield a
    else:
        yield a + b[0]
        for x in suspenso(b[0], b[1:]):
            yield x

def misterio(n):
    """Generator: misterio(n) yields one list per iteration (rows of Pascal)."""
    if n == 0:
        yield [1]
    else:
        for x in misterio(n - 1):
            r = []
            for y in suspenso(0, x):
                r.append(y)
            yield r

# Ordered iterators that do the ordering as part of the iterator logic.

import heapq

def ordered_iter_heap(lst):
    """Yield elements in non-decreasing order using an internal min-heap.
    (The ordering work happens inside the iterator, not by returning a pre-sorted list.)"""
    if not lst:
        return
    heap = list(lst)           # copy
    heapq.heapify(heap)        # internal ordering
    while heap:
        yield heapq.heappop(heap)

def ordered_iter_selection(lst):
    """Yield elements using repeated selection (O(n^2)), no pre-sort returned."""
    a = list(lst)  # copy to avoid mutating original
    while a:
        m = min(a)
        yield m
        a.remove(m)

if __name__ == "__main__":
    # Demo con las constantes del enunciado: X=6, Y=6, Z=5
    X, Y, Z = 6, 6, 5
    print("suspenso outputs:")
    for v in suspenso(X+Y+Z, [X, Y, Z]):
        print(v)
    print("misterio(5):")
    for r in misterio(5):
        print(r)
    data = [1,3,3,2,1]
    print("ordered (heap) of [1,3,3,2,1]:", list(ordered_iter_heap(data)))
    print("ordered (selection) of [1,3,3,2,1]:", list(ordered_iter_selection(data)))