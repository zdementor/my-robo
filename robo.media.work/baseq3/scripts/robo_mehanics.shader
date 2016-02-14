textures/robo_mehanics/weel_train
{
	qer_editorimage textures/robo_mehanics/weel_train.tga
	surfaceparm alphashadow
	{
		map textures/robo_mehanics/weel_train.tga
		alphaFunc GE128
	}
	{
		map $lightmap 		
	}
}

textures/robo_mehanics/weel_train2
{
	qer_editorimage textures/robo_mehanics/weel_train2.tga
	surfaceparm alphashadow
	{
		map textures/robo_mehanics/weel_train2.tga
		alphaFunc GE128
	}
	{
		map $lightmap 
	}
}
textures/robo_mehanics/spool_metal
{
	qer_editorimage textures/robo_mehanics/spool_metal.tga
	surfaceparm alphashadow
	cull disable
	{
		map $lightmap
		rgbGen identity
		alphaFunc GE128	
	}		
	{
		map textures/robo_mehanics/spool_metal.tga
		rgbGen identity
		alphaFunc GE128	
		blendFunc GL_DST_COLOR GL_ZERO		
	}
}

