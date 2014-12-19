AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local CurTime = CurTime 

function ENT:Initialize()
	
	self.nCheck = CurTime( );
	self.players = {};
end

function ENT:SetConfig( cfg )
	self.cfg = cfg;
	local radius = cfg.radius;
	self:SetRadius( radius );
	
end


-- KILL COOL DOWN
gmodz.hook.Add('PlayerDeath', function( pl, _, attckr )
	
	attckr:SetNWBool( 'sz_cooldown', true );
	timer.Simple( 120, function()
		if IsValid( attckr )then 
			attckr:SetNWBool( 'sz_cooldown', false );
		end	
	end);
	
end);

do

	local function dist( p1, p2 )
		return math.sqrt( (p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y) );
	end

	local cache = {};
	local function checkClass( c )
		if cache[ c ] ~= nil then return cache[c] end
		cache[c] = string.find( c, 'npc_' ) and true or false ;
	end
	
	local function ragdollPlayer( victim )
		local ragModel = victim:GetModel()
		local ragPos = victim:GetPos()
		local ragAng = victim:GetAngles()

		--Create the colliding ragdoll
		local ragObj = ents.Create( "prop_ragdoll" )
		ragObj:SetModel( ragModel )
			
		--Set other parameters here
		ragObj:SetPos( ragPos )
		ragObj:SetAngles( ragAng )
			
		--Spawn the ragdoll
		ragObj:Spawn()
			
		--Spectate our corpse
		victim:Spectate( OBS_MODE_CHASE )
		victim:SpectateEntity( ragObj )
			
		--Get all the bones
		local ragBones = ragObj:GetPhysicsObjectCount()
			
		--Loop through each bone
		for i = 1, ragBones - 1 do
			
			--Get the current bone
			local ragBone = ragObj:GetPhysicsObjectNum( i )
				
			--Check if it's valid
			if IsValid( ragBone ) then	
				
				--Get the bone's pos and angle
				local ragBonePos, ragBoneAng = victim:GetBonePosition( ragObj:TranslatePhysBoneToBone( i ) ) 
					
				--Set the bone's pos and angle
				ragBone:SetPos( ragBonePos )
				ragBone:SetAngles( ragBoneAng )
				
				--Set velocity
				ragBone:SetVelocity( ragObj:GetVelocity() )
				
			end
			
		end
		
		--Get their current ragdoll
		local crapDoll = victim:GetRagdollEntity()
		
		--Delete it
		crapDoll:Remove()
		
		return ragObj;
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
					self.players[k] = nil;
					return ;
				elseif dist( v:GetPos(), mpos ) > r then
					v:GodDisable( true );
					v:SetNWBool( 'gmodz_sz', false );
					self.players[k] = nil;
				end
			end
			for k,v in pairs( player.GetAll() )do
				if not self.players[v:EntIndex()] and dist( v:GetPos(), mpos ) < r and not v:GetNWBool( 'sz_cooldown' ) then
					v:GodEnable( true );
					v:SetNWBool( 'gmodz_sz', true );
					self.players[v:EntIndex()] = v;
				end
			end
			
			
			
			
			-- disolver
			local found = false;
			local targname = "dissolveme"..self:EntIndex()
			for k,ent in pairs(ents.FindInSphere(mpos,r)) do
				if not checkClass( ent:GetClass() ) and not ent:IsPlayer() then continue end
				if ent:IsPlayer() then
					if ent:GetNWBool( 'sz_cooldown' ) and ent:Alive() then
						ent:Kill( );
						ent = ragdollPlayer( ent );
					else
						continue ;
					end
				end
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
			
			if not found then return end -- we're done.
			
			local dissolver = ents.Create("env_entity_dissolver")
			dissolver:SetKeyValue("magnitude",0)
			dissolver:SetPos(self:GetPos())
			dissolver:SetKeyValue("target",targname)
			dissolver:Spawn()
			dissolver:Fire("Dissolve",targname,0)
			dissolver:Fire("kill","",0.5)
			dissolver:SetKeyValue("dissolvetype",0)
		end
	end
end


