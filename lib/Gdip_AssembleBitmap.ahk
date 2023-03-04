Gdip_AssembleBitmap(assets, sizes, options="", debug=False) {
/*  Quite messy function, originally intended to only be used for GUI_Trades
    May requite a proper rewrite someday

    Requires the following parameter:
        assets: Associative array that can contain the following:
            Background - The image that will be used to fill the background of the bitmap
            Left/Right/Top/Bottom/Center - The image that will be used in the corresponding positions
            Not all keys are neccessary. If the key is included, its value must lead to a valid image file

        sizes: Associative array that must contain the following: Width, Height
            Width/height of the final bitmap

        options: Associative array that can contain the following:
            CenterRatio - Ratio at which the Center asset will fill the final bitmap
                As example, a default ratio of 1 will make the Center asset fill the entire bitmap while 0.5 will make it fill only half of it
            Fill - Must be used in an associative array corresponding to Left/Right/Top/Bottom/Center (eg: options.Left.Fill := True)
                When set to True, will repeat the asset to "fill" the bitmap from left to right
            FillVertically - Same as Fill, but will fill from up to down instead

            NoWidthScale/NoHeightScale - Must be used in an associative array corresponding to Left/Right/Top/Bottom/Center (eg: options.Left.NoWidthScale := True)
                Unsure exactly

        debug: Will show the resulting bitmap in a GUI when set to True
*/
    width := sizes.Width, height := sizes.Height
    centerRatio := options.CenterRatio?options.CenterRatio:1

    ; Declaring sizing + positionning
    assets_infos := {}
    for asset, imagePath in assets {
        if !imagePath
            Continue

        assets_infos[asset] := {}
        assets_infos[asset].ImagePath := imagePath
        assets_infos[asset].ImageSizes := GetImageSize(imagePath)

        ; Sizing
        scaleMultiplerFormula := assets_infos[asset].ImageSizes.W > assets_infos[asset].ImageSizes.H ? width / assets_infos[asset].ImageSizes.W : height / assets_infos[asset].ImageSizes.H
        assets_infos[asset].Scale_Multiplier := asset="Center" ? (width > height ? height / assets_infos[asset].ImageSizes.H : width / assets_infos[asset].ImageSizes.W)
            : scaleMultiplerFormula
        if (options[asset].Fill) {
            if (options[asset].FillVertically)
                assets_infos[asset].Width := width, assets_infos[asset].Height := assets_infos[asset].ImageSizes.H, assets_infos[asset].FillRepeat := height / assets_infos[asset].Height
            else 
                assets_infos[asset].Width := assets_infos[asset].ImageSizes.W, assets_infos[asset].Height := height, assets_infos[asset].FillRepeat := width / assets_infos[asset].Width
        }
        else {
            if (asset="Center")
                assets_infos[asset].Width := Ceil(assets_infos[asset].ImageSizes.W * assets_infos[asset].Scale_Multiplier * centerRatio), assets_infos[asset].Height := Ceil(assets_infos[asset].ImageSizes.H * assets_infos[asset].Scale_Multiplier * centerRatio)
            else {
                assets_infos[asset].Width := Ceil(assets_infos[asset].ImageSizes.W * assets_infos[asset].Scale_Multiplier), assets_infos[asset].Height := Ceil(assets_infos[asset].ImageSizes.H * assets_infos[asset].Scale_Multiplier)
            }
        }

        ; Reset sizing based on options
        if (options[asset].NoWidthScale)
            assets_infos[asset].Width := assets_infos[asset].ImageSizes.W
        if (options[asset].NoHeightScale)
            assets_infos[asset].Height := assets_infos[asset].ImageSizes.H

        ; Positionning
        if IsIn(asset, "Left,Background,Top")
            assets_infos[asset].X_POS := 0, assets_infos[asset].Y_POS := 0
        if (asset = "Right")
            assets_infos[asset].X_POS := width-assets_infos[asset].Width, assets_infos[asset].Y_POS := 0
        if (asset = "Center")
            assets_infos[asset].X_POS := (width/2)-(assets_infos[asset].Width/2), assets_infos[asset].Y_POS := (height/2)-(assets_infos[asset].Height/2)
        if (asset = "Bottom")
            assets_infos[asset].X_POS := 0, assets_infos[asset].Y_POS := height-assets_infos[asset].Height
    }
    ; Changing background size
    if (assets.Background && options.Background.Fill && options.Background.FillCentered) {
        if (assets.Left) {
            assets_infos.Background.X_POS := assets_infos.Left.X_POS + assets_infos.Left.Width
            if (options.Background.FillVertically)
                assets_infos.Background.Width := assets_infos.Background.Width - assets_infos.Left.Width
        }
        if (assets.Right) {
            if (options.Background.FillVertically)
                assets_infos.Background.Width := assets_infos.Background.Width - assets_infos.Right.Width				
        }
        if (assets.Top)
            assets_infos.Background.Y_POS := assets_infos.Top.Y_POS + assets_infos.Top.Height
        if (assets.Bottom && !options.Background.FillVertically)
            assets_infos.Background.Height := assets_infos.Background.Height - assets_infos.Bottom.Height
        ; Changing FillRepeat value
        if (options.Background.FillVertically)
            assets_infos.Background.FillRepeat := height / assets_infos.Background.Height
        else
            assets_infos.Background.FillRepeat := width / assets_infos.Background.Width
    }

    ; Creating new final bitmap + graphics
    pBitmapFinal := Gdip_CreateBitmap(width, height)
    G := Gdip_GraphicsFromImage(pBitmapFinal)
    Gdip_SetSmoothingMode(G, 4)
    Gdip_SetInterpolationMode(G, 7)
    pBrush := Gdip_BrushCreateSolid(0xff00ff00)
    Gdip_FillRectangle(G, pBrush, 0, 0, width, height)
    ; Creating bitmap for every element
    bitMaps := {}
    for asset, imagePath in assets {
        if (!imagePath)
            Continue

        bitMaps[asset] := Gdip_CreateBitmapFromFile(imagePath)
        bitMaps[asset] := Gdip_ResizeBitmap(bitMaps[asset], "w" assets_infos[asset].Width " h" assets_infos[asset].Height, smooth:=False)
    }
    ; Drawing bitmap on final bitmap
    Loop 2 {
        loopIndex := A_Index
        for bitMapName, bitMapValue in bitMaps {
            if (loopIndex=1 && bitMapName != "Background") ; Making sure to fill background first
                Continue
            if (loopIndex=2 && bitMapName = "Background") ; And then the rest
                Continue

            if (options[bitMapName].Fill) {
                Loop % assets_infos[bitMapName].FillRepeat {
                    if (options[bitMapName].FillVertically) {
                        imgY := A_Index=1?assets_infos[bitMapName].Y_POS: assets_infos[bitMapName].Y_POS+(assets_infos[bitMapName].Height*(A_Index-1))
                        Gdip_DrawImage(G, bitMaps[bitMapName], assets_infos[bitMapName].X_POS, imgY, assets_infos[bitMapName].Width, assets_infos[bitMapName].Height, 0, 0, assets_infos[bitMapName].Width, assets_infos[bitMapName].Height)
                    }
                    else {
                        imgX := A_Index=1?assets_infos[bitMapName].X_POS: assets_infos[bitMapName].X_POS+(assets_infos[bitMapName].Width*(A_Index-1))
                        Gdip_DrawImage(G, bitMaps[bitMapName], imgX, assets_infos[bitMapName].Y_POS, assets_infos[bitMapName].Width, assets_infos[bitMapName].Height, 0, 0, assets_infos[bitMapName].Width, assets_infos[bitMapName].Height)
                    }
                }
            }
            else {
                Gdip_DrawImage(G, bitMaps[bitMapName], assets_infos[bitMapName].X_POS, assets_infos[bitMapName].Y_POS, assets_infos[bitMapName].Width, assets_infos[bitMapName].Height, 0, 0, assets_infos[bitMapName].Width, assets_infos[bitMapName].Height)
            }
        }
    }

    ; Getting hBitmap
    hBitmapFinal := Gdip_CreateHBITMAPFromBitmap(pBitmapFinal)

    ; Cleanup
    for bitMapName, bitMapValue in bitMaps
        Gdip_DisposeImage(bitMaps[bitMapName])
    Gdip_DisposeImage(pBitmapFinal)
    Gdip_DeleteGraphics(G)

    ; Debug
    if (Debug=True) {
        Gui, NoName:New, hwndhGui
        Gui, NoName:Add, Picture,0xE hwndhMyPic
        SetImage(hMyPic, hBitmapFinal)
        Gui, NoName:Show, AutoSize
        WinWait, ahk_id %hGui%
        WinWaitClose ahk_id %hGui%
    }

    return hBitmapFinal
}