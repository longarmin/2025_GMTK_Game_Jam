shader_type canvas_item;

uniform float inner_outline_width : hint_range(0.0, 10.0) = 1.0;
uniform vec4 inner_outline_color : source_color = vec4(0.75, 0.75, 0.75, 1.0);
uniform float outer_outline_width : hint_range(0.0, 10.0) = 3.0;
uniform vec4 outer_outline_color : source_color = vec4(0.25, 0.125, 0.375, 1.0);
uniform vec4 texture_region = vec4(0.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	// Inner outline calculation (kopiert vom Original)
	vec2 inner_offset = vec2(inner_outline_width) * TEXTURE_PIXEL_SIZE;
	vec4 uv_region = vec4(texture_region.xy * TEXTURE_PIXEL_SIZE, texture_region.zw * TEXTURE_PIXEL_SIZE);
	uv_region.zw = mix(vec2(1.0), uv_region.zw, ceil(uv_region.zw));

	float uv_offset;
	float a;
	float inner_max_a = 0.0;

	// Inner outline - 4 Richtungen
	uv_offset = UV.y - inner_offset.y;
	a = step(uv_region.y, uv_offset) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	inner_max_a = max(a, inner_max_a);

	uv_offset = UV.y + inner_offset.y;
	a = step(uv_offset, uv_region.y + uv_region.w) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	inner_max_a = max(a, inner_max_a);

	uv_offset = UV.x - inner_offset.x;
	a = step(uv_region.x, uv_offset) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	inner_max_a = max(a, inner_max_a);

	uv_offset = UV.x + inner_offset.x;
	a = step(uv_offset, uv_region.x + uv_region.z) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	inner_max_a = max(a, inner_max_a);

	// Outer outline calculation - nur als Schatten (rechts und unten)
	vec2 outer_offset = vec2(outer_outline_width) * TEXTURE_PIXEL_SIZE;
	float outer_max_a = 0.0;

	// Schatten - nur rechts und unten
	uv_offset = UV.y + outer_offset.y; // unten
	a = step(uv_offset, uv_region.y + uv_region.w) * texture(TEXTURE, vec2(UV.x, uv_offset)).a;
	outer_max_a = max(a, outer_max_a);

	uv_offset = UV.x + outer_offset.x; // rechts
	a = step(uv_offset, uv_region.x + uv_region.z) * texture(TEXTURE, vec2(uv_offset, UV.y)).a;
	outer_max_a = max(a, outer_max_a);

	// Optional: unten-rechts diagonal für besseren Schatten-Effekt
	//a = step(UV.x + outer_offset.x, uv_region.x + uv_region.z) *
	    //step(UV.y + outer_offset.y, uv_region.y + uv_region.w) *
	    //texture(TEXTURE, UV + outer_offset).a;
	//outer_max_a = max(a, outer_max_a);

	// Layer composition: outer behind inner behind original
	vec4 result = color;

	// Add outer outline where there's no original pixel
	if (color.a < 0.1 && outer_max_a > 0.0) {
		result = outer_outline_color;
	}

	// Add inner outline on top (overrides outer where present)
	if (color.a < 0.1 && inner_max_a > 0.0) {
		result = inner_outline_color;
	}

	// Original sprite always on top
	if (color.a > 0.1) {
		result = color;
	}

	COLOR = result;
}