import pytest
from resp import suspenso, misterio, ordered_iter_heap, ordered_iter_selection

def test_suspenso_sequence():
    X, Y, Z = 3, 2, 5
    seq = list(suspenso(X+Y+Z, [X, Y, Z]))
    assert seq == [13, 5, 7, 5]

def test_misterio_5_is_pascal_row():
    rows = list(misterio(5))
    # misterio(5) yields only one row (the row for n=5)
    assert rows[-1] == [1, 5, 10, 10, 5, 1]

def test_ordered_iter_heap():
    lst = [1,3,3,2,1]
    assert list(ordered_iter_heap(lst)) == [1,1,2,3,3]

def test_ordered_iter_selection():
    lst = [1,3,3,2,1]
    assert list(ordered_iter_selection(lst)) == [1,1,2,3,3]