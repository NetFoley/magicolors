shader_type canvas_item;

uniform float gen = 1.0;

void fragment() {
	float color_int = (COLOR.r + COLOR.g + COLOR.b)/3.0;
	float value = color_int *UV.x + gen;
	if (value >= 1.0){
		
	}
	else if(value > 0.5){
		COLOR.rgb = vec3(1.0);
	}
	else{
		COLOR.a = 0.0;
		
	}
}
