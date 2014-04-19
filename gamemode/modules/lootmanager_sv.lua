gmodz.print('GmodZ activated module lootmanager_sv.lua' );

--
-- MANAGE LOOT SYSTEMS.
--
gmodz.hook.Add( 'medit_Cleanup', function( )
	local c = 0;
	for k,v in pairs( ents.GetAll() )do
		if v:GetClass() ~= 'node_loot' then continue end
		--:OnRemove( );
		v:Remove( );
		c = c + 1;
	end
	gmodz.print('[MEDIT] Cleaned up '..c..' loot nodes!');
end);

local table, math = table, math ;
local function select( tbl )
	local c = 0;
	local opts = {};
	
	for k,v in pairs( tbl )do
		if v.lootBias and (v:IsBase() or v:IsLootable() )then
			c = c + v.lootBias ;
			table.insert( opts, v );
		end
	end
	if c == 0 then return nil end -- nothing to see here.
	
	local _type ;
	repeat
		local t, i = math.random()*c, 0;	
		for k,v in pairs( opts )do
			i = i + v.lootBias ;
			if i < t then continue end
			if v:IsBase( ) then
				c = c - v.lootBias ;
				_type = select( table.remove( opts, k ):GetChildren() );
				break ;
			elseif v:IsLootable() then
				c = c - v.lootBias ;
				_type = table.remove( opts, k );
				break ;
			end
		end
	until ( _type or #opts == 0 )
	return _type ;
end

local function chooseItemType( _b )
	return _b and select( _b ) or select( { gmodz.item.GetMeta( 'base' ) } );
end

gmodz.hook.Add( 'ChooseLootType', function( bases )
	local bmetas = {};
	for k,v in pairs( bases )do
		if type( v ) ~= 'string' then continue end
		bmetas[ #bmetas + 1 ] = gmodz.item.GetMeta( v );
	end
	
	return chooseItemType( bmetas );
end);

gmodz.hook.Add( 'PostMapLoaded', function()
	for k,v in pairs( ents.FindByClass( 'node_loot' ) )do
		v:SpawnLoot( );
	end
end);


-- NPC Looting...
gmodz.hook.Add( 'OnNPCKilled', function( npc, pl, wep )
	if math.random(1,15) == 1 then
		local lType = gmodz.hook.Call( 'ChooseLootType', { gmodz.item.GetMeta( 'base' )} );
		local ent = lType:CreateDrop( isfunction( lType.lootCount ) and lType.lootCount( lType ) or lType.lootCount );
		local pos = npc:GetPos() ;
		pos.z = pos.z - ent:OBBMins().z ;
		ent:SetPos( pos );
		
		ent:Spawn( );
	elseif  math.random(1,5) == 1 then
		local ent = gmodz.item.GetMeta('money'):CreateDrop( math.random(5,10) );
		local pos = npc:GetPos() ;
		pos.z = pos.z - ent:OBBMins().z ;
		ent:SetPos( pos );
		
		ent:Spawn( );
	end
end);

timer.Simple( 0, function()
	local counts = {};
	for i = 1, 100 do
		local mt = chooseItemType( );
		counts[ mt.class ] = ( counts[ mt.class ] or 0 ) + 1;
	end
	
	print("CALCULATED: ");
	for k,v in SortedPairs( counts )do
		print( k..' - '..v );
	end
	
end);
