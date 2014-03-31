gmodz.chat = {};

-- SEND THE GIVEN MESSAGE TO EVERYONE
gmodz.chat.broadcast = function( ... )
	for k,v in pairs( player.GetAll() ) do
		v:ChatPrintEx( ... );
	end
end
gmodz.chat.broadcastTeam = function( t, ... )
	for k,v in pairs( player.GetAll() ) do
		if v:Team() ~= t then continue end
		v:ChatPrintEx( ... );
	end
end


gmodz.hook.Add( 'PlayerSay', function( pl, text, public )
	if string.sub( text, 1, 3 ) == '// ' then
		gmodz.chat.broadcast( Color(100,100,100),'[G] ', pl ,color_white,': ', string.sub( text, 4 ) );
		return '';
	else
		local msg = { pl, color_white, ': ', text};
		local plpos = pl:GetPos();
		for k,v in pairs( player.GetAll() )do
			if plpos:Distance( v:GetPos() ) < 1600 then
				v:ChatPrintEx( unpack( msg ) );	
			end
		end
		return ''
	end
end)