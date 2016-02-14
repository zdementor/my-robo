textures/robo_sfx/flame1_anim
{
	qer_editorimage textures/robo_sfx/flame1.jpg
	cull disable
	{
		animMap 8 textures/robo_sfx/flame1.jpg textures/robo_sfx/flame2.jpg textures/robo_sfx/flame3.jpg textures/robo_sfx/flame4.jpg textures/robo_sfx/flame5.jpg textures/robo_sfx/flame6.jpg textures/robo_sfx/flame7.jpg textures/robo_sfx/flame8.jpg
		blendFunc GL_ONE GL_ONE
		rgbGen identity
		
	}            
	{
		animMap 10 textures/robo_sfx/flame1.jpg textures/robo_sfx/flame2.jpg textures/robo_sfx/flame3.jpg textures/robo_sfx/flame4.jpg textures/robo_sfx/flame5.jpg textures/robo_sfx/flame6.jpg textures/robo_sfx/flame7.jpg textures/robo_sfx/flame8.jpg
		blendFunc GL_ONE GL_ONE
		rgbGen identity
	}  
}

textures/robo_sfx/flame2_anim
{
	qer_editorimage textures/robo_sfx/flame1.jpg
	cull disable
	{
		animMap 10 textures/robo_sfx/flame1.jpg textures/robo_sfx/flame2.jpg textures/robo_sfx/flame3.jpg textures/robo_sfx/flame4.jpg textures/robo_sfx/flame5.jpg textures/robo_sfx/flame6.jpg textures/robo_sfx/flame7.jpg textures/robo_sfx/flame8.jpg
		blendFunc GL_ONE GL_ONE
		rgbGen identity
		
	}            
	{
		animMap 14 textures/robo_sfx/flame1.jpg textures/robo_sfx/flame2.jpg textures/robo_sfx/flame3.jpg textures/robo_sfx/flame4.jpg textures/robo_sfx/flame5.jpg textures/robo_sfx/flame6.jpg textures/robo_sfx/flame7.jpg textures/robo_sfx/flame8.jpg
		blendFunc GL_ONE GL_ONE
		rgbGen identity
	}  
}

textures/robo_sfx/robo_title
{
	qer_editorimage textures/robo_sfx/flame1.jpg
	cull disable 	
	nomipmaps	
	{			
		clampmap textures/logo/RoboWallpaper.tga						
	}
	{
		animMap 7 textures/logo/logoflame1.jpg textures/logo/logoflame2.jpg textures/logo/logoflame3.jpg textures/logo/logoflame4.jpg textures/logo/logoflame5.jpg textures/logo/logoflame6.jpg textures/logo/logoflame7.jpg textures/logo/logoflame8.jpg		
		blendFunc filter
		rgbGen identity				
	}
	{			
		clampmap textures/logo/RoboWallpaper.tga						
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA				
	}
	{		
		map textures/logo/RoboTroopersTitle.tga		
		tcMod scale 0.1 1.0
		tcMod scroll 0.01 0.0
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA		
		alphafunc GE128
		rgbGen identity		
	} 	 
	{
		animMap 7 textures/logo/logoflame1.jpg textures/logo/logoflame2.jpg textures/logo/logoflame3.jpg textures/logo/logoflame4.jpg textures/logo/logoflame5.jpg textures/logo/logoflame6.jpg textures/logo/logoflame7.jpg textures/logo/logoflame8.jpg		
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen identity				
	}	
}
