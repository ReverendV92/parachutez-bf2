
AddCSLuaFile()

print("ZParachute Redux - Client File Loading...")

local zparachuteModelNum = GetConVar( "vnt_zparachute_mdl" )

function ParachuteShake(UCMD)
	if LocalPlayer().Parachuting == true then
		UCMD:SetViewAngles((UCMD:GetViewAngles() + Angle(math.sin(RealTime()*35) * 0.01, math.sin(RealTime()*35) * 0.01, 0)))
	end
end
hook.Add("CreateMove", "ParachuteShake", ParachuteShake)

local function PARAIsIn( um )	LocalPlayer().Parachuting = um:ReadBool()	end
usermessage.Hook( "PARAIsIn", PARAIsIn )
	
---------------------------------
--	Player menu @ BlackOps
--	Reassignment Edits @ V92
--
--	I really should stop using this thing, 
--	but god damn it's useful...
---------------------------------
local function DrawRectOutlined( x, y, w, h, col1, col2 )
	surface.SetDrawColor( col1 )
	surface.DrawRect( x, y, w, h )
	surface.SetDrawColor( col2 )
	surface.DrawOutlinedRect( x, y, w, h )
end

local PANEL = {}

function PANEL:Init()
	self.Options = {}
	self.SelectionPosition = 1
	self.SelectedOption = "None"
	
	self.Label = vgui.Create("DLabel", self)
	self.Label:SetText( "N/A" )
	self.Label:SizeToContents()
	self.Label:SetPos( 5, 5 )
	
	-- Model Selection Back Arrow
	self.BackBut = vgui.Create("DImageButton", self)
	self.BackBut:SetMaterial( "icon16/arrow_left.png" )
	self.BackBut:SizeToContents()
	self.BackBut:SetPos( 0, 5 )
	self.BackBut.DoClick = function()
		self:GoBack()
	end
	
	-- Model Selection Text Background
	self.Display = vgui.Create("DPanel", self)
	self.Display:SetSize( 100, 20 )
	self.Display:SetPos( 0, 3 )
	self.Display.Paint = function()
		DrawRectOutlined( 0, 0, self.Display:GetWide(), self.Display:GetTall(), Color(255,255,255,255), Color(0,0,0,255) )
		draw.SimpleText( self.SelectedOption, "Default", self.Display:GetWide()/2, 10, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	-- Model Selection Next Arrow
	self.ForwardBut = vgui.Create("DImageButton", self)
	self.ForwardBut:SetMaterial( "icon16/arrow_right.png" )
	self.ForwardBut:SizeToContents()
	self.ForwardBut:SetPos( 0, 5 )
	self.ForwardBut.DoClick = function()
		self:GoForward()
	end
	self:ReAdjustContent()
	self:SetSize( self.Label:GetWide() + self.BackBut:GetWide() + self.Display:GetWide() + self.ForwardBut:GetWide() + 20, self.BackBut:GetTall() + 10 )
end

function PANEL:SetLabelDesc( txt )
	self.Label:SetText( txt )
	self.Label:SizeToContents()
	self:ReAdjustContent()
end

function PANEL:ReAdjustContent()
	self.BackBut:MoveRightOf( self.Label, 5 )
	self.Display:MoveRightOf( self.BackBut, 5 )
	self.ForwardBut:MoveRightOf( self.Display, 5 )
	self:SetSize( self.Label:GetWide() + self.BackBut:GetWide() + self.Display:GetWide() + self.ForwardBut:GetWide() + 20, self.BackBut:GetTall() + 10 )
end

function PANEL:GoBack()
	if self.Options and #self.Options > 0 then
	
		if self.SelectionPosition - 1 < 1 then
			self.SelectionPosition = #self.Options
		else
			self.SelectionPosition = self.SelectionPosition - 1
		end
		
		self:OptionSelected( self.Options[self.SelectionPosition].txt, self.Options[self.SelectionPosition].othr, self.SelectionPosition )
		self.SelectedOption = self.Options[self.SelectionPosition].txt
	end
end

function PANEL:GoForward()
	if self.Options and #self.Options > 0 then
	
		if self.SelectionPosition + 1 > #self.Options then
			self.SelectionPosition = 1
		else
			self.SelectionPosition = self.SelectionPosition + 1
		end
		
		self:OptionSelected( self.Options[self.SelectionPosition].txt, self.Options[self.SelectionPosition].othr, self.SelectionPosition )
		self.SelectedOption = self.Options[self.SelectionPosition].txt
	end
end

function PANEL:OptionSelected( txt, othr, num )
end

function PANEL:PerformLayout()
end

function PANEL:Paint()	-- the background for the button titles
	surface.SetDrawColor( Color(100,100,100,255) )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
end

function PANEL:AddOption( text, other )
	table.insert( self.Options, {txt=text, othr=other} )
	self.SelectedOption = self.Options[1].txt
	self.SelectionPosition = 1
	self:OptionSelected( self.Options[1].txt, self.Options[1].othr, 1 )
end

function PANEL:SetSelected( num )
	if self.Options and num and #self.Options > 0 and self.Options[num] then
		self:OptionSelected( self.Options[num].txt, self.Options[num].othr, num )
		self.SelectedOption = self.Options[num].txt
		self.SelectionPosition = num
	end
end

vgui.Register( "DOptionsSelect", PANEL )
	
-- Menu for Options
list.Set( "DesktopWindows", "ZParaEdit", {

	title		= "ZParachute",
	icon		= "jessev92/ui/zparachute_icon.png",
	init		= function (zparachuteMenu)
	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( 480, 550 )	-- Controls Parent Frame Size
	Frame:SetTitle( "ZParachute Selector" )
	Frame:Center()
	Frame:MakePopup()
	Frame.Paint = function()
		local screensize = Frame:GetWide()-10
		
		draw.RoundedBox( 6, 0, 0, Frame:GetWide(), Frame:GetTall(), Color( 0, 117, 54, 255 ) ) -- outer box
		
		DrawRectOutlined( 5, 30, screensize, screensize, Color(120,120,120,255), Color(0,0,0,255) )	-- model preview background
		
		-- Options Background Grey Box
		local controlscreenpos = Frame:GetWide() + 25
		local controlscreenpossize = Frame:GetTall()-Frame:GetWide()-30
		
		DrawRectOutlined( 5, controlscreenpos, screensize, controlscreenpossize, Color(60,60,60,255), Color(0,0,0,255) )
		
		local controlwidth = Frame:GetWide()/1.5
	end
	
	local currentModel = zparachuteModelNum:GetInt()

	local ModelOptions = vgui.Create( "DOptionsSelect", Frame )
	ModelOptions:SetLabelDesc("Model:")
	ModelOptions:SetPos( Frame:GetWide()*0.25-ModelOptions:GetWide()/2, Frame:GetWide() + 30 )

	-- Sets the Default Menu
	local ModelViewer = vgui.Create( "DModelPanel", Frame )
	ModelViewer:SetPos( 5, 30 )
	ModelViewer:SetSize( Frame:GetWide()-10, Frame:GetWide()-10 )
	ModelViewer:SetModel( "models/jessev92/parachute_justcause.mdl" )
	ModelViewer:SetAnimated( false )
	ModelViewer:SetCamPos( Vector( 200, 0, 225 ) )
	ModelViewer:SetLookAt( Vector( 0, 0, 125 ) )
	ModelViewer:SetFOV( 50 )


	ModelViewer.Paint = function( self )
	
		if ( !IsValid( self.Entity ) ) then return end
	
		local x, y = self:LocalToScreen( 0, 0 )
		
		--local 
		
		self:LayoutEntity( self.Entity )
		
		cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
			cam.IgnoreZ( true )
			
			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( self.Entity:GetPos() )
			render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
			render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
			render.SetBlend( self.colColor.a/255 )
			
			for i=0, 6 do
				local col = self.DirectionalLight[ i ]
				if ( col ) then
					render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
				end
			end
				
			self.Entity:DrawModel()
			self.Weapon:DrawModel() --Had to add this..
			
			render.SuppressEngineLighting( false )
			cam.IgnoreZ( false )
		cam.End3D()
		
		self.LastPaint = RealTime()
	end
	
	ModelOptions.OptionSelected = function(self,text,model,num)
		ModelViewer:SetModel( model )		ModelViewer.Weapon = ClientsideModel( "models/player/kleiner.mdl", RENDERGROUP_BOTH )
		ModelViewer.Weapon:ResetSequence( ModelViewer.Weapon:LookupSequence( "menu_combine" ) )
		ModelViewer.Weapon:SetPoseParameter( "breathing", 0.5 )
		ModelViewer.Weapon:SetParent( ModelViewer.Entity )
		--ModelViewer.Weapon:SetNoDraw( false )
		currentModel = model
	end
	
	ModelOptions:AddOption( "Just Cause", "models/jessev92/parachute_justcause.mdl" )
	ModelOptions:AddOption( "GTAIV", "models/jessev92/parachute_gtaiv.mdl" )
	ModelOptions:AddOption( "BF2", "models/jessev92/bf2/parachute.mdl" )
	ModelOptions:AddOption( "Kaos", "models/jessev92/frontlines/parachute.mdl" )

	ModelOptions:SetSelected( zparachuteModelNum:GetInt() )
	

	-- controls apply button commands
	local ApplyBut = vgui.Create( "DButton", Frame )
	ApplyBut:SetText("Apply")
	ApplyBut:SetSize(60,20)
	ApplyBut:SetPos( Frame:GetWide()*0.7, Frame:GetWide() + 30 )
	ApplyBut.DoClick = function()
		RunConsoleCommand( "vnt_zparachute_mdl", tostring(currentModel) )
		Frame:Close()
		ModelViewer.Weapon:Remove()
	end
end
}	)
--concommand.Add("vninetytwo_zparachute_menu", zparachuteMenu)

print("ZParachute Redux - Client File Loaded!")
