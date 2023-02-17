shader_type canvas_item;

uniform float gen = 1.0;

void fragment() {
	float value = (0.5+UV.x)*(gen)*22.0*COLOR.r;
	if (value > 10.0){
		
	}
	else if(value > 9.5){
		COLOR.rgb = vec3(1.0);
	}
	else{
		COLOR.a = 0.0;
		
	}
}
