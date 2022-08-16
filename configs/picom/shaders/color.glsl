#version 130
uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

void main() {
    vec4 c = texture2D(tex, gl_TexCoord[0].xy);
    float g = (c.r + c.g + c.b) / 3.0;	// EDIT1: Average.
    c = vec4(vec3(g), c.a);             // EDIT2: Color.
    if (invert_color)
        c = vec4(vec3(c.a, c.a, c.a) - vec3(c), c.a);
    c *= opacity;
    gl_FragColor = c;
}
