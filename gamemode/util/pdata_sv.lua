gmodz.pdata = {};

gmodz.hook.Add( 'PlayerDisconnected', function( pl )
	local succ, err = pcall( gmodz.pdata.SaveUser, pl );
	if not succ then 
		gmodz.adminLog('ERROR FAILED TO SAVE USER: '..pl:Name().." ON DISCONNECT!");
		gmodz.adminLog( err );
	end
end);

gmodz.hook.Add( 'SaveAll', function()
	for _, pl in pairs( player.GetAll())do
		pl:ChatPrint("Saving user data. You may experience some lag.");
		gmodz.pdata.SaveUser( pl, function()
			pl:ChatPrint( 'Save complete.' );
		end);
	end
end);


--
-- NETWORKING
--
local Player = FindMetaTable( 'Player' );

util.AddNetworkString( 'gmodz_udata_sync' );
function Player:UDataSyncField( strid )
	net.Start( 'gmodz_udata_sync' );
		net.WriteEntity( self );
		net.WriteTable( {strid, self.udata[strid] } );
	net.Send( self );
end

function Player:SetUData( strid, val )
	if not self.udata then return end
	self.udata[ strid ] = val;
	self:UDataSyncField( strid );
end
function Player:GetUData( strid, defval )
	if not self.udata then return defval end
	return self.udata[ strid ] or defval;
end

function Player:UDataSyncAll( )
	for k,v in pairs( self.udata )do
		self:UDataSyncField( k );
	end	
end




--
-- USER DATA LOADING...
-- 
do
	-- CREATE A NEW INVENTORY
	local function invCreate( w, h )
		local n = gmodz.inventory.new( );
		n:SetSize( w, h );
		
		return n;
	end
	
	
	
	
	-- UTILITY TO LOAD USER FROM DATA.
	local function loadUser( pl, pdata, dLoaded )
		local succ, tbl = pcall( gmodz.pon.decode, pdata.inventory );
		if succ then
			local n = gmodz.inventory.newFromTable( tbl );
			n:SetSize( gmodz.cfg.user_invSize.w, gmodz.cfg.user_invSize.h );
			dLoaded.inv = n;
		else
			dLoaded.inv = invCreate( gmodz.cfg.user_invSize.w, gmodz.cfg.user_invSize.h );
		end
		
		local succ, tbl = pcall( gmodz.pon.decode, pdata.bank );
		if succ and #tbl > 0 then
			local bPages = {};
			for k,bTable in ipairs( tbl )do
				local n = gmodz.inventory.newFromTable( bTable );
				n:SetSize( gmodz.cfg.user_bankSize.w, gmodz.cfg.user_bankSize.h );
				bPages[ #bPages + 1 ] = n;
			end
			dLoaded.bank = bPages ;
		else
			dLoaded.bank = { invCreate( gmodz.cfg.user_bankSize.w, gmodz.cfg.user_bankSize.h ) };
		end
		
		dLoaded.health = tonumber( pdata.dHealth );
		dLoaded.food = tonumber( pdata.dFood );
		dLoaded.water = tonumber( pdata.dWater );
		dLoaded.TimePlayed = tonumber( pdata.dTimePlayed );
		dLoaded.dDeaths = tonumber( pdata.dDeaths );
		print( "LOADED DEATHS: "..dLoaded.dDeaths );
		dLoaded.KilledZombies = tonumber( pdata.dKilledZombies );
		dLoaded.KilledCivilians = tonumber( pdata.dKilledCivilians );
		dLoaded.KilledBandits = tonumber( pdata.dKilledBandits );
		dLoaded.karma = tonumber( pdata.karma );
		dLoaded.mdl = pdata.mdl;
	end
	
	-- UTILITY TO INITALIZE USER DATA.
	local function initUser( pl, dLoaded )
		dLoaded.inv = invCreate( gmodz.cfg.user_invSize.w, gmodz.cfg.user_invSize.h );
		GAMEMODE:LoadoutInventory( dLoaded.inv ); -- default inv item contents.
		
		dLoaded.bank = { invCreate( gmodz.cfg.user_bankSize.w, gmodz.cfg.user_bankSize.h ) };
		
		dLoaded.health = gmodz.cfg.starting_health ;
		dLoaded.food = gmodz.cfg.max_food ;
		dLoaded.water = gmodz.cfg.max_water ;
		dLoaded.TimePlayed = 0;
		dLoaded.dDeaths = 0;
		dLoaded.KilledZombies = 0;
		dLoaded.KilledCivilians = 0;
		dLoaded.KilledBandits = 0;
		dLoaded.karma = 0;
		dLoaded.mdl = gmodz.cfg.models[ math.random(1,#gmodz.cfg.models ) ];
	end
	
	-- UTILITY TO LOAD ITEMS
	local function loadItems( data, items )
		for k, item in pairs( data )do
			local succ, tbl = pcall( gmodz.pon.decode, item.data )
			if not succ then tbl = {} end
			items[ v.itemid ] = tbl ;
		end
	end
	
	-- FUNCTION TO APPLY THE DATA ONCE IT IS LOADED.
	local function ApplyData( pl, data )
		-- Assign Inventories
		pl:AssignInv( 'inv', data.inv );
		pl:InvAddEditor( 'inv', pl, true );
		for k, inv in ipairs( data.bank )do
			pl:AssignInv( 'bank'..k, inv );
			pl:InvAddEditor( 'bank'..k, pl, true );
		end
		
		pl.udata = {};
		
		pl:SetUData( 'hp', data.health );
		pl:SetUData( 'food', data.food );
		pl:SetUData( 'water', data.water );
		
		pl:SetUData( 'TimePlayed', data.TimePlayed );
		pl:SetUData( 'Deaths', data.dDeaths );
		pl:SetUData( 'KilledZombies', data.KilledZombies );
		pl:SetUData( 'KilledCivilians', data.KilledCivilians );
		pl:SetUData( 'KilledBandits', data.KilledBandits );
		pl:SetUData( 'karma', data.karma );
		pl:SetUData( 'mdl', data.mdl );
	end
	
	function gmodz.pdata.LoadUser( pl, cback )
		local dLoaded = {};
		local waiting = 2;
		
		local function process( )
			waiting = waiting - 1;
			if waiting <= 0 then
				ApplyData( pl, dLoaded );
				if cback then cback() end
			end
		end
		
		gmodz.db:NewQuery():SetSQL( 'SELECT * FROM gmodz_users WHERE steamid = "?"', pl:SteamID() ):SetCallback( function( data )
			local data = data[1];
			if data then
				gmodz.print('[PDATA] Loaded user '..pl:Name()..'('..pl:SteamID()..') from database.');
				loadUser( pl, data, dLoaded )
			else
				gmodz.print('[PDATA] Initalized user '..pl:Name()..'('..pl:SteamID()..').');
				initUser( pl, dLoaded );
			end
			process( );
		end ):Run( );
		
		gmodz.db:NewQuery():SetSQL( 'SELECT * FROM gmodz_shop WHERE steamid = "?"', pl:SteamID() ):SetCallback( function( data )
			gmodz.print('[PDATA] Loaded user '..pl:Name()..'('..pl:SteamID()..') ITEMS from database.');
			dLoaded.items = {};
			loadItems( data, dLoaded.items );
			process( );
		end ):Run( );
	end
end


--
-- USER DATA SAVING...
--
do
	
	function gmodz.pdata.SaveUser( pl, cback )
		
		-- INVENTORIES
		local inv = gmodz.pon.encode( pl:GetInv('inv'):SaveToTable() );
		local banks = {};
			local index = 1;
			while( pl:GetInv( 'bank'..index ) )do
				index = index + 1;
				banks[#banks+1] = pl:GetInv( 'bank'..(index-1) ):SaveToTable( );
			end
		local bank = gmodz.pon.encode( banks );
		
		-- UDATA
		local food = pl:GetUData( 'food', 0 );
		local water = pl:GetUData( 'water', 0 );
		local TimePlayed = pl:GetUData( 'TimePlayed', 0 );
		local dDeaths = pl:GetUData( 'Deaths', 0 );
		print("SAVED DEATHS AS: "..dDeaths );
		local KilledZombies = pl:GetUData( 'KilledZombies', 0 );
		local KilledCivilians = pl:GetUData( 'KilledCivilians', 0 );
		local KilledBandits = pl:GetUData( 'KilledBandits', 0 );
		local karma = math.Clamp( pl:GetUData( 'karma', 0 ), -100, 100 );
		
		local mdl, mdlid = pl:GetModel( ), 'none' ;
		for k,v in pairs( gmodz.cfg.models )do
			if v == mdl then
				mdlid = k
				break
			end
		end
		
		gmodz.db:NewQuery():SetSQL('REPLACE INTO gmodz_users VALUES ( "?", "?", "?", "?", "?", "?", "?", "?", "?", "?", "?", "?", "?" )',
				pl:SteamID(),
				mdlid,
				inv,
				bank,
				pl:Health(),
				food,
				water,
				TimePlayed,
				dDeaths,
				KilledZombies,
				KilledCivilians,
				KilledBandits,
				karma
			):SetCallback( cback ):Run();
	end
	
end
