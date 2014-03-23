gmodz.print('GmodZ activated module lootmanager_sv.lua' );

--
-- MANAGE LOOT SYSTEMS.
--
gmodz.hook.Add( 'medit_Cleanup', function( )
	local c = 0;
	for k,v in pairs( ents.GetAll() )do
		if v:GetClass() ~= 'node_loot' then continue end
		v:OnRemove( );
		v:Remove( );
		c = c + 1;
	end
	gmodz.print('[MEDIT] Cleaned up '..c..' loot nodes!');
end);

local function pickRandomBiased( opts )
	
	-- CALCULATE RANGE.
	local r = 0;
	for _, item in pairs( opts )do
		if not item.lootBias or item.lootBias == 0 then continue end
		r = r + item.lootBias ;
	end
	
	-- CHOOSE RANDOM THRESHOLD FROM 0-r
	local t = math.random()*r;
	-- CALC VAL AT THRESH
	local i = 0;
	local lType, b ; 
	for k,v in pairs( opts )do
		if not v.lootBias or v.lootBias == 0 then continue end
		b = v.lootBias;
		i = i + b;
		if i > t then
			lType = v;
			break ;
		end
	end
	if not lType then return pickRandomBiased( opts ) end
	if lType.children == nil or table.Count( lType.children ) == 0 then
		return lType
	else
		return pickRandomBiased( lType.children );
	end
end

local function chooseItemType( )
	local base = gmodz.item.GetMeta( 'base' );
	return pickRandomBiased( base.children );
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
	if math.random(1,4) == 1 then
		
	else
		local lType = gmodz.hook.Call( 'ChooseLootType', self.lootTypes );
		local ent = lType:CreateDrop( );
		local pos = ent:GetPos() ;
		pos.z = pos.z - ent:OBBMins().z ;
		ent:SetPos( pos );
	end
end);