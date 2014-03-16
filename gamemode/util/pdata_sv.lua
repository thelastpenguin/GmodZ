gmodz.pdata = {};

gmodz.db:NewQuery():SetString( 'CREATE TABLE IF NOT EXISTS gmodz_users ( steamid VARCHAR( 30 ) NOT NULL, inventory TEXT, bank TEXT, health TINYINT UNSIGNED, food TINYINT UNSIGNED, water TINYINT, UNIQUE( steamid ) )' )();

do

	local function invCreate()
		local n = gmodz.inventory.new( );
		n:SetSize( gmodz.cfg.user_invSize.w, gmodz.cfg.user_invSize.h );
		
		return n;
	end
	local function invLoad( str )
		local succ, inventory = pcall( gmodz.pon.decode, str );
		if( succ )then
			local n = gmodz.inventory.newFromTable( inventory );
			n:SetSize( gmodz.cfg.user_invSize.w, gmodz.cfg.user_invSize.h );
			return n ;
		else
			return invCreate( );
		end
	end

	local function bankCreate(  )
		local n = gmodz.inventory.new( );
		n:SetSize( gmodz.cfg.user_bankSize.w, gmodz.cfg.user_bankSize.h );
		return n;
	end
	local function bankLoad( str )
		local succ, bank = pcall( gmodz.pon.decode, str );
		if( succ )then
			local n = gmodz.inventory.newFromTable( bank );
			n:SetSize( gmodz.cfg.user_bankSize.w, gmodz.cfg.user_bankSize.h );
			return n ;
		else
			return bankCreate( );
		end
	end

	function gmodz.pdata.LoadUser( pl, cback )
		gmodz.db:NewQuery():SetSQL( 'SELECT * FROM gmodz_users WHERE steamid = "?"', pl:SteamID() ):SetCallback( function( data )
			local pdata = data[1];
			if( pdata )then
				-- LOAD THE USER'S INVENTORY
				local inventory = invLoad( pdata.inventory );
				local bank = bankLoad( pdata.bank );
				pl:AssignInv( 'inv', inventory );
				pl:AssignInv( 'bank', bank );
				
				local health = tonumber( pdata.health );
				local food = tonumber( pdata.food );
				local water = tonumber( pdata.water );
				
				pl.udata = {
					health = health,
					food = food,
					water = water
				}
				
			else
				local inventory, bank = invCreate(), bankCreate();
				pl:AssignInv( 'inv', inventory );
				pl:AssignInv( 'bank', bank );
				
				pl.udata = {
					health = gmodz.cfg.starting_health,
					food = gmodz.cfg.max_food,
					water = gmodz.cfg.max_water
				}
				
				gmodz.pdata.SaveUser( pl, function() end );
			end
			
			-- TESTING CODE: pl:GetInv( 'inv' ):SetSlot( math.random( 1, 10 ), gmodz.itemstack.new( 'base' ):SetCount( 10 ):SetData( {['true'] = 'testing'} ) );
			
			if( cback )then cback( ); end
			
		end):Run();
	end
end


function gmodz.pdata.SaveUser( pl, cback )
	local udata = pl.udata;
	if not udata then return false end
	
	udata.health = math.Clamp( pl:Health(), 0, 100 );
	
	local invStr = gmodz.pon.encode( pl:GetInv('inv'):SaveToTable() );
	local bankStr = gmodz.pon.encode( pl:GetInv('bank'):SaveToTable() );
	
	gmodz.db:NewQuery():SetSQL( 'REPLACE INTO gmodz_users VALUES ( "?", "?", "?", "?", "?", "?" )', -- ( steamid, inventory, bank, health, food, water )
															pl:SteamID(), invStr, bankStr, udata.health, udata.food, udata.water ):SetCallback( cback )();
	
	
	return true;
end

gmodz.hook.Add( 'PlayerDisconnected', function( pl )
	gmodz.pdata.SaveUser( pl );
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