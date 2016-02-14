textures/robo_trim/border12b
{
	q3map_surfacelight 1000	
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/robo_trim/border12b.tga
		rgbGen identity
		blendFunc GL_DST_COLOR GL_ZERO
	}
	{
		map textures/robo_trim/border12bfx.tga
		blendfunc GL_ONE GL_ONE
	}
}

textures/robo_trim/border12b_pj
{
	qer_editorimage textures/robo_trim/border12b.tga
	q3map_surfacelight 150	
	q3map_lightimage textures/robo_trim/border12bfx.tga	
	{
		map $lightmap
		rgbGen identity
	}
	{
		map textures/robo_trim/border12b.tga
		rgbGen identity
		blendFunc GL_DST_COLOR GL_ZERO
	}
	{
		map textures/robo_trim/border12bfx.tga
		blendfunc GL_ONE GL_ONE
	}
}

