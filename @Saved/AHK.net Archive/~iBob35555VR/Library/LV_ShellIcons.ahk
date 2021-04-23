LV_ShellIcon(iconnumber)
{
ImageListID := IL_Create(iconnumber)  
LV_SetImageList(ImageListID)  
    IL_Add(ImageListID, "shell32.dll", iconnumber) 
}