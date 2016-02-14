textures/robo_wall/screen_border_1
{
	qer_editorimage textures/robo_wall/screen_border_1.tga
	surfaceparm alphashadow
	{
		map textures/robo_wall/screen_border_1.tga
		rgbGen identity
	}
}

textures/robo_wall/border7_konveer
{
	qer_editorimage textures/robo_trim/border7.tga
	{
		map textures/robo_trim/border7.tga
		tcMod scroll 0 2
	}
	{
		map $lightmap	
	}
}

textures/robo_wall/fan
{
	surfaceparm trans
	nopicmip
	{
		clampmap textures/robo_wall/fan.tga
		rgbGen identity
		tcMod rotate 30
		depthWrite
		alphaFunc GE128
	}
	{
		map $lightmap 
		blendfunc filter
		rgbGen identity
		tcGen lightmap 
		depthFunc equal
	}
}

textures/robo_wall/fan_grate
{
	surfaceparm alphashadow			
	nopicmip
	{
		map textures/robo_wall/fan_grate.tga
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

textures/robo_wall/fan3
{
	surfaceparm alphashadow
	nopicmip
	{
		map textures/robo_wall/fan3.tga
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

textures/robo_wall/fan3bladeb
{   	
	surfaceparm trans	
	nopicmip
	qer_editorimage textures/robo_wall/fan3bladeb.tga
	{
		map textures/robo_wall/fan3bladeb.tga
		blendfunc blend
		rgbGen identity
		tcMod rotate 30
	}	
	{
		map $lightmap	
		blendfunc blend	
		rgbGen identity
		tcGen lightmap 
	}
}

textures/robo_wall/fan3bladeb_noblend
{   	
	surfaceparm trans	
	nopicmip
	qer_editorimage textures/robo_wall/fan3bladeb.tga
	{
		map textures/robo_wall/fan3bladeb.tga
		rgbGen identity
		tcMod rotate 30
	}	
	{
		map $lightmap	
		rgbGen identity
		tcGen lightmap 
	}
}

textures/robo_wall/screen_hangar_1
{
	qer_editorimage textures/robo_wall/screen_border_1.tga
	surfaceparm alphashadow
	//{
	//	map textures/robo_wall/screen_border_1.tga
	//	rgbGen identity
	//}
	{		
		map textures/logo/RoboWallpaper.tga
		tcMod scale -1 1
	}   
	{		
		map textures/logo/RoboTroopersTitle.tga		
		tcMod scale -0.1 1.0
		tcMod scroll 0.01 0.0
		alphafunc GE128					
		rgbGen identity		
	}		
}