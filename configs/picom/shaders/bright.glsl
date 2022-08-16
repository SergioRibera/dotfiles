#version 130

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;
uniform float time;

float amt = 2500.0;

void main() {
    float pct = mod(time, amt) / amt;
    vec2 pos = gl_TexCoord[0].st;
    vec4 c = texture2D(tex, pos);
    if (pos.x + pos.y < pct * 4.0 && pos.x + pos.y > pct * 4.0 - .5 * pct
       || pos.x + pos.y < pct * 4.0 - .8 * pct && pos.x + pos.y > pct * 3.0)
        c *= vec4(2, 2, 2, 1);
    c *= opacity;
    gl_FragColor = c;
}
