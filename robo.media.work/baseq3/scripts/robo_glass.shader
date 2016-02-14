textures/robo_glass/robo_glass_envmapligh
{
    qer_editorimage textures/robo_metal/robo_metal_1_dark.tga
    cull disable
    surfaceparm nolightmap  
    surfaceparm trans
    qer_trans   0.5
    {
        map textures/robo_metal/robo_metal_1_dark.tga
        blendfunc add
        rgbGen identity
    }
    {
        map textures/robo_env/envmapligh.tga
        blendfunc add
        rgbGen identity
        tcGen environment 
    }
}

textures/robo_glass/robo_glass_envmap
{
    qer_editorimage textures/robo_metal/robo_metal_1_dark.tga
    cull disable
    surfaceparm nolightmap  
    surfaceparm trans
    qer_trans   0.5
    {
        map textures/robo_metal/robo_metal_1_dark.tga
        blendfunc add
        rgbGen identity
    }
    {
        map textures/robo_env/robo_envmap.tga
        blendfunc add
        rgbGen identity
        tcGen environment 
    }
}

textures/robo_glass/robo_glass_surf
{
    qer_editorimage textures/robo_env/robo_envmap_dark.jpg
    cull disable
    surfaceparm nolightmap
    surfaceparm trans
    qer_trans   0.5
    {
        map textures/robo_env/robo_envmap_dark.jpg
        //blendfunc add
        blendfunc gl_one gl_one
        //rgbGen identity
        tcGen environment 
    }
}

textures/robo_glass/glass3
{
    qer_editorimage textures/robo_wall/glass3.tga
    cull disable
    surfaceparm nolightmap
    surfaceparm trans
    qer_trans   0.5
    {
        map textures/robo_wall/chrome_env2.tga
        blendfunc add
        tcMod scale 0.25 0.25
        tcGen environment 
        rgbGen identity
    }
    {
        map textures/robo_wall/glass3.tga
        blendfunc add
        rgbGen identity
    }
}