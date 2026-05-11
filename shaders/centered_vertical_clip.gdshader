shader_type canvas_item;

uniform float fill_amount : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	float half_width = fill_amount * 0.5;

	if (
		UV.x < 0.5 - half_width ||
		UV.x > 0.5 + half_width
	) {
		discard;
	}
}
