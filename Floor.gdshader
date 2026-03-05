shader_type spatial;

uniform vec4 base : source_color;
uniform vec4 base2 : source_color;

uniform sampler2D noi1 : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 n1 = texture(noi1, UV);
	
	vec4 alb = n1;
	ALBEDO = mix(base.rgb,base2.rgb, n1.r);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
