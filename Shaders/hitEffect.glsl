
extern number frac;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
    //vec4 hitColor = vec4(texture_coords.x, texture_coords.y, 0.0, pixel.a);
    vec4 hitColor = vec4(1.0, 1.0, 1.0, pixel.a);
    vec4 outColor = (1.0 - frac) * pixel + frac * hitColor;

    return outColor * color;
}