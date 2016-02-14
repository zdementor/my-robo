textures/robo_support/x_support
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	surfaceparm nomarks
	surfaceparm trans
	cull disable
	nopicmip
	{
		map textures/robo_support/x_support.tga
		rgbGen identity
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
}
textures/robo_support/x_support2
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	surfaceparm trans
	cull disable
	nopicmip	
	{
		map textures/robo_support/x_support2.tga
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

textures/robo_support/x_support3
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	surfaceparm nomarks
	surfaceparm trans
	cull disable
	nopicmip
	{
		map textures/robo_support/x_support3.tga
		rgbGen identity
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
}

textures/robo_support/z_support
{
	surfaceparm alphashadow
	surfaceparm metalsteps
	surfaceparm nomarks
	surfaceparm trans
	cull disable
	nopicmip
	{
		map textures/robo_support/z_support.tga
		rgbGen identity
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
}

textures/robo_support/border_metal
{
	qer_editorimage textures/robo_support/border_metal.tga
	surfaceparm alphashadow
	cull disable
	{
		map textures/robo_support/border_metal.tga
		rgbGen identity
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
}

textures/robo_support/wires01
{
	surfaceparm alphashadow
	surfaceparm trans
	cull disable
	{
		map textures/robo_support/wires01.tga
		alphaFunc GE128
		rgbGen identity
	}
	{
		map $lightmap 
		blendfunc filter
		tcGen lightmap 
		rgbGen identity
	}
}

textures/robo_support/wires02
{
	surfaceparm alphashadow
	surfaceparm trans
	cull disable
	{
		map textures/robo_support/wires02.tga
		alphaFunc GE128
		rgbGen identity
	}
	{
		map $lightmap 
		blendfunc filter
		tcGen lightmap 
		rgbGen identity
	}
}

textures/robo_support/proto_fence
{
	surfaceparm trans
	cull disable
	{
		map textures/robo_support/proto_fence.tga
		tcMod scale 1.5 1.5
		alphaFunc GE128
		rgbGen identity
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
	}
}

textures/robo_support/invisible
{
	qer_editorimage textures/robo_env/envmapligh.tga
	surfaceparm trans
	{
		map textures/robo_env/envmapligh.tga
		blendfunc gl_one gl_one
		tcMod scale 0.5 0.5
		tcGen environment 
	}
	{
		map $lightmap 
		blendfunc filter
		tcGen lightmap 
	}
}

textures/robo_support/invisible2
{
	qer_editorimage textures/robo_env/robo_envmap_dark.tga
	surfaceparm trans
	{
		map textures/robo_env/robo_envmap_dark.tga
		blendfunc gl_one gl_one
		tcGen environment 
	}
	{
		map $lightmap 
		blendfunc filter
		tcGen lightmap 
	}
}

