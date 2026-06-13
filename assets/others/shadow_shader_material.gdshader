shader_type canvas_item;

uniform vec2 pixel_size = vec2(320.0, 180.0);

void fragment() {
	vec2 pixel_uv = floor(UV * pixel_size) / pixel_size;
	
	float dist = distance(pixel_uv, vec2(0.5));
	float vignette = smoothstep(0.3, 0.8, dist);
	
	COLOR = vec4(0.0, 0.0, 0.0, vignette * 0.5);
}
