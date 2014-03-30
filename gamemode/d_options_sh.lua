if CLIENT then
	gmodz.createSetting( 'viewmode', { defval = 0 } );
	gmodz.createSetting( 'deathmode', { defval = 1 } );
	gmodz.createSetting( 'gui_scale', { defval = 1 } );
	
	gmodz.hook.Add( 'F4', function( )
		if gmodz.getVar( 'viewmode' ) == 0 then
			gmodz.setVar( 'viewmode', 1 );
		else
			gmodz.setVar( 'viewmode', 0 );
		end
	end);
elseif SERVER then
	
	
end