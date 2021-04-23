/*
A Source bitmap and a mask bitmap can be supplied, and the returned bitmap from the function will be a new bitmap from the source, using the mask's transparencies. Simple example above only uses 1 circle as a mask 
*/

pToken := Gdip_Startup()
pBitmap := Gdip_CreateBitmapFromFile("MJ.jpg")
Gdip_GetDimensions(pBitmap, w, h)

pBitmapMask := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmapMask)
Gdip_SetSmoothingMode(G2, 4)

pBrush := Gdip_BrushCreateSolid(0xff00ff00)
Gdip_FillEllipse(G2, pBrush, 0, 0, w, h)
Gdip_DeleteBrush(pBrush)

pBitmapNew := Gdip_AlphaMask(pBitmap, pBitmapMask, 0, 0)
Gdip_SaveBitmapToFile(pBitmapNew, "Circle.png")

Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmapMask), Gdip_DisposeImage(pBitmapNew)
Gdip_Shutdown(pToken)
return

;#######################################################################

/* C source code for machine code:
int Gdip_AlphaMask(unsigned int * Bitmap, unsigned int * BitmapMask, unsigned int * BitmapNew, int w1, int h1, int w2, int h2, int Stride1, int Stride2, int sx, int sy)
{
	int o1 = Stride1/4, o2 = Stride2/4;
	for (int y = 0; y < h2; ++y)
	{
		for (int x = 0; x < w2; ++x)
		{
			BitmapNew[(x+sx)+(y+sy)*o1] = (BitmapMask[x+(y*o2)] & 0xff000000) | (Bitmap[(x+sx)+(y+sy)*o1] & 0x00ffffff);
		}
	}
	return 0;
}
*/

Gdip_AlphaMask(pBitmap, pBitmapMask, x, y)
{
	static _AlphaMask
	if !_AlphaMask
	{
		MCode_AlphaMask := "8B4424209983E2038D0C028B4424249983E20303C28B54241CC1F902C1F80285D27E7303C003C08944241C8D048D000000000FA"
		. "F4C242C034C2428538B5C240C55568B742424894424308B442418578D3C888954243085F67E2A8B5424142B54241C8BCF8BC38B2C0A332883C00481E"
		. "5FFFFFF003368FC83C1044E8969FC75E68B742428037C2434035C242CFF4C243075C45F5E5D5B33C0C3"

		VarSetCapacity(_AlphaMask, StrLen(MCode_AlphaMask)//2)
		Loop % StrLen(MCode_AlphaMask)//2	  ;%
			NumPut("0x" SubStr(MCode_AlphaMask, (2*A_Index)-1, 2), _AlphaMask, A_Index-1, "char")
	}
	Gdip_GetDimensions(pBitmap, w1, h1), Gdip_GetDimensions(pBitmapMask, w2, h2)
	pBitmapNew := Gdip_CreateBitmap(w1, h1)
	if !pBitmapNew
		return -1

	E1 := Gdip_LockBits(pBitmap, 0, 0, w1, h1, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapMask, 0, 0, w2, h2, Stride2, Scan02, BitmapData2)
	E3 := Gdip_LockBits(pBitmapNew, 0, 0, w1, h1, Stride3, Scan03, BitmapData3)
	if (E1 || E2 || E3)
		return -2

	E := DllCall(&_AlphaMask, "ptr", Scan01, "ptr", Scan02, "ptr", Scan03, "int", w1, "int", h1, "int", w2, "int", h2, "int", Stride1, "int", Stride2, "int", x, "int", y)
	
	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapMask, BitmapData2), Gdip_UnlockBits(pBitmapNew, BitmapData3)
	return (E = "") ? -3 : pBitmapNew
}