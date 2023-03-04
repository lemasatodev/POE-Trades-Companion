/*
#Include H:\UserLibrary\Documents\GitHub\POE-Trades-Companion\lib\Class_Gui.ahk
#Include H:\UserLibrary\Documents\GitHub\POE-Trades-Companion\lib\EasyFuncs.ahk
#SingleInstance, Force
#Persistent
PROGRAM := {}
PROGRAM.OS := {}
PROGRAM.OS.RESOLUTION_DPI := 1

GUI_ItemGrid.Create(12, 6, "Ghetto Map", "Shop: 1", -1920, 0 , 1080, 0, 0, "Map", 7)
*/


class GUI_ItemGrid {
/*  Function usage example:
        GUI_ItemGrid.Show(5, 2, "Shop", 0, 0, 1080)
        ^ Will show the location of an item at X5 Y2, tab name "Shop", in borderless fullscreen, with a H res of 1080 
        Make sure to always retrieve the Client height and not the window height.

    With as reference resolution 1920x1080 (only the height matters though):

    Grid starts at 17x 162y
    tab_xRoot           17 / 1080 = 0.01666666666666666666666666666667
    tab_yRoot           162 / 1080 = 0.15

    A square is 54x54
    tab_squareWRoot     54 / 1080 = 0.05
    
    To know where the grid starts for a specific resolution, we do (tab_xRoot * resH)
    Example. On a resolution of 800x600:
        The grid will start at px 10: (tab_xRoot * 600) = ~10
        A single square will be 30px: (tab_squareWRoot * 600) = 30
        The grid will end at px 642: 10 + (30 * 12) = 10 + 360 = 370


    = = = = = = = = = = = = = = = = = = = = = = = = 
    For quad tabs:
    tab_xRoot and tab_yRoot are the same
    tab_squareWRoot and tab_squareHRoot are divided by 2 

    = = = = = = = = = = = = = = = = = = = = = = = = 
    For map tabs:
    Grid starts at 45x 488y
    map_xRoot           45 / 1080 = 0.0416666666666667
    map_yRoot           488 / 1080 = 0.4518518518518519

    A square is 49x49
    map_squareWRoot     49 / 1080 = 0.0444444444444444

    ( UNUSED INFOS
        First row starts at: 44x198 (1 > 9)
        Second row starts at: 83x266 (10 > 16 + U)
        Square is 45x45
        Space of 21w between each square
        
        Maps row starts at 84x331
        Second row starts at 84x402
        Map is 57x58
        Space of 16w between each map tier
    )
*/
    ; position of tab grid
    static tab_xRoot := 16/1080
	static tab_yRoot := 127/1080
    ; size of normal tab squares
    static tab_squareWRoot := 53/1080
    static tab_squareHRoot := 53/1080
    static tab_casesCountX := 12
    static tab_casesCountY := 12

    ; size of quad tab squares
    static quad_squareWRoot := 53/1080/2
    static quad_squareHRoot := 53/1080/2
    static quad_casesCountX := 24
    static quad_casesCountY := 24

    ; height of tab names buttons 
    static stashTabHeightRoot := 27/1080

    ; map tab grid position and size of squares
    static map_xRoot := 45/1080
    static map_yRoot := 466/1080
    static map_squareWRoot := 48/1080
    static map_squareHRoot := 48/1080
    static map_casesCountX := 12
    static map_casesCountY := 6
    ; map tab tier button positions and size
    static mapTier_xpos := {1:41, 2:107, 3:173, 4:239, 5:305, 6:372, 7:438, 8:504, 9:570 , 10:79, 11:145, 12:212, 13:278, 14:244, 15:410, 16:476 , unique:542}
    static mapTier_ypos := {1:159, 2:159, 3:159, 4:159, 5:159, 6:159, 7:159, 8:159, 9:159 , 10:227, 11:227, 12:227,13:227, 14:227, 15:227, 16:227 , unique:227}
    static mapTier_squareWRoot := 45/1080
    static mapTier_squareHRoot := 45/1080
    ; map map button positions and size
    static mapMap_xpos := [83,156,229,302,375,447,520 , 83,156,229,302,375,447,520]
    static mapMap_ypos := [328,328,328,328,328,328,328 , 405,405,405,405,405,405,405]
    static mapMap_ypos_2 := [329,329,329,329,329,329,329 , 407,407,407,407,407,407,407] ; after clicking down arrow, it's offset for some reasons
    static mapMap_squareWRoot := 58/1080
    static mapMap_squareHRoot := 59/1080
    ; map arrow up down positions and size
    static mapArrowUp_xRoot := 600/1080, mapArrowUp_yRoot := 346/1080
    static mapArrowDown_xRoot := 600/1080, mapArrowDown_yRoot := 416/1080
    static mapArrow_wRoot := 16/1080, mapArrow_hRoot := 23/1080
    static mapArrow_mapsPerLine := 7, mapArrow_mapsRows := 2

    ; thicness of gui borders
    static gridThicc := 2
    static tabThicc := 1
    static itemThicc := 1

    Create(gridItemX, gridItemY, gridItemName, gridItemTab, winX, winY, winH, winBorderSide="", winBorderTop="", itemType="", mapTier="") {
        global PROGRAM
        global GuiItemGrid, GuiItemGrid_Controls, GuiItemGrid_Submit
        global GuiItemGridNormal, GuiItemGridNormal_Controls, GuiItemGridNormal_Submit
        global GuiItemGridQuad, GuiItemGridQuad_Controls, GuiItemGridQuad_Submit
        global GuiItemGridItemName, GuiItemGridItemName_Controls, GuiItemGridItemName_Submit
        global GuiItemGridTabName, GuiItemGridTabName_Controls, GuiItemGridTabName_Submit
        global GuiItemGridMap, GuiItemGridMap_Controls, GuiItemGridMap_Submit
        global GuiItemGridMapTier, GuiItemGridMapTier_Controls, GuiItemGridMapTier_Submit
        global GuiItemGridMapMap, GuiItemGridMapMap_Controls, GuiItemGridMapMap_Submit
        global GuiItemGridMapArrow, GuiItemGridMapArrow_Controls, GuiItemGridMapArrow_Submit

        delay := SetControlDelay(0), batch := SetBatchLines(-1)

        hideNormalTab := PROGRAM.SETTINGS.SETTINGS_MAIN.ItemGridHideNormalTab
        hideQuadTab := PROGRAM.SETTINGS.SETTINGS_MAIN.ItemGridHideQuadTab
        hideNormalAndQuadTabsForMaps := PROGRAM.SETTINGS.SETTINGS_MAIN.ItemGridHideNormalTabAndQuadTabForMaps

        resDPI := Get_DpiFactor()
        winH := winH / resDPI ; os dpi fix
        winX := winX / resDPI ; os dpi fix
        winY := winY / resDPI ; os dpi fix

        ; Get default border size if unspecified
        ; SysGet, SM_CXSIZEFRAME, 32
        ; SysGet, SM_CYSIZEFRAME, 33
        ; SysGet, SM_CYCAPTION, 4
        ; winBorderTop := winBorderTop=""?SM_CYSIZEFRAME+SM_CYCAPTION : winBorderTop
        ; winBorderSide := winBorderSide=""?SM_CXSIZEFRAME : winBorderSide

        ; Set border size at 0 if unspecified (borderless)
        winBorderTop := winBorderTop?winBorderTop:0
        winBorderSide := winBorderSide?winBorderSide:0

        winBorderSide := winBorderSide / resDPI
        winBorderTop := winBorderTop / resDPI

        xStart := this.tab_xRoot * winH, yStart := this.tab_yRoot * winH ; Calc first case x/y start pos
        map_xStart := this.map_xRoot * winH, map_yStart := this.map_yRoot * winH 
        gridItemX--, gridItemY-- ; Minus one, so we can get correct case multiplier

        GUI_ItemGrid.Destroy()

        ; = = = = = = = = = = = = Regular tab = = = = = = = = = = = = 
        if IsBetween(gridItemX+1, 1, this.tab_casesCountX) && IsBetween(gridItemY+1, 1, this.tab_casesCountY) ; if both X and Y are lower than the max case count
            fitsInNormalTab := True 
        if (fitsInNormalTab && itemType="Map")
            drawNormalGrid := hideNormalAndQuadTabsForMaps="False" && hideNormalTab="False"?True:False
        else 
            drawNormalGrid := hideNormalTab="False"?True:False

        if (drawNormalGrid = True) {
            tab_caseW := this.tab_squareWRoot * winH, tab_caseH := this.tab_squareHRoot * winH ; Calc case w/h
            tab_stashX := xStart + (gridItemX * tab_caseW), tab_stashY := yStart + (gridItemY * tab_caseH) ; Calc point pos
            tab_stashXRelative := tab_stashX + winX, tab_stashYRelative := tab_stashY + winY ; Relative to win pos
            tab_stashXRelative += winBorderSide, tab_stashYRelative += winBorderTop ; Add win border
            tab_pointW := tab_caseW, tab_pointH := tab_caseH ; Make a square same size as stash square
            squareColor := "10c200"

            Gui.New("ItemGridNormal", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridNormal", "ItemGridNormal")
            Gui.Color("ItemGridNormal", "EEAA99")
            WinSet, TransColor, EEAA99 254 ; 254 = need to be trans to allow clickthrough style
            Gui.Add("ItemGridNormal", "Progress", "x0 y0 w" tab_pointW " h" this.gridThicc " Background" squareColor) ; ^
            Gui.Add("ItemGridNormal", "Progress", "x" tab_pointW - this.gridThicc " y0 w" this.gridThicc " h" tab_pointH " Background" squareColor) ; > 
            Gui.Add("ItemGridNormal", "Progress", "x0 y" tab_pointH - (this.gridThicc*3) " w" tab_pointW " h" this.gridThicc*3 " Background" squareColor) ; v 
            Gui.Add("ItemGridNormal", "Progress", "x0 y0 w" this.gridThicc " h" tab_pointH " Background" squareColor) ; <
            showNormalTabGrid := True 
        }
        ;= = = = = = = = = = = = Quad tab = = = = = = = = = = = = 
        if (itemType="Map")
            drawQuadGrid := hideNormalAndQuadTabsForMaps="False" && hideQuadTab="False"?True:False
        else 
            drawQuadGrid := hideQuadTab="False"?True:False
        
        if (drawQuadGrid = True) {
            quad_caseW := this.quad_squareWRoot * winH, quad_caseH := this.quad_squareHRoot * winH ; Calc case w/h
            quad_stashX := xStart + (gridItemX * quad_caseW), quad_stashY := yStart + (gridItemY * quad_caseH) ; Calc point pos
            quad_stashXRelative := quad_stashX + winX, quad_stashYRelative := quad_stashY + winY ; Relative to win pos
            quad_stashXRelative += winBorderSide, quad_stashYRelative += winBorderTop ; Add win border
            quad_pointW := quad_caseW, quad_pointH := quad_caseH ; Make a square same size as stash square
            squareColor := "10c200"

            Gui.New("ItemGridQuad", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridQuad", "ItemGridQuad")
            Gui.Color("ItemGridQuad", "EEAA99")
            WinSet, TransColor, EEAA99 254
            Gui.Add("ItemGridQuad", "Progress", "x0 y0 w" quad_pointW " h" this.gridThicc " Background" squareColor) ; ^
            Gui.Add("ItemGridQuad", "Progress", "x" quad_pointW - this.gridThicc " y0 w" this.gridThicc " h" quad_pointH " Background" squareColor) ; > 
            Gui.Add("ItemGridQuad", "Progress", "x0 y" quad_pointH - (this.gridThicc*3) " w" quad_pointW " h" this.gridThicc*3 " Background" squareColor) ; v 
            Gui.Add("ItemGridQuad", "Progress", "x0 y0 w" this.gridThicc " h" quad_pointH " Background" squareColor) ; <
            showQuadTabGrid := True
        }

        ; = = = = = = = = = = = = Item name = = = = = = = = = = = = 
        guiFont := "Fontin Regular", guiFontSize := 12
        txtSize := Get_TextCtrlSize(gridItemName, guiFont, guiFontSize)
        itemName_guiW := txtSize.W+30, itemName_guiH := txtSize.H+10
        fontColor := "000000", backgroundColor := "B9B9B9", borderColor := "000000"

        stashTabHeight := this.stashTabHeightRoot*winH
        ; itemNameX := xStart, itemNameY := yStart + (this.tab_casesCountY * caseH) + 5 ; Position: Under all cases
        itemNameX := xStart, itemNameY := yStart - (this.stashTabHeightRoot*winH) - (itemName_guiH*2) - 5 +1 ; Position: Above tabname gui
        itemNameX += winBorderSide, itemNameY += winBorderTop ; Add window border
        itemNameXRelative := itemNameX + winX, itemNameYRelative := itemNameY + winY ; Relative to win pos
       
        Gui.New("ItemGridItemName", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridItemName", "ItemGridItemName")
        Gui.Font("ItemGridItemName", guiFont, guiFontSize)
        Gui.Color("ItemGridItemName", backgroundColor)
        Gui.Add("ItemGridItemName", "Progress", "x0 y0 w" itemName_guiW " h" this.itemThicc " Background" borderColor) ; ^
        Gui.Add("ItemGridItemName", "Progress", "x" itemName_guiW-this.itemThicc " y0 w" this.itemThicc " h" itemName_guiH " Background" borderColor) ; > 
        Gui.Add("ItemGridItemName", "Progress", "x0 y" itemName_guiH-this.itemThicc " w" itemName_guiW-this.itemThicc " h" this.itemThicc " Background" borderColor) ; v 
        Gui.Add("ItemGridItemName", "Progress", "x0 y0 w" this.itemThicc " h" itemName_guiH " Background" borderColor) ; <
        Gui.Add("ItemGridItemName", "Text", "x0 y0 cBlack Center BackgroundTrans w" itemName_guiW " h" itemName_guiH " 0x200 c" fontColor, gridItemName)

        ; = = = = = = = = = = = = Stash tab name = = = = = = = = = = = = 
        guiFont := "Fontin Regular", guiFontSize := 12
        txtSize := Get_TextCtrlSize("Tab: " gridItemTab, guiFont, guiFontSize)
        tabName_guiW := txtSize.W+30, tabName_guiH := txtSize.H+10
        fontColor := "000000", backgroundColor := "B9B9B9", borderColor := "000000"

        stashTabHeight := this.stashTabHeightRoot*winH
        ; stashTabNameX := xStart, stashTabNameY := yStart + (this.tab_casesCountY * caseH) + 5 ; Position: Under all cases
        stashTabNameX := xStart, stashTabNameY := yStart - (this.stashTabHeightRoot*winH) - tabName_guiH - 5 ; Position: Above tabs
        stashTabNameX += winBorderSide, stashTabNameY += winBorderTop ; Add window border
        stashTabNameXRelative := stashTabNameX + winX, stashTabNameYRelative := stashTabNameY + winY ; Relative to win pos
       
        Gui.New("ItemGridTabName", "-Border +LastFound +AlwaysOnTop -Caption +AlwaysOnTop +ToolWindow +HwndhGuiItemGridTabName", "ItemGridTabName")
        Gui.Font("ItemGridTabName", guiFont, guiFontSize)
        Gui.Color("ItemGridTabName", backgroundColor)
        ; Gui.Add("ItemGridTabName", "Progress", "x0 y0 w" tabName_guiW " h" this.tabThicc " Background" borderColor) ; ^
        Gui.Add("ItemGridTabName", "Progress", "x" tabName_guiW-this.tabThicc " y0 w" this.tabThicc " h" tabName_guiH " Background" borderColor) ; > 
        Gui.Add("ItemGridTabName", "Progress", "x0 y" tabName_guiH-this.tabThicc " w" tabName_guiW-this.tabThicc " h" this.tabThicc " Background" borderColor) ; v 
        Gui.Add("ItemGridTabName", "Progress", "x0 y0 w" this.tabThicc " h" tabName_guiH " Background" borderColor) ; <
        Gui.Add("ItemGridTabName", "Text", "x0 y0 cBlack Center BackgroundTrans w" tabName_guiW " h" tabName_guiH " 0x200 c" fontColor, "Tab: " gridItemTab)

        ; = = = = = = = = = = = = Map tab = = = = = = = = = = = = 
        if (itemType = "Map") && (gridItemX+1 <= this.map_casesCountX) && (gridItemY+1 <= this.map_casesCountY) {
            ; Map item
            map_caseW := this.map_squareWRoot * winH, map_caseH := this.map_squareHRoot * winH ; Calc case w/h
            map_stashX := map_xStart + (gridItemX * map_caseW), map_stashY := map_yStart + (gridItemY * map_caseH) ; Calc point pos
            map_stashXRelative := map_stashX + winX, map_stashYRelative := map_stashY + winY ; Relative to win pos
            map_stashXRelative += winBorderSide, map_stashYRelative += winBorderTop ; Add win border
            map_pointW := map_caseW, map_pointH := map_caseH ; Make a square same size as stash square
            squareColor := "007ec2"

            Gui.New("ItemGridMap", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridMap", "ItemGridMap")
            Gui.Color("ItemGridMap", "EEAA99")
            WinSet, TransColor, EEAA99 254
            Gui.Add("ItemGridMap", "Progress", "x0 y0 w" map_pointW " h" this.gridThicc " Background" squareColor) ; ^
            Gui.Add("ItemGridMap", "Progress", "x" map_pointW - this.gridThicc " y0 w" this.gridThicc " h" map_pointH " Background" squareColor) ; > 
            Gui.Add("ItemGridMap", "Progress", "x0 y" map_pointH - (this.gridThicc*3) " w" map_pointW " h" this.gridThicc*3 " Background" squareColor) ; v 
            Gui.Add("ItemGridMap", "Progress", "x0 y0 w" this.gridThicc " h" map_pointH " Background" squareColor) ; <

            ; Map tier case
            mapTier_caseW := this.mapTier_squareWRoot * winH, mapTier_caseH := this.mapTier_squareHRoot * winH ; Calc case w/h
            mapTier_stashX := this.mapTier_xpos[mapTier]/1080 * winH, mapTier_stashY := this.mapTier_ypos[mapTier]/1080 * winH ; /1080 to get root
            mapTier_stashXRelative := mapTier_stashX + winX, mapTier_stashYRelative := mapTier_stashY + winY ; Relative to win pos
            mapTier_stashXRelative += winBorderSide, mapTier_stashYRelative += winBorderTop ; Add win border
            mapTier_pointW := mapTier_caseW, mapTier_pointH := mapTier_caseH ; Make a square same size as stash square
            squareColor := "007ec2"

            Gui.New("ItemGridMapTier", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridMapTier", "ItemGridMapTier")
            Gui.Color("ItemGridMapTier", "EEAA99")
            WinSet, TransColor, EEAA99 254
            Gui.Add("ItemGridMapTier", "Progress", "x0 y0 w" mapTier_pointW " h" this.gridThicc " Background" squareColor) ; ^
            Gui.Add("ItemGridMapTier", "Progress", "x" mapTier_pointW - this.gridThicc " y0 w" this.gridThicc " h" mapTier_pointH " Background" squareColor) ; > 
            Gui.Add("ItemGridMapTier", "Progress", "x0 y" mapTier_pointH - (this.gridThicc*3) " w" mapTier_pointW " h" this.gridThicc*3 " Background" squareColor) ; v 
            Gui.Add("ItemGridMapTier", "Progress", "x0 y0 w" this.gridThicc " h" mapTier_pointH " Background" squareColor) ; <
            /* #280 - Disabled until proper solution using stash api is worked on
            ; Map map case
            RegExMatch(gridItemName, "O)(.*) \(T(\d+)\)$", itemPat)
                mapNameOnly := itemPat.1
            for mapName, nothing in PROGRAM.DATA.MAPS_DATA["tier_" mapTier] {
                if (mapTier="unique") {
                    uniqueMapMatch := IsContaining_Parse(mapNameOnly, PROGRAM.DATA.UNIQUE_MAPS_LIST, "`n", "`r", getMatch:=True).2
                    if IsContaining(mapName, uniqueMapMatch) {
                        mapNum := PROGRAM.DATA.MAPS_DATA["tier_" mapTier][mapName]["pos"]
                        Break
                    }
                }
                else {
                    if IsContaining(mapNameOnly, mapName) {
                        mapNum := PROGRAM.DATA.MAPS_DATA["tier_" mapTier][mapName]["pos"]
                        Break
                    }
                }
            }
            if (mapNum > this.mapArrow_mapsPerLine*this.mapArrow_mapsRows) {
                Loop 10 {
                    arrowClicks := A_Index
                    mapNum -= this.mapArrow_mapsPerLine
                    if IsBetween(mapNum, 1, this.mapArrow_mapsPerLine*this.mapArrow_mapsRows)
                        Break
                }
            }
            */

            if (mapNum) {
                mapMap_ypos := arrowClicks?this.mapMap_ypos_2:this.mapMap_ypos

                mapMap_caseW := this.mapMap_squareWRoot * winH, mapMap_caseH := this.mapMap_squareHRoot * winH ; Calc case w/h
                mapMap_stashX := this.mapMap_xpos[mapNum]/1080 * winH, mapMap_stashY := mapMap_ypos[mapNum]/1080 * winH ; /1080 to get root
                mapMap_stashXRelative := mapMap_stashX + winX, mapMap_stashYRelative := mapMap_stashY + winY ; Relative to win pos
                mapMap_stashXRelative += winBorderSide, mapMap_stashYRelative += winBorderTop ; Add win border
                mapMap_pointW := mapMap_caseW, mapMap_pointH := mapMap_caseH ; Make a square same size as stash square
                squareColor := "007ec2"

                Gui.New("ItemGridMapMap", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridMapMap", "ItemGridMapMap")
                Gui.Color("ItemGridMapMap", "EEAA99")
                WinSet, TransColor, EEAA99 254
                Gui.Add("ItemGridMapMap", "Progress", "x0 y0 w" mapMap_pointW " h" this.gridThicc " Background" squareColor) ; ^
                Gui.Add("ItemGridMapMap", "Progress", "x" mapMap_pointW - this.gridThicc " y0 w" this.gridThicc " h" mapMap_pointH " Background" squareColor) ; > 
                Gui.Add("ItemGridMapMap", "Progress", "x0 y" mapMap_pointH - (this.gridThicc*3) " w" mapMap_pointW " h" this.gridThicc*3 " Background" squareColor) ; v 
                Gui.Add("ItemGridMapMap", "Progress", "x0 y0 w" this.gridThicc " h" mapMap_pointH " Background" squareColor) ; <

                showMapMapGrid := True
            }

            if (arrowClicks) {
                mapArrow_caseW := this.mapArrow_wRoot * winH, mapArrow_caseH := this.mapArrow_hRoot * winH ; Calc case w/h
                mapArrow_stashX := this.mapArrowDown_xRoot * winH, mapArrow_stashY := this.mapArrowDown_yRoot * winH ; /1080 to get root
                mapArrow_stashXRelative := mapArrow_stashX + winX, mapArrow_stashYRelative := mapArrow_stashY + winY ; Relative to win pos
                mapArrow_stashXRelative -= this.gridThicc, mapArrow_stashYRelative -= this.gridThicc ; Relative to win pos
                mapArrow_stashXRelative += winBorderSide, mapArrow_stashYRelative += winBorderTop ; Add win border
                mapArrow_pointW := mapArrow_caseW + this.gridThicc*3, mapArrow_pointH := mapArrow_caseH + this.gridThicc*3 ; Make a square same size as stash square + around the element
                squareColor := "007ec2"

                Gui.New("ItemGridMapArrow", "+AlwaysOnTop +ToolWindow +LastFound -SysMenu -Caption -Border +E0x08000000 +HwndhGuiItemGridMapArrow", "ItemGridMapArrow")
                Gui.Color("ItemGridMapArrow", "EEAA99")
                WinSet, TransColor, EEAA99 254
                Gui.Add("ItemGridMapArrow", "Progress", "x0 y0 w" mapArrow_pointW " h" this.gridThicc " Background" squareColor) ; ^
                Gui.Add("ItemGridMapArrow", "Progress", "x" mapArrow_pointW - this.gridThicc " y0 w" this.gridThicc " h" mapArrow_pointH " Background" squareColor) ; > 
                Gui.Add("ItemGridMapArrow", "Progress", "x0 y" mapArrow_pointH - (this.gridThicc*3) " w" mapArrow_pointW " h" this.gridThicc*3 " Background" squareColor) ; v 
                Gui.Add("ItemGridMapArrow", "Progress", "x0 y0 w" this.gridThicc " h" mapArrow_pointH " Background" squareColor) ; <

                showMapArrowGrid := True
            }
            
            showMapTabGrid := True
        }

        ; = = = = = = = = = = = = Show = = = = = = = = = = = = 
        if (showNormalTabGrid)
            Gui.Show("ItemGridNormal", "x" tab_stashXRelative*resDPI " y" tab_stashYRelative*resDPI " AutoSize NoActivate")
        if (showQuadTabGrid)
            Gui.Show("ItemGridQuad", "x" quad_stashXRelative*resDPI " y" quad_stashYRelative*resDPI " AutoSize NoActivate")
        Gui.Show("ItemGridItemName", "x" itemNameXRelative*resDPI " y" itemNameYRelative*resDPI " w" itemName_guiW " h" itemName_guiH " NoActivate")
        Gui.Show("ItemGridTabName", "x" stashTabNameXRelative*resDPI " y" stashTabNameYRelative*resDPI " w" tabName_guiW " h" tabName_guiH " NoActivate")
        if (showMapTabGrid) {
            Gui.Show("ItemGridMap", "x" map_stashXRelative*resDPI " y" map_stashYRelative*resDPI " NoActivate")
            Gui.Show("ItemGridMapTier", "x" mapTier_stashXRelative*resDPI " y" mapTier_stashYRelative*resDPI " NoActivate")
            if (showMapMapGrid)
                Gui.Show("ItemGridMapMap", "x" mapMap_stashXRelative*resDPI " y" mapMap_stashYRelative*resDPI " NoActivate")
            if (showMapArrowGrid)
                Gui.Show("ItemGridMapArrow", "x" mapArrow_stashXRelative*resDPI " y" mapArrow_stashYRelative*resDPI " NoActivate")
        }

        guiNames := ["ItemGridNormal","ItemGridQuad","ItemGridItemName","ItemGridTabName","ItemGridMap","ItemGridMapTier","ItemGridMapMap","ItemGridMapArrow"]
        GuiItemGrid := {Names:{}, Controls:{}, Submit:{}}
        for index, guiName in guiNames {
            hw := DetectHiddenWindows("On")
            if WinExist("ahk_id " Gui%guiName%["Handle"]) {
                GuiItemGrid.Names[guiName] := Gui%guiName%
                GuiItemGrid.Controls[guiName] := Gui%guiName%_Controls
                GuiItemGrid.Submit[guiName] := Gui%guiName%_Submit

                Gui, %guiName%:+LastFound
                if IsIn(guiName, "ItemGridItemName,ItemGridTabName")
                    WinSet, Transparent,% (255/100)*65
                WinSet, ExStyle, +0x20 ; Clickthrough
            }
            DetectHiddenWindows(hw)
        }
        SetControlDelay(delay), SetBatchLines(batch)
    }

    Destroy() {
        global GuiItemGrid

        for guiName, nothing in GuiItemGrid.Names
            try Gui.Destroy(guiName)
    }

    Detect(_hw="Off", guiName="") {
        global GuiItemGrid

        hw := DetectHiddenWindows(_hw)

        exists := False
        if (guiName) {
            if WinExist("ahk_id " GuiItemGrid.Names[guiName].Handle)
                exists := True
        }
        else {
            for guiName, nothing in GuiItemGrid.Names {
                if WinExist("ahk_id " GuiItemGrid.Names[guiName].Handle)
                    exists := True
            }
        }

        DetectHiddenWindows(hw)
        return exists
    }

    IsVisible() {
        isVisible := GUI_ItemGrid.Detect(_hw:="Off")
        return isVisible
    }

    ThisExists(guiName) {
        exists := GUI_ItemGrid.Detect(_hw:="On", guiName)
        return exists
    }

    Exists() {
        exists := GUI_ItemGrid.Detect(_hw:="On")
        return exists
    }

    Hide() {
        global GuiItemGrid
        if !GUI_ItemGrid.Exists()
            return

        for guiName, nothing in GuiItemGrid.Names
            Gui, %guiName%:Hide
    }

    Show() {
        global GuiItemGrid
        if !GUI_ItemGrid.Exists()
            return

        for guiName, nothing in GuiItemGrid.Names
            Gui, %guiName%:Show, NoActivate
    }
}
