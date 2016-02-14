textures/robo_metal/robo_metal_1_dark_envmap
{
    qer_editorimage textures/robo_metal/robo_metal_1_dark.tga
    {
        map textures/robo_metal/robo_metal_1_dark.tga
        rgbGen identity
    }
    {
        map textures/robo_env/robo_envmap.tga
        rgbGen identity
        tcGen environment 
    }
}

textures/robo_metal/metalblack03
{   
    qer_editorimage textures/robo_wall/metalblack03.jpg    
    {
        map $lightmap            
        rgbGen identity
        tcGen lightmap 
    }
    {
        map textures/robo_wall/metalblack03.jpg
        rgbGen identity
    }    
}

textures/robo_metal/metalblack03_env
{   
    qer_editorimage textures/robo_wall/metalblack03.jpg    
    {
        map $lightmap            
        rgbGen identity
        tcGen lightmap 
    }
    {
        map textures/robo_wall/metalblack03.jpg
        rgbGen identity
    }    
    {
        map textures/robo_env/robo_envmap_dark.tga
        blendfunc add
        rgbGen identity
        tcGen environment 
    }
}

textures/robo_metal/bluemetal1b
{
    qer_editorimage textures/robo_wall/bluemetal1b_shiny.tga
    {
        map $lightmap            
        rgbGen identity
        tcGen lightmap 
    } 
    {
        map textures/robo_wall/chrome_env2.jpg          
        rgbGen identity
        tcGen environment
        tcmod scale .25 .25
    }          
    {
        map textures/robo_wall/bluemetal1b_shiny.tga
        blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA   
        rgbGen identity
    }            
}

textures/robo_metal/bluemetal1b_dark
{
    qer_editorimage textures/robo_wall/bluemetal1b_shiny.tga
    {
        map textures/robo_wall/chrome_env2.tga
        rgbGen identity
        tcMod scale 0.25 0.25
        tcGen environment 
    }
    {
        map textures/robo_wall/bluemetal1b_shiny.tga
        //blendfunc gl_src_color gl_src_color
        rgbGen identity
    }
}

textures/robo_metal/bluemetal1b_env
{
    qer_editorimage textures/robo_wall/bluemetal1b_shiny.tga
    {
        map textures/robo_wall/chrome_env2.tga
        rgbGen identity
        tcGen environment 
    }
    {
        map textures/robo_wall/bluemetal1b_shiny.tga
        blendfunc add
        rgbGen identity
    }
}

textures/robo_metal/bluemetal2_env
{
    qer_editorimage textures/robo_wall/bluemetal2.tga
    {
        map $lightmap            
        rgbGen identity
        tcGen lightmap 
    } 
    {
        map textures/robo_wall/chrome_env2.jpg          
        rgbGen identity
        tcGen environment
        tcmod scale .25 .25
    }          
    {
        map textures/robo_wall/bluemetal2.tga
        blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA   
        rgbGen identity
    }            
}

textures/robo_metal/bluemetal3b_env
{
    qer_editorimage textures/robo_wall/bluemetal3b.tga
    {
        map $lightmap            
        rgbGen identity
        tcGen lightmap 
    } 
    {
        map textures/robo_wall/chrome_env2.jpg          
        rgbGen identity
        tcGen environment
        tcmod scale .25 .25
    }          
    {
        map textures/robo_wall/bluemetal3b.tga
        blendFunc GL_ONE_MINUS_SRC_ALPHA GL_SRC_ALPHA   
        rgbGen identity
    }            
}