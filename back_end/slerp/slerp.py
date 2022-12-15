import numpy as np


# uniform interpolation between two points
def lerp(ratio, p1, p2):
	# linear interpolate vectors
	return (1.0 - ratio) * p1 + ratio * p2

def lerp_list(vectors, steps=3):
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
	return lerped_vectors	

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
	return slerped_vectors

def main():
	# data = [np.array([1.0, 1.0, 1.0]), 
	# 		np.array([2.0, 2.0, 2.0]), 
	# 		np.array([3.0, 3.0, 3.0])]

	#indexes = [1,2]
	ids = np.array([np.array([1.0]), np.array([2.0])])
	vecs = np.array([np.array([3.33, 3.33]), np.array([5.55, 5.55])])
	data = np.hstack((ids, vecs))

	#lerped_ids = lerp_list(ids)
	print(data)
	#slerp_list(vectors=data, steps=4)

if __name__ == '__main__':
    main()