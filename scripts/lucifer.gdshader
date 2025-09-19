// Declare the type of shader (assuming this is part of a larger framework)
shader_type canvas_item;

// Uniform variables
uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;  // Flash strength, between 0 and 1
uniform vec4 flash_color_target = vec4(1.0, 1.0, 1.0, 1.0);  // Dark purple (RGB: 0.3, 0.0, 0.3, Alpha: 1.0)

// Fragment shader function
void fragment() {
    // Sample the texture color at the given UV coordinates
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Blend the original color with the target flash color based on the flash strength
    vec3 flash_color = mix(tex_color.rgb, flash_color_target.rgb, flash_strength);
    
    // Output the final color, preserving the original alpha (transparency) from tex_color
    COLOR = vec4(flash_color, tex_color.a);
}
