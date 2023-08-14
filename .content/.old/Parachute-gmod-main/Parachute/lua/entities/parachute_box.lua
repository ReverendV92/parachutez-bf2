AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Parachute box"
ENT.Author = "Isemenuk27"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.DisguiseModel = ""
ENT.EntHealth = 100
ENT.NextUse = CurTime()
ENT.Model = "models/props_junk/cardboard_box002a.mdl"
function ENT:Initialize()
	-- Sets what model to use
	self:SetModel(self.Model)
    
	-- Physics stuff
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( 15 )
	-- Init physics only on server, so it doesn't mess up physgun beam
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
end

function ENT:Use( activator )
	if self.NextUse > CurTime() then return end
	if ( activator:IsPlayer() && activator:Alive() ) then 
		if activator:GiveParachute() then
			local physObj = ents.Create( "prop_physics" )
			physObj:SetModel(self.Model)
			physObj:Spawn()
			physObj:SetPos(self:GetPos())
			physObj:SetAngles(self:GetAngles())
			timer.Simple(0.2, function()
				if IsValid(physObj) then
					physObj:TakeDamage(100)
				end
			end)
			
			activator:EmitSound( "npc/combine_soldier/gear6.wav", 60, 100 )
			self:Remove()
		else
			self:EmitSound( "physics/wood/wood_crate_impact_soft2.wav", 45, 100 )
		end
	end
	self.NextUse = CurTime() + 0.2
end
function ENT:OnTakeDamage( dmginfo )
	if CLIENT then return end
	self:TakePhysicsDamage( dmginfo )	
	self.EntHealth = self.EntHealth - dmginfo:GetDamage() 

	if self.EntHealth > 1 or self.Dead then return end
	self.Dead = true
	local physObj = ents.Create( "prop_physics" )
	physObj:SetModel(self.Model)
	physObj:Spawn()
	physObj:SetPos(self:GetPos())
	physObj:SetAngles(self:GetAngles())
	timer.Simple(0.2, function()
		if IsValid(physObj) then
			physObj:TakeDamage(100)
		end
	end)
	self:Remove()
end

function ENT:PhysicsCollide( data, phys )
	if ( data.Speed > 50 ) then self:EmitSound( "Wood.ImpactSoft" ) end
end