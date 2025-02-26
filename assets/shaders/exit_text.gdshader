shader_type canvas_item;

void fragment() {
	float wave = sin(VERTEX.y * 0.1 + TIME) * 0.5;
	COLOR.rgb -= wave;
}