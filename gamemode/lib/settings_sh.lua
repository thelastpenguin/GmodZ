gmodz.settings = {};

local settingData = {};
function gmodz.createSetting( name, info )
	settingData[ name ] = info
end

function gmodz.setVar( key, val )
	gmodz.settings[ key ] = val;
end

function gmodz.getVar( key )
	return gmodz.settings[ key ] or ( settingData[ key ] and settingData[ key ].defval )
end

function gmodz.saveSettings( )
	gmodz.print( '[GMODZ] Updated settings', Color(200,200,200));
	file.Write( SERVER and 'gmodz/sv/settings.txt' or 'gmodz/cl/settings.txt', gmodz.pon.encode( gmodz.settings ) );
end

function gmodz.loadSettings( )
	local succ, data = pcall( gmodz.pon.decode, file.Read( SERVER and 'gmodz/sv/settings.txt' or 'gmodz/cl/settings.txt', 'DATA' ) );
	if( succ )then
		gmodz.settings = data;
	else
		gmodz.print( '[GMODZ] Failed to load settings from gmodz_settings.txt', Color(255,0,0)  );
	end	
end
gmodz.loadSettings( );


if(SERVER)then
	concommand.Add( 'gmodz_setVar_sv', function( pl, cmd, args )
		if( IsValid( pl ) and not pl:IsSuperAdmin() and not pl:IsListenServerHost() )then
			pl:ChatPrint('You don\'t have sufficient access to do this.');
			gmodz.adminLog('Player '..pl:Name()..' attempted to run command '..cmd..'.' );
			return ;
		end
		local var = args[1];
		local val = args[2];
		val = tonumber( val ) or val; -- make it a number...
		if not var then
			gmdoz.adminLog( 'No variable entered.' );
			return ;
		end
		if not val then
			gmodz.adminLog( 'Variable \''.. var ..'\' = \''.. ( tostring( gmodz.getVar( var ) ) or 'nil' ..'\''));
			return ;
		end
		gmodz.setVar( var, val );
		gmodz.adminLog( 'Admin '..( IsValid( pl ) and pl:Name() or 'CONSOLE' )..' set variable '.. var .. ' = '.. tostring( val ) );
		gmodz.saveSettings( );
	end);
else
	concommand.Add( 'gmodz_setVar_cl', function( pl, cmd, args )
		local var, val = args[1], args[2];
		val = tonumber( val ) or val;
		
		if not var then
			gmodz.print('No variable entered.');
			return ;
		end
		if not settingData[ var ] then
			gmodz.print('Variable \''..var..'\' does not exist.' );
			return ;
		end
		if not val then
			gmodz.print( 'Variable \''.. var ..'\' = \''.. ( tostring( gmodz.getVar( var ) ) or 'nil' ..'\''));
			return ;
		end
		gmodz.setVar( var, val );
		gmodz.print('Set variable '..var..' to '..tostring( val ) );
		gmodz.saveSettings();
	end, function( cmd, arg )
		local args = string.Explode( ' ', string.sub( arg, 2 ) );
		
		if( arg[string.len( arg )] == ' ' )then
			args[#args+1] = '';
		end
		if( #args == 1 )then
			local vars = {};
			for k,v in pairs( settingData )do
				if( string.find( k, args[1] ) )then
					vars[#vars + 1 ] = cmd..' '..k ;
				end
			end
			return vars;
		end
	end);
end