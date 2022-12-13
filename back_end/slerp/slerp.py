import numpy as np

# spherical linear interpolation (slerp)
def slerp(val, low, high):
	omega = np.arccos(np.clip(np.dot(low/np.linalg.norm(low), high/np.linalg.norm(high)), -1, 1))
	so = np.sin(omega)
	if so == 0:
		# L'Hopital's rule/LERP
		return (1.0-val) * low + val * high
	return np.sin((1.0-val)*omega) / so * low + np.sin(val*omega) / so * high

def get_point():
	# generate points in the latent space
	x_input = np.random.randn(1)
	# reshape into a batch of inputs for the network
	z_input = x_input.reshape(1, 1)
	return z_input

def slerp_list(pts, steps):
	new_pts = []
	ratios = np.linspace(0, 1, num=steps)	
	for idx in range(len(pts)-1):
		pt1 = pts[idx]
		pt2 = pts[idx+1]
		new = slerp(ratios, pt1, pt2)
		#drop last slerped vector to avoid duplication
		last_idx = len(new)-1
		new = new[:last_idx]
		new_pts.append(new)
	# add the very last point
	new_pts.append(pts[-1])
	print(new_pts)

def slerp_test():
	v1 = get_point()
	v2 = get_point()
	ratios = np.linspace(0, 1, num=3)
	print(slerp(np.array([0.5]), v1, v2))

def main():
	slerp_list([np.array(1.0), np.array(2.0), np.array(3.0)], 3)

if __name__ == '__main__':
    main()