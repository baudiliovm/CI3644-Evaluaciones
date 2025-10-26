module p1_v

pub fn merge(left []int, right []int) []int {
	mut res := []int{}
	mut i := 0
	mut j := 0
	for i < left.len && j < right.len {
		if left[i] <= right[j] {
			res << left[i]
			i++
		} else {
			res << right[j]
			j++
		}
	}
	if i < left.len {
		res << left[i..]
	}
	if j < right.len {
		res << right[j..]
	}
	return res
}

pub fn mergesort(arr []int) []int {
	if arr.len <= 1 {
		return arr
	}
	mid := arr.len / 2
	left := mergesort(arr[0..mid])
	right := mergesort(arr[mid..])
	return merge(left, right)
}
