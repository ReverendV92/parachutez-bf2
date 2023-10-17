function ParachuteShake(UCMD)
if LocalPlayer().Parachuting == true then
UCMD:SetViewAngles((UCMD:GetViewAngles() + Angle(math.sin(RealTime()*35) * 0.01, math.sin(RealTime()*35) * 0.01, 0)))
end
end
hook.Add("CreateMove", "ParachuteShake", ParachuteShake)

local function PARAIsIn( um )
LocalPlayer().Parachuting = um:ReadBool()
end
usermessage.Hook( "PARAIsIn", PARAIsIn )
 
---------------

local DermaPanel = vgui.Create( "DFrame" )
DermaPanel:SetPos( 50,50 )
DermaPanel:SetSize( 250, 250 )
DermaPanel:SetTitle( "Testing `Derma Stuff" )
DermaPanel:SetVisible( true )
DermaPanel:SetDraggable( true )
DermaPanel:ShowCloseButton( true )
DermaPanel:MakePopup()
 
DermaList = vgui.Create( "DPanelList", DermaPanel )
DermaList:SetPos( 25,25 )
DermaList:SetSize( 200, 200 )
DermaList:SetSpacing( 5 ) -- Spacing between items
DermaList:EnableHorizontal( false ) -- Only vertical items
DermaList:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
 
    local CategoryContentOne = vgui.Create( "DCheckBoxLabel" )
    CategoryContentOne:SetText( "God Mode" )
    CategoryContentOne:SetConVar( "sbox_godmode" )
    CategoryContentOne:SetValue( 1 )
    CategoryContentOne:SizeToContents()
DermaList:AddItem( CategoryContentOne ) -- Add the item above
 
    local CategoryContentTwo = vgui.Create( "DCheckBoxLabel" )
    CategoryContentTwo:SetText( "Player Damage" )
    CategoryContentTwo:SetConVar( "sbox_plpldamage" )
    CategoryContentTwo:SetValue( 1 )
    CategoryContentTwo:SizeToContents()
DermaList:AddItem( CategoryContentTwo ) -- Add the item above
 
    local CategoryContentThree = vgui.Create( "DCheckBoxLabel" )
    CategoryContentThree:SetText( "Fall Damage" )
    CategoryContentThree:SetConVar( "mp_falldamage" )
    CategoryContentThree:SetValue( 1 )
    CategoryContentThree:SizeToContents()
DermaList:AddItem( CategoryContentThree ) -- Add the item above
 
    local CategoryContentFour = vgui.Create( "DCheckBoxLabel" )
    CategoryContentFour:SetText( "Noclip" )
    CategoryContentFour:SetConVar( "sbox_noclip" )
    CategoryContentFour:SetValue( 1 )
    CategoryContentFour:SizeToContents()
DermaList:AddItem( CategoryContentFour ) -- Add the item above
 
    local CategoryContentFive = vgui.Create( "DCheckBoxLabel" )
    CategoryContentFive:SetText( "All Talk" )
    CategoryContentFive:SetConVar( "sv_alltalk" )
    CategoryContentFive:SetValue( 1 )
    CategoryContentFive:SizeToContents()
DermaList:AddItem( CategoryContentFive ) -- Add the item above
 
    local CategoryContentSix = vgui.Create( "DNumSlider" )
    CategoryContentSix:SetSize( 150, 50 ) -- Keep the second number at 50
    CategoryContentSix:SetText( "Max Props" )
    CategoryContentSix:SetMin( 0 )
    CategoryContentSix:SetMax( 256 )
    CategoryContentSix:SetDecimals( 0 )
    CategoryContentSix:SetConVar( "sbox_maxprops" )
DermaList:AddItem( CategoryContentSix ) -- Add the item above
 
    local CategoryContentSeven = vgui.Create("DSysButton", DermaPanel)
    CategoryContentSeven:SetType( "close" )
    CategoryContentSeven.DoClick = function()
        RunConsoleCommand("sv_password", "toyboat")
    end
    CategoryContentSeven.DoRightClick = function()
        RunConsoleCommand("sv_password", "**")
    end
DermaList:AddItem( CategoryContentSeven ) -- Add the item above

concommand.Add("ZChute_Menu", ZChute_Menu) -- Adding the Console Command. So whenever you enter your gamemode, simply type TeamMenu in console.
 