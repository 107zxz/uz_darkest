void SetupMaterial(inout Material material)
{
	vec4 glow = vec4(1.0, 0.5, 0.0, 1.0);
	
	glow.a = (0.5 - length(vTexCoord.st - vec2(0.5, 0.5)));
	
	vec4 final = getTexel(vTexCoord.st);
	
	if (final.a < 0.5) final += glow;
	else final.rgb += glow.rgb*0.1;

	material.Base = final;
}
