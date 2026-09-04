// Bloom for industrial-theme, after the phosphor bleed in the frame.work ASCII art.
// Ghostty: custom-shader = ~/.config/nvim/extras/ghostty/industrial-bloom.glsl

const float THRESHOLD  = 0.22;  // luma above which a pixel blooms
const float STRENGTH   = 0.60;  // how much glow is added back
const float RADIUS     = 3.0;   // spread in px at 1080p, scaled for DPI
const float WARM_BOOST = 1.60;  // extra bloom for orange pixels, i.e. keywords
const float ABERRATION = 0.60;  // blue/red fringe in px, as in the reference art

float luma(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

vec3 brightPass(vec2 uv) {
    vec3 c = texture(iChannel0, uv).rgb;
    float keep = smoothstep(THRESHOLD, THRESHOLD + 0.30, luma(c));
    float warm = clamp((c.r - c.b) * 2.0, 0.0, 1.0);
    return c * keep * mix(1.0, WARM_BOOST, warm);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 base = texture(iChannel0, uv);

    float scale = max(iResolution.y / 1080.0, 1.0);
    vec2 px = (RADIUS * scale) / iResolution.xy;

    vec3 sum = brightPass(uv) * 0.22;
    float wsum = 0.22;
    for (int i = 0; i < 8; i++) {
        vec2 d = vec2(cos(float(i) * 0.785398), sin(float(i) * 0.785398));
        sum += brightPass(uv + d * px) * 0.10;
        sum += brightPass(uv + d * px * 2.3) * 0.045;
        wsum += 0.145;
    }
    vec3 glow = sum / wsum;

    vec2 ab = (ABERRATION * scale) / iResolution.xy;
    glow.b = mix(glow.b, brightPass(uv + vec2(ab.x, 0.0)).b, 0.5);
    glow.r = mix(glow.r, brightPass(uv - vec2(ab.x, 0.0)).r, 0.5);

    fragColor = vec4(base.rgb + glow * STRENGTH, base.a);
}
