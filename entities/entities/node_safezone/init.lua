AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local CurTime = CurTime 

function ENT:Initialize()
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE);
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_WORLD );
	
	self.nCheck = CurTime( );
	self.players = {};
end

function ENT:SetConfig( cfg )
	self.cfg = cfg;
	local radius = cfg.radius;
	self:SetRadius( radius );
	
end

do
	local cache = {};
	local function checkClass( c )
		if cache[ c ] ~= nil then return cache[c] end
		cache[c] = string.find( c, 'npc_' ) and true or false ;
	end
	
	function ENT:Think( )
		if self.nCheck < CurTime() then
			
			-- calculations.
			local r = self:GetRadius( );
			self.nCheck = CurTime() + 0.3;
			local mpos = self:GetPos( );
			
			-- check players.
			for k,v in pairs( self.players )do
				if not IsValid( v ) then
					self.players[k] = nil
				elseif v:GetPos():Distance( mpos ) > r then
					v:GodDisable( true );
					v:SetNWBool( 'gmodz_sz', false );
					self.players[k] = nil;
				end
			end
			for k,v in pairs( player.GetAll() )do
				if not self.players[v:EntIndex()] and v:GetPos():Distance( mpos ) < r then
					v:GodEnable( true );
					v:SetNWBool( 'gmodz_sz', true );
					self.players[v:EntIndex()] = v;
				end
			end
			
			
			
			
			-- disolver
			local found = false;
			local targname = "dissolveme"..self:EntIndex()
			for k,ent in pairs(ents.FindInSphere(mpos,r)) do
				if checkClass( ent:GetClass() ) then
					ent:SetKeyValue("targetname",targname)
					local numbones = ent:GetPhysicsObjectCount()
					for bone = 0, numbones - 1 do 
						local PhysObj = ent:GetPhysicsObjectNum(bone)
						if PhysObj:IsValid()then
							PhysObj:SetVelocity(PhysObj:GetVelocity()*0.04+Vector(0,0,10))
							PhysObj:EnableGravity(false)
						end
					end
					
					found = true;
				end
			end
			
			if not found then return end -- we're done.
			
			local dissolver = ents.Create("env_entity_dissolver")
			dissolver:SetKeyValue("magnitude",0)
			dissolver:SetPos(self:GetPos())
			dissolver:SetKeyValue("target",targname)
			dissolver:Spawn()
			dissolver:Fire("Dissolve",targname,0)
			dissolver:Fire("kill","",0.1)
			dissolver:SetKeyValue("dissolvetype",0)
		end
	end
end