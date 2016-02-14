textures/robo_light/baslt4_1_noise
{
    qer_editorimage textures/robo_light/baslt4_1.tga
    nomipmaps
    surfaceparm nolightmap
    {
        map textures/robo_light/baslt4_1.tga
        rgbGen wave noise 0.6 .3 0 5 
    }
}

textures/robo_light/light_progector_4
{
    qer_editorimage textures/robo_light/light_progector_4.tga
    {
        map textures/robo_light/light_progector_4.tga
        rgbGen identity
        alphaFunc GE128
    }
    {
        map $lightmap 
        blendfunc filter
        rgbGen identity
    }
}

textures/robo_light/light_progector_env
{
    qer_editorimage textures/robo_wall/chrome_env2.tga
    {
        map textures/robo_wall/chrome_env2.tga
        rgbGen identity
        tcGen environment 
    }
    {
        map $lightmap 
        blendfunc filter
        rgbGen identity
    }
}

textures/robo_light/proto_light_sfx1
{
    qer_editorimage textures/robo_light/proto_light.tga
    surfaceparm nomarks
    nomipmaps
    surfaceparm nolightmap    
    {
        map textures/robo_light/proto_light.tga
        rgbGen identity
    }
    {
        map textures/robo_light/proto_lightmap.tga
        blendfunc add
        rgbGen wave sin 0.75 0.25 1 0.1 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 1 1 3 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 1 0 7 
        tcMod scale -1 -1
    }
}

textures/robo_light/proto_light_sfx2
{
    qer_editorimage textures/robo_light/proto_light.tga
    //q3map_lightimage textures/robo_light/proto_lightmap.tga
    surfaceparm nomarks
    nomipmaps
    surfaceparm nolightmap    
    {
        map textures/robo_light/proto_light.tga
        rgbGen identity
    }
    {
        map textures/robo_light/proto_lightmap.tga
        blendfunc add
        rgbGen wave sin 0.5 0.5 1 0.5 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 5 1 3 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 2 0 7 
        tcMod scale -1 -1
    }
}

textures/robo_light/proto_light_sfx3
{
    qer_editorimage textures/robo_light/proto_light.tga
    surfaceparm nomarks
    nomipmaps
    surfaceparm nolightmap    
    {
        map textures/robo_light/proto_light.tga
        rgbGen identity
    }
    {
        map textures/robo_light/proto_lightmap.tga
        blendfunc add
        rgbGen wave sin 0.75 0.25 1 0.5 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 1 1 1 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 1 0 1 
        tcMod scale -1 -1
    }
}

textures/robo_light/proto_light_blue
{
    qer_editorimage  textures/robo_light/light1blue.jpg
    //q3map_lightimage textures/robo_light/light1blue_lightmap.tga
    surfaceparm nomarks
    nomipmaps
    surfaceparm nolightmap    
    {
        map textures/robo_light/light1blue.jpg
        rgbGen identity
    }
    {
        map textures/robo_light/light1blue_lightmap.tga
        blendfunc add
        rgbGen wave sin 0.25 0.5 1 0.2 
    }    
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 5 1 3 
    }
    {
        map textures/robo_light/proto_light2.tga
        blendfunc add
        rgbGen wave triangle 1 2 0 7 
        tcMod scale -1 -1
    }
}

textures/robo_light/robo_light_beam_red
{
    qer_editorimage textures/robo_light/robo_light_beam_red.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_red.tga
        blendfunc gl_one gl_one_minus_src_color
    }
}

textures/robo_light/robo_light_beam_red_wave
{
    qer_editorimage textures/robo_light/robo_light_beam_red.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_red.tga
        blendfunc gl_one gl_one_minus_src_color
        rgbGen wave triangle 0.4 0.1 0 1         
    }
}

textures/robo_light/robo_light_beam_red_noise
{
    qer_editorimage textures/robo_light/robo_light_beam_red.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_red.tga
        blendfunc gl_one gl_one_minus_src_color
        rgbGen wave noise 0.4 .4 0 5 
    }
}

textures/robo_light/robo_light_beam_white
{
    qer_editorimage textures/robo_light/robo_light_beam_white.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_white.tga
        blendfunc add        
    }
}

textures/robo_light/robo_light_beam_white_wave
{
    qer_editorimage textures/robo_light/robo_light_beam_white.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_white.tga
        blendfunc add        
        rgbGen wave triangle 0.3 0.1 0 1                         
    }
}

textures/robo_light/robo_light_beam_white_noise
{
    qer_editorimage textures/robo_light/robo_light_beam_white.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_white.tga
        blendfunc add
        rgbGen wave noise 0.3 .3 0 5 
    }
}

textures/robo_light/robo_light_beam_blue
{
    qer_editorimage textures/robo_light/robo_light_beam_blue.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_blue.tga
        blendfunc add        
    }
}

textures/robo_light/robo_light_beam_blue_wave
{
    qer_editorimage textures/robo_light/robo_light_beam_blue.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_blue.tga
        blendfunc add
        rgbGen wave triangle 0.3 0.2 0 0.5         
    }
}

textures/robo_light/robo_light_beam_blue_noise
{
    qer_editorimage textures/robo_light/robo_light_beam_blue.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_blue.tga
        blendfunc add
        rgbGen wave noise 0.4 .4 0 5 
    }
}

textures/robo_light/robo_light_beam_green
{
    qer_editorimage textures/robo_light/robo_light_beam_green.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_green.tga
        blendfunc add        
    }
}

textures/robo_light/robo_light_beam_green_wave
{
    qer_editorimage textures/robo_light/robo_light_beam_green.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_green.tga
        blendfunc add
        rgbGen wave triangle 0.4 0.1 0 1         
    }
}

textures/robo_light/robo_light_beam_green_noise
{
    qer_editorimage textures/robo_light/robo_light_beam_green.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_white.tga
        blendfunc add
        rgbGen wave noise 0.4 .4 0 5 
    }
}

textures/robo_light/robo_light_beam_yellow
{
    qer_editorimage textures/robo_light/robo_light_beam_yellow.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_yellow.tga
        blendfunc add        
    }
}

textures/robo_light/robo_light_beam_yellow_wave
{
    qer_editorimage textures/robo_light/robo_light_beam_yellow.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_yellow.tga
        blendfunc add
        rgbGen wave triangle 0.4 0.1 0 1
    }
}

textures/robo_light/robo_light_beam_yellow_noise
{
    qer_editorimage textures/robo_light/robo_light_beam_yellow.tga
    qer_trans   0.5
    surfaceparm trans
    cull disable
    nomipmaps
    surfaceparm nolightmap
    {
        clampmap textures/robo_light/robo_light_beam_yellow.tga
        blendfunc add
        rgbGen wave noise 0.4 .4 0 5 
    }
}
 
textures/robo_light/proto_lightblue
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/proto_lightblue.jpg
    {
        map textures/robo_light/proto_lightblue.jpg     
    }
}

textures/robo_light/proto_lightred
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/proto_lightred.jpg
    {
        map textures/robo_light/proto_lightred.jpg      
    }
}

textures/robo_light/proto_lightgreen
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/proto_lightgreen.jpg
    {
        map textures/robo_light/proto_lightgreen.jpg        
    }
}

textures/robo_light/proto_lightyellow
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/proto_lightyellow.jpg
    {
        map textures/robo_light/proto_lightyellow.jpg       
    }
}

textures/robo_light/ceil1_39
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/ceil1_39.jpg
    {
        map textures/robo_light/ceil1_39.jpg
    }
}

textures/robo_light/ceil1_39_blue
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/ceil1_39_blue.jpg
    {
        map textures/robo_light/ceil1_39_blue.jpg
    }
}

textures/robo_light/ceil1_39_red
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/ceil1_39_red.jpg
    {
        map textures/robo_light/ceil1_39_red.jpg
    }
}

textures/robo_light/ceil1_39_green
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/ceil1_39_green.jpg
    {
        map textures/robo_light/ceil1_39_green.jpg
    }
}

textures/robo_light/ceil1_39_yellow
{
    surfaceparm nolightmap
    qer_editorimage textures/robo_light/ceil1_39_yellow.jpg
    {
        map textures/robo_light/ceil1_39_yellow.jpg
    }
}