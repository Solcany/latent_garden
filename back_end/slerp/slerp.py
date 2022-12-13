import numpy as np

# spherical linear interpolation (slerp)
def slerp(val, low, high):
	omega = np.arccos(np.clip(np.dot(low/np.linalg.norm(low), high/np.linalg.norm(high)), -1, 1))
	so = np.sin(omega)
	if so == 0:
		# L'Hopital's rule/LERP
		return (1.0-val) * low + val * high
	return np.sin((1.0-val)*omega) / so * low + np.sin(val*omega) / so * high

def get_points():
	latent_dim = 2
	n_samples = 2
	# generate points in the latent space
	x_input = np.random.randn(latent_dim * n_samples)
	# reshape into a batch of inputs for the network
	z_input = x_input.reshape(n_samples, latent_dim)
	return z_input

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
	print(slerped_vectors)

def main():
	data = [np.array([1.0, 1.0]), 
			np.array([2.0, 2.0]), 
			np.array([3.0, 3.0])]
	#ratios = np.linspace(0, 1, num=4)

	#points = get_points()	

	slerp_list(data, 4)

	# for ratio in ratios:
	# 	print(slerp(ratio, data[0], data[1]))



	#slerp_list(data, 3)

if __name__ == '__main__':
    main()