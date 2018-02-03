// Final
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
float getBrightness(vec3 t_color) {
    return max(max(t_color.r, t_color.g), t_color.b);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;

    // prepare two types of textures
    
    // original
    vec3 original = texture( iChannel0, uv).xyz;
    
    // shifted
    vec2 shiftedUV = uv;
    
	// scale up
    shiftedUV = shiftedUV * 1.001;
    
    // move
    shiftedUV.x += sin(iTime) / 99.0;
    shiftedUV.y += cos(iTime) / 101.0;
    
    // create texture by the shifted uv
    vec3 shifted = texture( iChannel0, shiftedUV).xyz;
    
    // set effect move around the screen randomly
    vec2 screenCenter = vec2(iResolution.x / tan(iTime * rand(vec2(mod(iTime, 3.0), iTime))), iResolution.y + 2.0);
    
    // decide what to print depends on the distance from the center point
    float d = distance(fragCoord, screenCenter);
    
    // draw texture in stripes
	if (mod(d, 30.0) < 15.0 )
		fragColor = vec4(mix(shifted, original, 0.5), 1);  
    else
    	fragColor = vec4(original,1);
    
    // paint edge to be blue and purple
    if (getBrightness(original) * 2.5 < getBrightness(shifted)) {
        fragColor = mix(fragColor, vec4(vec3(original.y * 5.0, 0, 200.0),0.5), 0.001);
    }
}
