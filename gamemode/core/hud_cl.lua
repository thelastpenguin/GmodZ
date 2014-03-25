gmodz.hook.Add('LoadComplete',function()
	local hud = vgui.Create( 'gmodz_hud', panel );
	hud:SetPaintedManually( true );
	
	-- DRAW THE MAIN HUD
	gmodz.hook.Add('HUDPaintBackground',function()
		hud:SetPaintedManually( false );
		hud:PaintManual( );
		hud:SetPaintedManually( true );
	end);
	
	-- DISABLE HEALTH GUI
	gmodz.hook.Add('HUDShouldDraw',function( n ) if n == 'CHudHealth' then return false end end );
	
	
	-- DRAW LOADING SEQUENCE OVERLAY
	vgui.Create( 'gmodz_loading' );
	
end);

-- DRAW TIP TEXT
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

