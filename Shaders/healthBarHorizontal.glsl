
extern number frac;
extern number leftBound;
extern number rightBound;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color

    float relPos = (texture_coords.x - leftBound) / (rightBound - leftBound);

    if(relPos > frac){
        return vec4(0.0,0.0,0.0,0.0);
    }
    else
    {
        return pixel;
    }
}