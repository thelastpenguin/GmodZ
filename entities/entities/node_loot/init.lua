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
	local lType = gmodz.hook.Call( 'ChooseLootType', self.lootTypes );
	if not lType then
		gmodz.print('ERROR ON NODE: nil loot type', Color(255,0,0));
	end
	
	-- CREATE THE ENTITY
	local count = isfunction( lType.lootCount ) and lType.lootCount() or lType.lootCount;
	
	-- BUILD STACK
	local lootStack = gmodz.itemstack.new( lType.class );
	lootStack:SetCount( count );
	
	-- SPAWN IT.
	local ent = gmodz.itemstack.CreateEntity( lootStack );
	ent:SetPos( self:GetPos( ) );
	ent:SetMoveType( MOVETYPE_NONE );
	
	ent:SetUseCallback( function()
		if not IsValid( self )then return end
		self:QueueSpawn( );
	end);
	
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

function ENT:QueueSpawn( )
	local rnd = math.random( gmodz.cfg.loot_respawnTime - gmodz.cfg.loot_respawnVariance, gmodz.cfg.loot_respawnTime + gmodz.cfg.loot_respawnVariance );
	timer.Simple( rnd, function()
		if not IsValid( self )then return end
		if self:CanSpawnLoot( ) then
			self:SpawnLoot( );
		else
			self:QueueSpawn( );
		end
	end);
end

function ENT:OnRemove( )
	if IsValid( self.entLoot ) then self.entLoot:Remove( ) end
end