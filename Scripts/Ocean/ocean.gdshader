shader_type spatial;

// Wave parameters
uniform float wave_height : hint_range(0.0, 10.0) = 1.0;
uniform float wave_frequency : hint_range(0.0, 10.0) = 1.0;
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform vec2 wave_direction = vec2(1.0, 0.0);

// Foam parameters
uniform float foam_threshold : hint_range(0.0, 1.0) = 0.7;
uniform float foam_smoothness : hint_range(0.0, 1.0) = 0.1;
uniform vec4 foam_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Water colors
uniform vec4 water_deep_color : source_color = vec4(0.02, 0.05, 0.2, 1.0);
uniform vec4 water_shallow_color : source_color = vec4(0.1, 0.3, 0.5, 1.0);
uniform float water_blend : hint_range(0.0, 1.0) = 0.5;

// Surface properties
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;

// Noise texture for detail
uniform sampler2D noise_texture : repeat_enable;
uniform float noise_scale = 0.5;

// Multi-octave wave generation
float generate_wave(vec2 uv, float time) {
    vec2 dir_norm = normalize(wave_direction);
    
    // Primary wave
    float wave1 = sin(dot(uv * wave_frequency, dir_norm) + time * wave_speed) * 0.5;
    
    // Secondary wave (offset direction)
    vec2 dir2 = vec2(-dir_norm.y, dir_norm.x) * 0.7;
    float wave2 = sin(dot(uv * wave_frequency * 1.3, dir2) + time * wave_speed * 1.1) * 0.3;
    
    // Tertiary detail wave
    float wave3 = sin(dot(uv * wave_frequency * 2.5, dir_norm * 0.5) - time * wave_speed * 0.8) * 0.2;
    
    return (wave1 + wave2 + wave3) * wave_height;
}

void vertex() {
    vec2 world_uv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
    float wave = generate_wave(world_uv, TIME);
    
    // Add noise detail
    float noise = texture(noise_texture, world_uv * noise_scale + TIME * 0.05).r;
    wave += (noise - 0.5) * wave_height * 0.2;
    
    VERTEX.y += wave;
    
    // Pass wave height to fragment for foam calculation
    UV.y = wave / max(wave_height, 0.01);
}

void fragment() {
    // Sample noise for surface detail
    float noise = texture(noise_texture, UV * 5.0 + TIME * 0.1).r;
    
    // Generate foam based on wave peaks
    float wave_foam = smoothstep(foam_threshold - foam_smoothness, foam_threshold + foam_smoothness, UV.y + noise * 0.2);
    
    // Blend water colors
    vec3 water_color = mix(water_deep_color.rgb, water_shallow_color.rgb, water_blend);
    
    // Apply foam
    vec3 final_color = mix(water_color, foam_color.rgb, wave_foam);
    
    ALBEDO = final_color;
    METALLIC = metallic;
    ROUGHNESS = roughness;
    SPECULAR = 0.5;
}