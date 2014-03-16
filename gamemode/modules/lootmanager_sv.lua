gmodz.print('GmodZ activated module lootmanager_sv.lua' );

--
-- MANAGE LOOT SYSTEMS.
--

gmodz.hook.Add( 'medit_Cleanup', function( )
	local c = 0;
	for k,v in pairs( ents.GetAll() )do
		if v:GetClass() ~= 'node_loot' then continue end
		v:Remove( );
		c = c + 1;
	end
	gmodz.print('[MEDIT] Cleaned up '..c..' loot nodes!');
end);

-- 
local nodes = {};
local lootRange = 0;

local function selectNode( )
	local val = math.random()*lootRange
	
	local index = 0;
	local node ; 
	for k,v in ipairs( nodes )do
		local bias = v.sampRange;
		if not bias then continue end
		index = index + bias;
		if index > val then
			node = v;
			break ;
		end
	end
	return node ;
end

local function findOpenNode( )
	local node ;
	local c = 0;
	repeat
		c = c + 1
		node = selectNode( );
		print( node );
	until ( c > 100 or ( node and not IsValid( node.entLoot ) ) )
	
	return node;
end

gmodz.hook.Add( 'medit_PostProcess', function()
	
	gmodz.print('[LOOT SYSTEM PROCESSING]' );
	
	-- CALCULATE RANGE.
	nodes = {};
	for k,v in pairs( ents.GetAll() )do
		if v:GetClass() ~= 'node_loot' or not IsValid( v ) then continue end
		nodes[ #nodes + 1 ] = v;
		lootRange = lootRange + v.sampRange
	end
	
	gmodz.print('  found '..#nodes..' loot nodes.' );
	gmodz.hook.Call( 'looting_LootPickedup', NULL );
end);

local checkLoot =  function()
	local used = 0;
	for k,v in pairs( nodes )do
		if IsValid( v.entLoot ) then
			used = used + 1;
		end
	end
	local goal = math.floor((#nodes)/2)
	while used < goal do
		used = used + 1;
		local n = findOpenNode( );
		n:SpawnLoot( );
		gmodz.print('Spawning loot.');
		
	end
	gmodz.print('Loot processing done.');
end

timer.Create( 'gmodz_checkloot', 120, 0, checkLoot );

gmodz.hook.Add( 'medit_PostProcess', checkLoot );



--
-- NPC Looting
--
do
	local lootTypes = {};
	local lootBases = {
			['base_food'] = true,
			['base_fas2'] = true,
			['base_ammo'] = true
		}
	local lootRange = 0;
	gmodz.hook.Add( 'LoadComplete', function()
		for k,v in pairs( gmodz.item.GetStored( ))do
			if lootBases[ v.base ] then
				lootTypes[ #lootTypes + 1 ] = v;
				lootRange = lootRange + v.lootBias;
			end
		end
	end);

	local function selectLoot( )
		local val = math.random()*lootRange
	
		local index = 0;
		local lootType ; 
		for k,v in ipairs( lootTypes )do
			local bias = v.lootBias;
			if not bias then continue end
			index = index + bias;
			if index > val then
				lootType = v;
				break ;
			end
		end
		return lootType;
	end
	

	gmodz.hook.Add( 'OnNPCKilled', function( npc, pl )
		
		gmodz.adminLog( 'Player '..pl:Name()..' killed NPC '..npc:GetClass());
		
		if math.random(1,3) ~= 1 then return end
		local lType = selectLoot( );
		if not lType then return end
		
		local count = isfunction( lType.lootCount ) and lType.lootCount() or lType.lootCount;
	
		
		-- BUILD STACK
		local lootStack = gmodz.itemstack.new( lType.class );
		lootStack:SetCount( count );
		
		-- SPAWN IT.
		local ent = gmodz.itemstack.CreateEntity( lootStack );
		
		ent:SetPos( npc:GetPos( ) + Vector( 0, 0, 10 ) );
		ent:DisableTimeout( );
	end);
end