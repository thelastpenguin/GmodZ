-- CALLED WHEN PLAYER FIRST ENTERS THE SERVER
function GM:PlayerInitialSpawn( pl )
	gmodz.adminLog( 'Player '..pl:Name()..' Initial Spawned.' );
	pl:SetTeam( TEAM_LOADING );
	pl:Spectate( OBS_MODE_FIXED );
	pl:Lock( );
	pl:SetNWBool('gmz_ready', false );
end

-- CALLED WHEN COMMUNICATION IS ESTABLISHED WITH THE CLIENT
function GM:PlayerNetworkReady( pl )
	pl.NetworkReady = true;
	
	gmodz.pdata.LoadUser( pl, function( )
		GAMEMODE:PlayerDataReady( pl );	
	end);
	gmodz.adminLog( '   Player '..pl:Name()..' is network ready.' );
end

-- CALLED WHEN PLAYER DATA IS LOADED AND READY.
function GM:PlayerDataReady( pl )
	pl.DataReady = true;
	
	gmodz.adminLog( '   Player '..pl:Name()..' is data ready.' );
	
	-- SYNC ALL DATA FIELDS WE HAVE LOADED.
	PrintTable( pl.udata );
	pl:UDataSyncAll( );
	
	GAMEMODE:PlayerReady( pl );
end

-- AFTER ALL HOOKS ARE CALLED
function GM:PlayerReady( pl )
	pl.Ready = true;
	gmodz.adminLog( '   Player '..pl:Name()..' is ready.' );
	
	pl:UnLock();	
	pl:UnSpectate();
	
	pl:SetNWBool('gmz_ready', true );
	
	pl:Spawn();
	pl:SetHealth( pl.udata.health or gmodz.cfg.starting_health );
end

--
-- PLAYER DISCONNECTED
--
function GM:PlayerDisconnected( pl )
	gmodz.hook.Call( 'PlayerDisconnected', pl );	
end

--
-- PLAYER SPAWNED
--
function GM:PlayerSpawn( pl )
	
	if pl:Team() == TEAM_LOADING then
		self:PlayerSpawnLoading( pl );
	else
		self:PlayerSpawnActive( pl );
	end
	
end
function GM:PlayerSpawnLoading( pl )
	pl:StripWeapons( );
	
	local npcs = ents.FindByClass( 'npc_zombie' )
	if #npcs > 0 then
		pl:Spectate( OBS_MODE_CHASE );
		local n = npcs[math.random(1,#npcs)]
		n:SetSchedule( SCHED_IDLE_WALK );
		pl:SpectateEntity( n )
	else
		pl:Spectate( OBS_MODE_FIXED );
	end
	--pl:Lock( );
	pl:SetHealth( gmodz.cfg.starting_health );
	pl:SetModel( "models/player/breen.mdl" );
	
	self:PlayerSpawnHands( pl );
	
end
function GM:PlayerSpawnActive( pl )
	pl:SetMoveType( MOVETYPE_WALK );
	pl:UnSpectate();
	pl:SetModel( gmodz.cfg.models[pl:GetUData( 'mdl' )] or gmodz.cfg.modelRandom( ) );
	pl:SetHealth( pl:GetUData( 'hp', 100 ) );
	
	pl:AllowFlashlight( true );
	
	self:PlayerSpawnHands( pl );
 	
 	-- CALL HOOKS.
 	gmodz.hook.Call( 'PlayerSpawn', pl );
	
end
function GM:PlayerSpawnHands( pl )
	-- VIEW MODEL HANDS.
	local oldhands = pl:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		pl:SetHands( hands )
		hands:SetOwner( pl )

		-- Which hands should we use?
		local cl_playermodel = pl:GetInfo( "cl_playermodel" )
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		-- Attach them to the viewmodel
		local vm = pl:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		pl:DeleteOnRemove( hands )

		hands:Spawn()
 	end	
end

--
-- PLAYER DEATH
--
function GM:PlayerDeath( victim, infl, attacker )
	victim:SpectateEntity( victim:GetRagdollEntity( ) );
	victim:Spectate(OBS_MODE_CHASE);
	victim.respawn_time = CurTime() + 5;
	
	-- drop inv.
	local inv = victim:GetInv( 'inv' );
	local w, h = inv:GetSize();
	for i = 0, w*h-1 do
		local stack = inv:GetSlot( i );
		if not stack then continue end
		local ent = gmodz.itemstack.CreateEntity( stack );
		ent:SetPos( victim:GetPos( ) );
		ent:EnableTimeout( );
		
		inv:SetSlot( i, nil, nil );
	end
	
	-- put in the default inv contents.
	self:LoadoutInventory( inv );
	
	victim:SetTeam( TEAM_LOADING );
	victim:SetUData( 'hp', 100 );
	gmodz.hook.Call( 'PlayerDeath', victim );
	
	return true;
end
function GM:PlayerDeathThink( pl )
	if( pl:Team() ~= TEAM_LOADING )then
		pl:Spawn();
	end
end


--
-- ON ENTITY CREATED
--
function GM:OnEntityCreated( ent )
	gmodz.hook.Call('OnEntityCreated', ent );
end

function GM:EntityRemoved( ent )
	gmodz.hook.Call( 'EntityRemoved', ent );
end



--
-- FALL DAMAGE
--
function GM:GetFallDamage( pl, speed )
	speed = speed - 200
	return ( speed / 8 )
end

--
-- NPC KILLED
--
function GM:OnNPCKilled( npc, killer, wep )
	return gmodz.hook.Call( 'OnNPCKilled', npc, killer, wep );
end


--
-- GIVE DEFAULT INVENTORY
--
function GM:LoadoutInventory( inv )
	if not inv then return end;
	for k,v in pairs( gmodz.cfg.starting_items )do
		local stack = gmodz.itemstack.new( v[1] ):SetCount( v[2] );
		inv:AddStack( stack );
	end
end


--
-- PLAYER MOVE
-- 
function GM:Move( pl, move )
	return gmodz.hook.Call('Move', pl, move );
end


--
-- VOICE CHAT RADIUS
--
function GM:PlayerCanHearPlayersVoice( pl1, pl2 )
	return true, true ;	
end



-- DETECT WHEN PLAYER IS READY FOR DATA.
util.AddNetworkString( 'gmodz_nwready' );
net.Receive( 'gmodz_nwready', function( len, pl )
	if pl:IsReady() then return end
	GAMEMODE:PlayerNetworkReady( pl );
end);

timer.Create( 'gmodz_saveall', 60, 0, function()
	gmodz.hook.Call( 'SaveAll' );
end);
concommand.Add( 'gmodz_forcesave', function( pl )
	if not pl:IsListenServerHost() and not pl:IsSuperAdmin() then
		gmodz.adminLog( 'Player '..pl:Name()..' was denied access to command gmodz_forcesave.' );
		return ;
	end
	gmodz.hook.Call( 'SaveAll' );
end);


-- DEBUG SHIZZLES
timer.Create( 'reload',0.1,1,function()
	for k,v in pairs( player.GetAll())do
		GAMEMODE:PlayerInitialSpawn( v );
		GAMEMODE:PlayerSpawn( v );
		GAMEMODE:PlayerNetworkReady( v );
	end
end);