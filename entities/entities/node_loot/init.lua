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
	
	-- LINK LOOT TYPE STRINGS TO META TABLES.
	local lootTypes = {};
	for k,v in pairs( cfgTypes )do
		local cldrn = gmodz.item.GetChildren( v );
		if table.Count( cldrn ) > 0 then
			for k,t in pairs( cldrn )do
				table.insert( lootTypes, t );
			end	
		else
			table.insert( lootTypes, gmodz.item.GetMeta( v ) );
		end
	end
	
	self.lootTypes = lootTypes
	
	-- CALCULATE RANGE DATA.
	local sampRange = 0;
	for k,v in pairs( lootTypes )do
		if not v.lootBias then PrintTable( v ) end
		sampRange = sampRange + v.lootBias;
	end
	self.sampRange = sampRange;
	
	self:SpawnLoot( );
end

function ENT:SpawnLoot( )
	
	local val = math.random()*self.sampRange
	
	local index = 0;
	local lType ; 
	for k,v in pairs( self.lootTypes )do
		local bias = v.lootBias;
		index = index + bias;
		if index > val then
			lType = v;
			break ;
		end
	end
	
	-- CREATE THE ENTITY
	local count = isfunction( lType.lootCount ) and lType.lootCount() or lType.lootCount;
	
	
	-- BUILD STACK
	local lootStack = gmodz.itemstack.new( lType.class );
	lootStack:SetCount( count );
	
	-- SPAWN IT.
	local ent = gmodz.itemstack.CreateEntity( lootStack );
	
	self.entLoot = ent;
	
	ent:SetPos( self:GetPos( ) + Vector( 0, 0, 10 ) );
	
end

local CurTime = CurTime ;
function ENT:Think()
	if self.nextSpawn then
		if self.nextSpawn < CurTime( ) then
			self:SpawnLoot()
			self.nextSpawn = nil;
		end
	elseif self.entLoot ~= nil and not IsValid( self.entLoot ) then
		self.entLoot = nil;
		self.nextSpawn = CurTime() + math.random( 100, 200 );
	end
end

function ENT:OnRemove( )
	if IsValid( self.entLoot ) then self.entLoot:Remove( ) end
end