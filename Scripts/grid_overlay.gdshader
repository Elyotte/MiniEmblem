shader_type canvas_item;

uniform vec2 cell_size = vec2(128.0, 128.0);
uniform vec2 grid_origin = vec2(0.0, 0.0); // position monde du coin de la grille
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 0.6);
uniform float line_thickness : hint_range(0.5, 4.0) = 1.0;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	vec2 local = world_pos - grid_origin;
	vec2 cell_pos = mod(local, cell_size);

	bool on_line = cell_pos.x < line_thickness || cell_pos.y < line_thickness;

	if (on_line) {
		COLOR = mix(tex_color, line_color, line_color.a);
	} else {
		COLOR = tex_color;
	}
}