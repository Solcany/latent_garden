import numpy as np


# uniform interpolation between two points
def lerp(ratio, p1, p2):
	# linear interpolate vectors
	return (1.0 - ratio) * p1 + ratio * p2

def lerp_list(vectors, steps):
	lerped_vectors = []
	ratios = np.linspace(0., 1., num=steps)
	# remove the last ratio = 1.0 to avoid duplicate vectors
	ratios = ratios[:len(ratios)-1]
	for idx in range(len(vectors)-1):
		vec1 = vectors[idx]
		vec2 = vectors[idx+1]
		for ratio in ratios:
			new_vec = lerp(ratio, vec1, vec2)
			lerped_vectors.append(new_vec)
	# add the very last point
	lerped_vectors.append(vectors[-1])
	return np.asarray(lerped_vectors)

# spherical linear interpolation (slerp)
def slerp(ratio, p1, p2):
	omega = np.arccos(np.clip(np.dot(p1/np.linalg.norm(p1), p2/np.linalg.norm(p2)), -1, 1))
	so = np.sin(omega)
	if so == 0:
		# L'Hopital's rule/LERP
		return (1.0-ratio) * p1 + ratio * p2
	return np.sin((1.0-ratio)*omega) / so * p1 + np.sin(ratio*omega) / so * p2

def slerp_list(vectors, steps):
	slerped_vectors = []
	ratios = np.linspace(0, 1, num=steps)
	# remove the last ratio = 1.0 to avoid duplicate vectors
	ratios = ratios[:len(ratios)-1]
	for idx in range(len(vectors)-1):
		vec1 = vectors[idx]
		vec2 = vectors[idx+1]
		for ratio in ratios:
			new_vec = slerp(ratio, vec1, vec2)
			slerped_vectors.append(new_vec)
	# add the very last point
	slerped_vectors.append(vectors[-1])
	return np.array(slerped_vectors)

def main():
	# data = [np.array([1.0, 1.0, 1.0]), 
	# 		np.array([2.0, 2.0, 2.0]), 
	# 		np.array([3.0, 3.0, 3.0])]

	#indexes = [1,2]
	steps = 4

	_ids = np.array([np.array([1.0]), np.array([2.0])])
	_vecs = np.array([np.array([2., 10.]), np.array([4., 20.])])
	data = np.hstack((_ids, _vecs))

	ids = data[:, 0]
	lerped_ids = lerp_list(data[:, 0], 4)

	vecs = data[:, 1:]
	slerped_vecs = slerp_list(vecs, 4)

	new_vecs = slerped_vecs[1:-1]
	new_ids = lerped_ids[1:-1]


	new_data = list()
	for z in zip(new_ids, new_vecs):
		id, vecs = z
		s = np.hstack((id, vecs))
		new_data.append(s)
	new_data = np.array(new_data)


	final_data = np.vstack((data, new_data))
	#print(final_data[:, 0])

	to_find = np.array([2.0, 1.33333333])
	print("before sort")
	print(final_data[:, 0])

	# sort array indirectly by returning indices of the sorted array
	#sorted_indexes = np.argsort(final_data[:, 0])
	#print("sort indexes")	
	#print(sorted_indexes)
	#_sorted = np.searchsorted(final_data[:, 0], to_find, sorter=sorted_indexes)
	#print("found indices: ", _sorted)

	# Sample array
	#arr = np.array([1, 2, 3, 4, 5, 1, 2, 3, 4, 5])

	# List of values to search for
	#values = [2, 4]

	# Get a boolean array indicating which values are present in the array
	mask = np.isin(final_data[:, 0], to_find)
	indices = np.where(mask)
	print(indices)

	# Get the indices of the values that are present in the array
	#indices = np.where(mask)

	# Print the indices
	#print(indices)

	# WIP: this finds the sorted elements of the vectors array
	# do i need to sort the vecs array everytime i want to search it?


	#new_data = [ np.hstack((new_ids, new_vecs))
	#print(new_vecs)
	#print(new_data)
	#slerp_list(vectors=data, steps=4)

if __name__ == '__main__':
    main()