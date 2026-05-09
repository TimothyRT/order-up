shader_type canvas_item;

uniform float amplitude = 10.0;
uniform float speed = 2.0;

void vertex() {
	VERTEX.y += sin(TIME * speed) * amplitude;
}