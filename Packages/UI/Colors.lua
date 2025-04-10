-- Source: https://snipplr.com/view/40782/color-to-rgb-value-table-in-lua

-- Color to RGB value table for Lua coding with Corona
-- Color values copied from "http://www.w3.org/TR/SVG/types.html#ColorKeywords"
--
-- Usage for Corona toolkit:
-- add this file "Colors-rgb.lua" to your working directory
-- add following directive to any file that will use the Colors by name:
-- require "Colors-rgb"
--
-- in the code, instead of using for example "{210, 105, 30}" for the "chocolate" color,
-- use "Colors.chocolate" or Colors[chocolate]
-- or if you need the individual R,G,B values, you can use either:
-- Colors.chocolate[1] or Colors.R("chocolate") for the R-value
-- or if you need the RGB values for a function list, you can use
-- Colors.RGB("chocolate") that returns the multi value list "210 105 30"
-- this can be used for input in for example "body:setFillColor()", like:
-- body:setFillColor(Colors.RGB("chocolate"))
--
-- Enjoy, Frank (Sep 19, 2010)
     
     
Colors = {
    aliceblue = {240/255, 248/255, 255/255},
    antiquewhite = {250/255, 235/255, 215/255},
    aqua = { 0/255, 255/255, 255/255},
    aquamarine = {127/255, 255/255, 212/255},
    azure = {240/255, 255/255, 255/255},
    beige = {245/255, 245/255, 220/255},
    bisque = {255/255, 228/255, 196/255},
    black = { 0/255, 0/255, 0/255},
    blanchedalmond = {255/255, 235/255, 205/255},
    blue = { 0/255, 0/255, 255/255},
    blueviolet = {138/255, 43/255, 226/255},
    brown = {165/255, 42/255, 42/255},
    burlywood = {222/255, 184/255, 135/255},
    cadetblue = { 95/255, 158/255, 160/255},
    chartreuse = {127/255, 255/255, 0/255},
    chocolate = {210/255, 105/255, 30/255},
    coral = {255/255, 127/255, 80/255},
    cornflowerblue = {100/255, 149/255, 237/255},
    cornsilk = {255/255, 248/255, 220/255},
    crimson = {220/255, 20/255, 60/255},
    cyan = { 0/255, 255/255, 255/255},
    darkblue = { 0/255, 0/255, 139/255},
    darkcyan = { 0/255, 139/255, 139/255},
    darkgoldenrod = {184/255, 134/255, 11/255},
    darkgray = {169/255, 169/255, 169/255},
    darkgreen = { 0/255, 100/255, 0/255},
    darkgrey = {169/255, 169/255, 169/255},
    darkkhaki = {189/255, 183/255, 107/255},
    darkmagenta = {139/255, 0/255, 139/255},
    darkolivegreen = { 85/255, 107/255, 47/255},
    darkorange = {255/255, 140/255, 0/255},
    darkorchid = {153/255, 50/255, 204/255},
    darkred = {139/255, 0/255, 0/255},
    darksalmon = {233/255, 150/255, 122/255},
    darkseagreen = {143/255, 188/255, 143/255},
    darkslateblue = { 72/255, 61/255, 139/255},
    darkslategray = { 47/255, 79/255, 79/255},
    darkslategrey = { 47/255, 79/255, 79/255},
    darkturquoise = { 0/255, 206/255, 209/255},
    darkviolet = {148/255, 0/255, 211/255},
    deeppink = {255/255, 20/255, 147/255},
    deepskyblue = { 0/255, 191/255, 255/255},
    dimgray = {105/255, 105/255, 105/255},
    dimgrey = {105/255, 105/255, 105/255},
    dodgerblue = { 30/255, 144/255, 255/255},
    firebrick = {178/255, 34/255, 34/255},
    floralwhite = {255/255, 250/255, 240/255},
    forestgreen = { 34/255, 139/255, 34/255},
    fuchsia = {255/255, 0/255, 255/255},
    gainsboro = {220/255, 220/255, 220/255},
    ghostwhite = {248/255, 248/255, 255/255},
    gold = {255/255, 215/255, 0/255},
    goldenrod = {218/255, 165/255, 32/255},
    gray = {128/255, 128/255, 128/255},
    grey = {128/255, 128/255, 128/255},
    green = { 0/255, 128/255, 0/255},
    greenyellow = {173/255, 255/255, 47/255},
    honeydew = {240/255, 255/255, 240/255},
    hotpink = {255/255, 105/255, 180/255},
    indianred = {205/255, 92/255, 92/255},
    indigo = { 75/255, 0/255, 130/255},
    ivory = {255/255, 255/255, 240/255},
    khaki = {240/255, 230/255, 140/255},
    lavender = {230/255, 230/255, 250/255},
    lavenderblush = {255/255, 240/255, 245/255},
    lawngreen = {124/255, 252/255, 0/255},
    lemonchiffon = {255/255, 250/255, 205/255},
    lightblue = {173/255, 216/255, 230/255},
    lightcoral = {240/255, 128/255, 128/255},
    lightcyan = {224/255, 255/255, 255/255},
    lightgoldenrodyellow = {250/255, 250/255, 210/255},
    lightgray = {211/255, 211/255, 211/255},
    lightgreen = {144/255, 238/255, 144/255},
    lightgrey = {211/255, 211/255, 211/255},
    lightpink = {255/255, 182/255, 193/255},
    lightsalmon = {255/255, 160/255, 122/255},
    lightseagreen = { 32/255, 178/255, 170/255},
    lightskyblue = {135/255, 206/255, 250/255},
    lightslategray = {119/255, 136/255, 153/255},
    lightslategrey = {119/255, 136/255, 153/255},
    lightsteelblue = {176/255, 196/255, 222/255},
    lightyellow = {255/255, 255/255, 224/255},
    lime = { 0/255, 255/255, 0/255},
    limegreen = { 50/255, 205/255, 50/255},
    linen = {250/255, 240/255, 230/255},
    magenta = {255/255, 0/255, 255/255},
    maroon = {128/255, 0/255, 0/255},
    mediumaquamarine = {102/255, 205/255, 170/255},
    mediumblue = { 0/255, 0/255, 205/255},
    mediumorchid = {186/255, 85/255, 211/255},
    mediumpurple = {147/255, 112/255, 219/255},
    mediumseagreen = { 60/255, 179/255, 113/255},
    mediumslateblue = {123/255, 104/255, 238/255},
    mediumspringgreen = { 0/255, 250/255, 154/255},
    mediumturquoise = { 72/255, 209/255, 204/255},
    mediumvioletred = {199/255, 21/255, 133/255},
    midnightblue = { 25/255, 25/255, 112/255},
    mintcream = {245/255, 255/255, 250/255},
    mistyrose = {255/255, 228/255, 225/255},
    moccasin = {255/255, 228/255, 181/255},
    navajowhite = {255/255, 222/255, 173/255},
    navy = { 0/255, 0/255, 128/255},
    oldlace = {253/255, 245/255, 230/255},
    olive = {128/255, 128/255, 0/255},
    olivedrab = {107/255, 142/255, 35/255},
    orange = {255/255, 165/255, 0/255},
    orangered = {255/255, 69/255, 0/255},
    orchid = {218/255, 112/255, 214/255},
    palegoldenrod = {238/255, 232/255, 170/255},
    palegreen = {152/255, 251/255, 152/255},
    paleturquoise = {175/255, 238/255, 238/255},
    palevioletred = {219/255, 112/255, 147/255},
    papayawhip = {255/255, 239/255, 213/255},
    peachpuff = {255/255, 218/255, 185/255},
    peru = {205/255, 133/255, 63/255},
    pink = {255/255, 192/255, 203/255},
    plum = {221/255, 160/255, 221/255},
    powderblue = {176/255, 224/255, 230/255},
    purple = {128/255, 0/255, 128/255},
    red = {255/255, 0/255, 0/255},
    rosybrown = {188/255, 143/255, 143/255},
    royalblue = { 65/255, 105/255, 225/255},
    saddlebrown = {139/255, 69/255, 19/255},
    salmon = {250/255, 128/255, 114/255},
    sandybrown = {244/255, 164/255, 96/255},
    seagreen = { 46/255, 139/255, 87/255},
    seashell = {255/255, 245/255, 238/255},
    sienna = {160/255, 82/255, 45/255},
    silver = {192/255, 192/255, 192/255},
    skyblue = {135/255, 206/255, 235/255},
    slateblue = {106/255, 90/255, 205/255},
    slategray = {112/255, 128/255, 144/255},
    slategrey = {112/255, 128/255, 144/255},
    snow = {255/255, 250/255, 250/255},
    springgreen = { 0/255, 255/255, 127/255},
    steelblue = { 70/255, 130/255, 180/255},
    tan = {210/255, 180/255, 140/255},
    teal = { 0/255, 128/255, 128/255},
    thistle = {216/255, 191/255, 216/255},
    tomato = {255/255, 99/255, 71/255},
    turquoise = { 64/255, 224/255, 208/255},
    violet = {238/255, 130/255, 238/255},
    wheat = {245/255, 222/255, 179/255},
    white = {255/255, 255/255, 255/255, 255/255},
    whitesmoke = {245/255, 245/255, 245/255},
    yellow = {255/255, 255/255, 0/255},
    yellowgreen = {154/255, 205/255, 50/255}
}
     
Colors.R = function (name)
    return Colors[name][1]
end
 
Colors.G = function (name)
    return Colors[name][2]
end
 
Colors.B = function (name)
    return Colors[name][3]
end
 
Colors.RGB = function (name)
    return Colors[name][1],Colors[name][2],Colors[name][3]
end

Colors.hexToRGB = function(hex, value)
    return {tonumber(string.sub(hex, 2, 3), 16)/256, tonumber(string.sub(hex, 4, 5), 16)/256, tonumber(string.sub(hex, 6, 7), 16)/256, value or 1}
end