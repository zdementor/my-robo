textures/robo_floor/robo_pjgrate1_env
{
	qer_editorimage textures/robo_floor/robo_pjgrate1.tga
	cull disable
	{
		map textures/robo_floor/robo_pjgrate1.tga
		rgbGen identity
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
	{
		map textures/robo_env/robo_envmap_dark.jpg		
		blendFunc GL_ONE GL_ONE		
        rgbGen identity
        tcGen environment		
	}	
}
textures/robo_floor/robo_pjgrate1
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	cull disable
	{
		map textures/robo_floor/robo_pjgrate1.tga
		rgbGen identity
		tcMod scale 2 2
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 		
	}
}

textures/robo_floor/robo_pjgrate2
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	cull disable
	{
		map textures/robo_floor/robo_pjgrate2.tga
		rgbGen identity
		tcMod scale 2 2		
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 		
	}
}

textures/robo_floor/proto_grate3
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	cull disable
	{
		map textures/robo_floor/proto_grate3.tga
		rgbGen identity
		tcMod scale 2 2
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
}
textures/robo_floor/proto_grate
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	cull disable
	{
		map textures/robo_floor/proto_grate.tga
		rgbGen identity
		tcMod scale 0.5 0.5	
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
	{
		map textures/robo_env/robo_envmap_dark.jpg		
		blendFunc GL_ONE GL_ONE		
        rgbGen identity
        tcGen environment		
	}	
}

textures/robo_floor/tilefloor7_ow
{
	q3map_lightimage textures/robo_floor/tilefloor7_owfx.tga
	q3map_surfacelight 100	
    {
		map $lightmap
		rgbGen identity
	}
    {
		map textures/robo_floor/tilefloor7_ow.tga
		blendfunc gl_dst_color gl_zero
        rgbGen identity
	}	
    {
		map textures/robo_floor/tilefloor7_owfx.tga
		blendfunc GL_ONE GL_ONE
        rgbgen wave triangle 0.25 0.1 0 7
	}
    {
		map textures/robo_floor/tilefloor7_owfx.tga
		blendfunc GL_ONE GL_ONE
        rgbgen wave triangle 0.25 0.1 1 3
	}
    	
}

textures/robo_floor/proto_grate4
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	cull disable
	{
		map textures/robo_floor/proto_grate4.tga
		rgbGen identity
		tcMod scale 1 1
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 		
	}
}

textures/robo_floor/proto_grate5
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	cull disable
	{
		map textures/robo_floor/proto_grate5.tga
		rgbGen identity
		tcMod scale 1 1
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 		
	}
}