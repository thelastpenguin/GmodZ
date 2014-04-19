local gmodz = gmodz;
--
-- THE ENTITY
--

ENT.Type = "point"

function ENT:Initialize()
	gmodz.print('[LOOT NODE] Spawned.');
end

function ENT:SetConfig( cfg )
	self.cfg = cfg;
	local cfgTypes = cfg.loot_types;
	self.lootTypes = cfgTypes;
	
end

function ENT:SpawnLoot( )
	print("SPAWNING!");
	local lType = gmodz.hook.Call( 'ChooseLootType', self.lootTypes );
	if not lType then
		gmodz.print('ERROR ON NODE: nil loot type', Color(255,0,0));
	end
	
	-- CREATE THE ENTITY
	local succ, ent = pcall( lType.CreateDrop, lType, isfunction( lType.lootCount ) and lType.lootCount( self ) or lType.lootCount );
	if not succ or not IsValid( ent ) then
		gmodz.adminLog("LOOT NODE FAILED TO CREATE LOOT ENTITY.  CLASS: "..lType.class, Color(255,0,0) );
		return end
	
	local size = -ent:OBBMins();
	
	ent:SetPos( self:GetPos( ) + self:GetAngles():Forward() * size.z );
	ent:SetMoveType( MOVETYPE_NONE );
	
	ent:SetUseCallback( function()
		if not IsValid( self )then return end
		self:QueueSpawn( );
	end);
	
	ent:DisableTimeout( true );
	
	ent:Spawn( );
	
	self.entLoot = ent;
end

function ENT:CanSpawnLoot( )
	local mpos = self:GetPos( );
	for _, pl in pairs( player.GetAll() )do
		if pl:GetPos():Distance( mpos ) < 300 then
			return false ;
		end
	end
	return true;
end
local function spawn( self )
	if not IsValid( self )then return end
	if self:CanSpawnLoot( ) then
		self:SpawnLoot( );
	else
		timer.Simple( 60, function() spawn( self ) end );
	end
end
function ENT:QueueSpawn( )
	local rnd = math.random( gmodz.cfg.loot_respawnTime - gmodz.cfg.loot_respawnVariance, gmodz.cfg.loot_respawnTime + gmodz.cfg.loot_respawnVariance );
	print("QUEUED SPAWN: "..rnd );
	timer.Simple( rnd, function( ) spawn( self ) end );
end

function ENT:OnRemove( )
	if IsValid( self.entLoot ) then self.entLoot:Remove( ) end
end