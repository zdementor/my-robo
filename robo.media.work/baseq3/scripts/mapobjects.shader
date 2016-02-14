models/mapobjects/car/car
{
	{
        map models/mapobjects/car/car.tga
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