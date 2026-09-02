void SetupMaterial(inout Material material)
{
	vec4 glow = vec4(1.0, 0.0, 0.0, 1.0);
	
	glow.a = 1.0-(vTexCoord.st.y * 3.0);
	
	vec4 final = getTexel(vTexCoord.st);
	
	if (final.a < 0.5) final += glow;
	
// 	if (final.y > 0.20) final.a = 0;

	material.Base = final;
}
