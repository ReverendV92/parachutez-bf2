AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Parachute"
ENT.Category		= "Goliath Parachute"
ENT.AutomaticFrameAdvance = true 
ENT.Spawnable		= true
ENT.AdminOnly = true

if CLIENT then 
    net.Receive("equip_parachute_cl_message", function(len, ply)
        local cantwear = net.ReadBool()
        -- We already have a parachute equipped
        if cantwear then 
            chat.AddText( dg_backpack_config["chat_color_prefix"], "[ Parachute ] ", dg_backpack_config["chat_color_sentence"], dg_backpack_config["already_equipped_message"] )
            surface.PlaySound(dg_backpack_config["pickup_denied_sound"])
        return end 

        chat.AddText( dg_backpack_config["chat_color_prefix"], "[ Parachute ] ", dg_backpack_config["chat_color_sentence"], dg_backpack_config["picked_up_message"] )
        surface.PlaySound( dg_backpack_config["pickup_sound"] )
    end)
end

if SERVER then 
    util.AddNetworkString("equip_parachute_cl_message")

	function ENT:Initialize()
		local model = dg_backpack_config["model"]
		self:SetModel(model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetAngles(self:GetAngles() + Angle(0,90,0))
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
	end

	function ENT:Use(activator,caller,usetype)
        if IsValid(caller) && caller:IsPlayer() && (self.nextuse == nil or self.nextuse < CurTime()) then 
            local alreadyequipped = caller.has_parachute
            net.Start("equip_parachute_cl_message")
            net.WriteBool(alreadyequipped)
            caller.has_parachute = true
            net.Send(caller)
            self.nextuse = CurTime() + 1
            if alreadyequipped then return end
            self:Remove()
        end
	end
end