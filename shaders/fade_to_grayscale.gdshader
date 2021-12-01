shader_type canvas_item;

uniform float fade_amount: hint_range(0.0, 1.0) = 1.0;
uniform float alpha_amount: hint_range(0.0, 1.0) = 1.0;
uniform vec3 mix_color = vec3(34, 32, 54);

void fragment() {
	vec4 tex = texture(TEXTURE, UV, 2);
	float avg = (tex.r + tex.g + tex.b) / 3.0;

	COLOR.r = mix(mix(tex.r, avg, fade_amount), mix_color.r/255.0, 0.5);
	COLOR.g = mix(mix(tex.g, avg, fade_amount), mix_color.g/255.0, 0.5);
	COLOR.b = mix(mix(tex.b, avg, fade_amount), mix_color.b/255.0, 0.5);
	COLOR.a = mix(0.0, 1.0, alpha_amount);
}
