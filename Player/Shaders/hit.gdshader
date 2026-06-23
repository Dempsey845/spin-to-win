shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float inner_radius : hint_range(0.0, 1.0) = 0.3;
uniform float outer_radius : hint_range(0.0, 2.0) = 1.0;

uniform vec4 blood_color : source_color = vec4(0.5, 0.0, 0.0, 1.0);

void fragment() {
    float x = abs(UV.x - 0.5) * 2.0;
    float y = abs(UV.y - 0.5) * 2.0;

    float dist = sqrt(x * x + y * y);

    float vignette = smoothstep(inner_radius, outer_radius, dist);

    COLOR = vec4(blood_color.rgb, vignette * strength);
}