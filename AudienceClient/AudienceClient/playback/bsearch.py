import sys

keys = [1, 2, 4, 5, 6, 10]

# binary search that searches nearest elem in array
def bsearch(array, elem):
	l = 0
	r = len(keys) - 1
	m = (l + r) / 2
	while True:
		if r < l:
			break
		m = (l + r) / 2
		if array[m] < elem:
			l = m + 1
		elif array[m] > elem:
			r = m - 1
		else:
			# exact match
			return array[m]
	# fuzzy match
	diffs = {}
	diffs[m] = abs(elem - array[m])
	if m < len(keys)-2: # get right element of m
		diffs[m+1] = abs(elem - array[m+1])
	if m > 1: # get right element of m
		diffs[m-1] = abs(elem - array[m-1])

	minval = sys.maxint
	minindex = -1
	for k,v in diffs.iteritems():
		if v < minval:
			minindex = k
			minval = v

	return array[minindex]

# test loop
for x in range(-10,100):
	print x, ": ", bsearch(keys,x)
