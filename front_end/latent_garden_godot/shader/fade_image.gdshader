shader_type spatial;
uniform float plane_mesh_size = 1;
uniform float radius_ratio = 0.9;
uniform sampler2D image;
varying vec2 tex_position;

vec3 rgb(float r, float g, float b) {
	// normalise rgb
	return vec3(r / 255.0, g / 255.0, b / 255.0);
}

float fade_circle_alpha(vec2 uv, vec2 pos, float rad) {
	// distance of uv vertex to the center of the circle
	// negative d means that the vertex is within the radius
	float d = length(pos - uv) - rad;
	float alpha = 0.0;
	// if vertex is inside the circle
	if(d <  0.0) {
		// set normalised distance as alpha
		alpha = abs(d/rad);
		// alpha = smoothstep(.1, .8, alpha);	
	} else {
		alpha = 0.0
	}
	return alpha;
}

void vertex() {
  // Note that the PlaneMesh coordinates are within the [-1,1] range (for a size of 2),
  // while the texture coordinates are within [0,1], 
  // so to normalize we divide by the size of the PlaneMesh 2.0 and add 0.5.
  tex_position = -VERTEX.xy / plane_mesh_size + 0.5;
}

void fragment() {
	vec2 uv = FRAGCOORD.xy;
	vec2 center = VIEWPORT_SIZE.xy * 0.5;
	float radius = VIEWPORT_SIZE.y * radius_ratio;
	ALBEDO = texture(image, tex_position).rgb;
	// ALPHA = fade_circle_alpha(uv, center, radius);
}
