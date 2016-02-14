textures/robo_liquids/robo_lava
{
    qer_editorimage textures/robo_liquids/protolava.tga
    surfaceparm noimpact
    surfaceparm nolightmap
    {
        map textures/robo_liquids/protolava2.tga
        rgbGen identity
        tcMod scale 0.2 0.2
        tcMod scroll 0.001 0.002
        tcMod turb 0 0.1 0 0.01
        tcMod rotate 0.05
    }
    {
        map textures/robo_liquids/protolava.tga
        blendfunc gl_one gl_one_minus_src_color
        tcMod scroll -0.004 -0.003
        tcMod turb 0 0.1 0 0.01
    }
    {
        map textures/robo_env/robo_envmap_dark.tga
        blendfunc add
        rgbGen identity
        tcMod scroll 0.001 0.001
        tcMod turb 0 0.1 0 0.01
        tcMod rotate 0.5
        tcGen environment 
    }
}

textures/robo_liquids/water_pool_fog
{
    qer_editorimage textures/robo_liquids/pool3d_3e.tga
    surfaceparm nonsolid
    surfaceparm trans
    surfaceparm water
    cull disable
    deformVertexes wave 64 sin 0.25 0.25 0 0.5 
    qer_trans 0.5
    q3map_globaltexture
    {
        map textures/robo_liquids/pool3d_5e.tga
        blendfunc gl_dst_color gl_one
        rgbGen identity
        tcMod scale 0.5 0.5
        tcMod scroll 0.025 0.01
    }
    {
        map textures/robo_liquids/pool3d_3e.tga
        blendfunc gl_dst_color gl_one
        tcMod scale -0.5 -0.5
        tcMod scroll 0.025 0.025
    }
}

textures/robo_liquids/clear_ripple
{
    qer_editorimage textures/robo_liquids/proto_poolpass.tga
    surfaceparm nolightmap
    surfaceparm trans
    cull disable
    qer_trans 0.5
    tesssize 256

    {
        map textures/robo_liquids/proto_poolpass.tga   
        rgbGen identity    
        blendfunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaGen const 0.6     
        tcMod scale  0.25 0.25
        tcMod scroll 0.001 0.002
        tcMod turb 0 0.1 0 0.01
        tcMod rotate 0.05
    }
    {        
        map textures/robo_liquids/naturalpool.tga
        blendFunc GL_one GL_one
        tcMod scale 0.5 0.5
        tcMod scale 0.25 0.25
        tcMod scroll 0 0.004
    }
    {
        map textures/robo_liquids/pool3d_5c.tga
        blendFunc GL_dst_color GL_one
        rgbgen identity
        tcmod scale .25 .25
        tcmod transform 1.5 0 1.5 1 1 2
        tcmod scroll -.005 .0001
    }
    { 
        map textures/robo_liquids/pool3d_6c.tga
        blendFunc GL_dst_color GL_one
        rgbgen identity
        tcmod scale .25 .25
        tcmod transform 0 1.5 1 1.5 2 1
        tcmod scroll .0025 -.0001
    }
}

textures/robo_liquids/protolava
{
    
    q3map_globaltexture
    surfaceparm trans
    //surfaceparm nonsolid
    surfaceparm noimpact
    surfaceparm lava
    surfaceparm nolightmap
    //q3map_surfacelight 600
    cull disable
    
    tesssize 128
    cull disable
    deformVertexes wave 100 sin 3 2 .1 0.1  
    {
        map textures/robo_liquids/protolava2.tga
        tcmod scale .2 .2
        tcmod scroll .04 .03
        tcMod turb 0 .1 0 .01
        blendFunc GL_ONE GL_ZERO
        rgbGen identity
    }
    {
        map textures/robo_liquids/protolava.tga
        blendfunc blend
        tcMod turb 0 .2 0 .1
    }
}

textures/robo_liquids/clear_calm1
{
    qer_editorimage textures/robo_liquids/pool3d_3e.tga
    qer_trans .5
    q3map_globaltexture
    surfaceparm trans
    surfaceparm nonsolid
    surfaceparm water
    
    cull disable
    deformVertexes wave 64 sin .25 .25 0 .5 
    { 
        map textures/robo_liquids/pool3d_5e.tga
        blendFunc GL_dst_color GL_one
        rgbgen identity
        tcmod scale .5 .5
        tcmod scroll .025 .01
    }
    { 
        map textures/robo_liquids/pool3d_3e.tga
        blendFunc GL_dst_color GL_one
        tcmod scale -.5 -.5
        tcmod scroll .025 .025
    }
}

textures/robo_liquids/clear_ripple3
    {
        qer_editorimage textures/robo_liquids/pool3d_3c.tga
        qer_trans .5
        q3map_globaltexture
        surfaceparm trans
        surfaceparm nonsolid
        surfaceparm water
    
        cull disable
        deformVertexes wave 64 sin .5 .5 0 .5   
        
        { 
            map textures/robo_liquids/pool3d_5c.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 1.5 0 1.5 1 1 2
            tcmod scroll -.05 .001
        }
    
        { 
            map textures/robo_liquids/pool3d_6c.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 0 1.5 1 1.5 2 1
            tcmod scroll .025 -.001
        }

        { 
            map textures/robo_liquids/pool3d_3c.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .25 .5
            tcmod scroll .001 .025
        }
}

textures/robo_liquids/clear_ripple2
    {
        qer_editorimage textures/robo_liquids/pool3d_3b.tga
        qer_trans .5
        q3map_globaltexture
        surfaceparm trans
        surfaceparm nonsolid
        surfaceparm water

        cull disable
        deformVertexes wave 64 sin .5 .5 0 .5   

        { 
            map textures/robo_liquids/pool3d_5b.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 1.5 0 1.5 1 1 2
            tcmod scroll -.05 .001
        }
    
        { 
            map textures/robo_liquids/pool3d_6b.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 0 1.5 1 1.5 2 1
            tcmod scroll .025 -.001
        }

        { 
            map textures/robo_liquids/pool3d_3b.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .25 .5
            tcmod scroll .001 .025
        }
}

textures/robo_liquids/clear_ripple1
    {
        qer_editorimage textures/robo_liquids/pool3d_3.tga
        qer_trans .5
        q3map_globaltexture
        surfaceparm trans
        surfaceparm nonsolid
        surfaceparm water
        cull disable
        deformVertexes wave 64 sin .5 .5 0 .5           
        { 
            map textures/robo_liquids/pool3d_5.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 1.5 0 1.5 1 1 2
            tcmod scroll -.05 .001
        }
    
        { 
            map textures/robo_liquids/pool3d_6.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 0 1.5 1 1.5 2 1
            tcmod scroll .025 -.001
        }

        { 
            map textures/robo_liquids/pool3d_3.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .25 .5
            tcmod scroll .001 .025
        }   
}

textures/robo_liquids/clear_ripple1_q3dm1
    {
        qer_editorimage textures/robo_liquids/pool3d_3.tga
        qer_trans .5
        q3map_globaltexture
        surfaceparm trans
        surfaceparm nonsolid
        surfaceparm water

        cull disable
        deformVertexes wave 64 sin .5 .5 0 .5   
    
        
        { 
            map textures/robo_liquids/pool3d_5.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 1.5 0 1.5 1 1 2
            tcmod scroll -.05 .001
        }
    
        { 
            map textures/robo_liquids/pool3d_6.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .5 .5
            tcmod transform 0 1.5 1 1.5 2 1
            tcmod scroll .025 -.001
        }

        { 
            map textures/robo_liquids/pool3d_3.tga
            blendFunc GL_dst_color GL_one
            rgbgen identity
            tcmod scale .25 .5
            tcmod scroll .001 .025
        }   
}

textures/robo_liquids/lavahell
{
    q3map_globaltexture
    surfaceparm noimpact
    surfaceparm trans
    surfaceparm lava
    surfaceparm nolightmap
    //q3map_surfacelight 600
    cull disable
    
    tesssize 128
    cull disable
    deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }


}

textures/robo_liquids/lavahell_xdm1
{
    qer_editorimage textures/robo_liquids/lavahell.tga
    q3map_globaltexture
    surfaceparm nodlight
    surfaceparm noimpact
    surfaceparm nolightmap
    q3map_surfacelight 600
    cull disable
    
    tesssize 128
    cull disable
    deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
    
}

textures/robo_liquids/lavahell_1000
{
    qer_editorimage textures/robo_liquids/lavahell.tga
    q3map_globaltexture
    surfaceparm trans
    surfaceparm noimpact
    surfaceparm lava
    surfaceparm nolightmap
    q3map_surfacelight 1000
    cull disable
    
    tesssize 128
    cull disable
    deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
}

textures/robo_liquids/lavahell_2000
    {
        qer_editorimage textures/robo_liquids/lavahell.tga
        q3map_globaltexture
        surfaceparm trans
        surfaceparm noimpact
        surfaceparm lava
        surfaceparm nolightmap
        q3map_surfacelight 2000
        cull disable
    
        tesssize 128
        cull disable
        deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
}
textures/robo_liquids/lavahell_750
    {

        qer_editorimage textures/robo_liquids/lavahell.tga
        q3map_globaltexture
        q3map_lightsubdivide 32
        surfaceparm trans
        surfaceparm noimpact
        surfaceparm lava
        surfaceparm nolightmap
        q3map_surfacelight 500
        cull disable
    
    tesssize 128
    cull disable
    deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
}

textures/robo_liquids/flatlavahell_1500
    {
        qer_editorimage textures/robo_liquids/lavahell.tga
        q3map_globaltexture
        q3map_lightsubdivide 32
        surfaceparm noimpact
        surfaceparm lava
        surfaceparm nolightmap
        q3map_surfacelight 1500
        cull disable
    
    deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
       
}


textures/robo_liquids/lavahell_2500
    {

        qer_editorimage textures/robo_liquids/lavahell.tga
        q3map_globaltexture
        surfaceparm trans
        surfaceparm noimpact
        surfaceparm lava
        surfaceparm nolightmap
        q3map_surfacelight 2500
        cull disable
        
        tesssize 128
        cull disable
        deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
}

textures/robo_liquids/lavahelldark
    {
        qer_editorimage textures/robo_liquids/lavahell.tga
        q3map_globaltexture
        surfaceparm trans
        surfaceparm noimpact
        surfaceparm lava
        surfaceparm nolightmap
        //q3map_surfacelight 150
        cull disable
    
        tesssize 128
        cull disable
        deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
    

}

textures/robo_liquids/lavahellflat_400
{
    
    qer_editorimage textures/robo_liquids/lavahell.tga
    q3map_globaltexture
    surfaceparm trans
    surfaceparm noimpact
    surfaceparm lava
    surfaceparm nolightmap
    q3map_surfacelight 400
    cull disable
    
    tesssize 128
    cull disable
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
}

textures/robo_liquids/slime1
    {
        qer_editorimage textures/robo_liquids/slime7.tga
        q3map_lightimage textures/robo_liquids/slime7.tga
        q3map_globaltexture
        qer_trans .5

        surfaceparm noimpact
        surfaceparm slime
        surfaceparm nolightmap
        surfaceparm trans       

        q3map_surfacelight 100
        tessSize 32
        cull disable

        deformVertexes wave 100 sin 0 1 .5 .5

        {
            map textures/robo_liquids/slime7c.tga
            tcMod turb .3 .2 1 .05
            tcMod scroll .01 .01
        }
    
        {
            map textures/robo_liquids/slime7.tga
            blendfunc GL_ONE GL_ONE
            tcMod turb .2 .1 1 .05
            tcMod scale .5 .5
            tcMod scroll .01 .01
        }

        {
            map textures/robo_liquids/bubbles.tga
            blendfunc GL_ZERO GL_SRC_COLOR
            tcMod turb .2 .1 .1 .2
            tcMod scale .05 .05
            tcMod scroll .001 .001
        }       
}

textures/robo_liquids/slime1_2000
    {
        qer_editorimage textures/robo_liquids/slime7.tga
        q3map_lightimage textures/robo_liquids/slime7.tga
        q3map_globaltexture
        qer_trans .5

        surfaceparm noimpact
        surfaceparm slime
        surfaceparm nolightmap
        surfaceparm trans       

        q3map_surfacelight 2000
        tessSize 32
        cull disable

        deformVertexes wave 100 sin 0 1 .5 .5

        {
            map textures/robo_liquids/slime7c.tga
            tcMod turb .3 .2 1 .05
            tcMod scroll .01 .01
        }
    
        {
            map textures/robo_liquids/slime7.tga
            blendfunc GL_ONE GL_ONE
            tcMod turb .2 .1 1 .05
            tcMod scale .5 .5
            tcMod scroll .01 .01
        }

        {
            map textures/robo_liquids/bubbles.tga
            blendfunc GL_ZERO GL_SRC_COLOR
            tcMod turb .2 .1 .1 .2
            tcMod scale .05 .05
            tcMod scroll .001 .001
        }       


}

textures/robo_liquids/lavahell_2500_subd
{
    qer_editorimage textures/robo_liquids/lavahell.tga
    q3map_lightsubdivide 32
    q3map_globaltexture
    surfaceparm trans
    surfaceparm noimpact
    surfaceparm lava
    surfaceparm nolightmap
    q3map_surfacelight 2500
    cull disable
    
    tesssize 128
    cull disable
    deformVertexes wave 100 sin 3 2 .1 0.1
    
    {
        map textures/robo_liquids/lavahell.tga
        tcMod turb 0 .2 0 .1
    }
}
