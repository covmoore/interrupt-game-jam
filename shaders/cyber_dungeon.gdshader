shader_type sky;

uniform vec3 horizon_color : source_color = vec3(0.3, 0.2, 0.2); 
uniform vec3 zenith_color : source_color = vec3(0.5, 0.2, 0.4); 
uniform float intensity : hint_range(0.0, 2.0) = 1.0;         

void sky() {
    // Ensure EYEDIR is normalized
    vec3 view_dir = normalize(EYEDIR);

    // Calculate the blend factor based on the vertical direction
    float blend_factor = smoothstep(-0.1, 0.5, view_dir.y);

    // Interpolate between horizon and zenith colors
    vec3 base_color = mix(horizon_color, zenith_color, blend_factor);

    // Apply intensity
    vec3 final_color = base_color * intensity;

    // Set the final color
    COLOR = final_color;
}
