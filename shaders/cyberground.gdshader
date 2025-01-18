shader_type spatial;

uniform vec3 grid_color : source_color = vec3(0.0, 1.0, 1.0); // Cyan color for the grid
uniform float line_thickness = 0.02; // Thickness of the grid lines
uniform float glow_intensity = 1.0; // Intensity of the glow effect

void fragment() {
    // Scale UV coordinates to control grid density
    vec2 uv = UV * 10.0;

    // Create the grid pattern
    vec2 grid = abs(fract(uv - 0.5) - 0.5) / fwidth(uv);
    float line = min(grid.x, grid.y);

    // Determine the color based on the grid pattern
    vec3 color = grid_color * (1.0 - smoothstep(0.0, line_thickness, line));

    // Apply the color to the fragment
    ALBEDO = color;

    // Add emission for the glow effect
    EMISSION = color * glow_intensity;
}
