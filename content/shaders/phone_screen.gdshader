shader_type canvas_item;
uniform sampler2D image : source_color;
uniform float something = 1;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	vec4 image_color = texture(image, UV);
	COLOR = vec4(something * base_color.rgb * image_color.rgb, base_color.a);
}
