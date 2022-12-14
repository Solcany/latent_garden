import numpy as np

# spherical linear interpolation (slerp)
def slerp(val, low, high):
	omega = np.arccos(np.clip(np.dot(low/np.linalg.norm(low), high/np.linalg.norm(high)), -1, 1))
	so = np.sin(omega)
	if so == 0:
		# L'Hopital's rule/LERP
		return (1.0-val) * low + val * high
	return np.sin((1.0-val)*omega) / so * low + np.sin(val*omega) / so * high

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