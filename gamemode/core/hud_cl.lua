gmodz.hook.Add('LoadComplete',function()
	local hud = vgui.Create( 'gmodz_hud', panel );
	hud:SetPaintedManually( true );
	
	function GM:HUDPaintBackground( )
		hud:SetPaintedManually( false );
		hud:PaintManual( );
		hud:SetPaintedManually( true );	
		
		gmodz.hook.Call( 'HUDPaintBackground' );
	end

	function GM:HUDShouldDraw( name )
		if( name == 'CHudHealth' )then
			return false ;
		else
			return true;
		end	
	end
	
end);

local ScrW, ScrH, LocalPlayer = ScrW, ScrH, LocalPlayer ;
gmodz.hook.Add( 'HUDPaintBackground', function()
	local text = gmodz.hook.Call( 'hud_prompt' );
	if not text then return end
	
	surface.SetFont( 'GmodZ_KG_64' );
	local w, h = surface.GetTextSize( text );
	
	surface.SetTextColor(255,255,255);
	surface.SetTextPos( ( ScrW() - w )*0.5, ScrH()*0.8 - h*0.5 );
	
	surface.DrawText( text );
end);

