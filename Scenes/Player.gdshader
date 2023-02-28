shader_type canvas_item;

uniform bool redded = false;

void fragment(){
	if (redded && COLOR.b > 0.5 && COLOR.r < 0.5){
		COLOR.r = COLOR.b*1.1;
		COLOR.b = COLOR.r*0.25;
		COLOR.g = COLOR.g * 0.3;
	}
}