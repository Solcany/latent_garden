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
	# remove the first ratio = 0.0 to avoid duplicate vectors
	# remove the last ratio = 1.0 to avoid duplicate vectors	
	ratios = ratios[1:len(ratios)-1]
	for idx in range(len(vectors)-1):
		vec1 = vectors[idx]
		vec2 = vectors[idx+1]
		for ratio in ratios:
			new_vec = slerp(ratio, vec1, vec2)
			slerped_vectors.append(new_vec)
	# add the very last point
	slerped_vectors.append(vectors[-1])
	return np.array(slerped_vectors)




