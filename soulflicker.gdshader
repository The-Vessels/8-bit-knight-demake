shader_type canvas_item;
uniform float mixvalue:hint_range(0.0, 1.0, 0.1);
uniform vec4 hurtcolor:source_color;

void fragment() {
	vec4 basesoul = texture(TEXTURE,UV);
	vec4 hurtsoul = vec4(hurtcolor.r,hurtcolor.b,hurtcolor.g,basesoul.a);
	COLOR = mix(basesoul,hurtsoul,mixvalue);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
