gmodz.menu = {};



--
-- SHOW MENU PANEL
--
gmodz.hook.Add( 'OpenStartMenu', function()
	local menu = vgui.Create( 'gmodz_mainmenu' );
	menu:AddOption('SPAWN', function() gmodz.menu.requestSpawn() menu:Remove() end)
	menu:AddOption('STATS', function() menu:ShowPanel( 'mdl', gmodz.menu.panels.modelpreview( ) )end );
	menu:AddOption('OPTIONS', function()  end)
	menu:AddOption('RULES', function() menu:ShowPanel( 'html', gmodz.menu.panels.rules() )  end)
	menu:AddOption('DONATE', function() menu:ShowPanel( 'html', gmodz.menu.panels.rules() ) end)
	menu:AddOption('EXIT', function() LocalPlayer():ConCommand('disconnect'); menu:Remove() end)
end);

gmodz.hook.Add('F1', function()
	local menu = vgui.Create( 'gmodz_mainmenu' );
	menu:AddOption('STATS', function() menu:ShowPanel( 'mdl', gmodz.menu.panels.modelpreview( ) )end );
	menu:AddOption('OPTIONS', function()  end)
	menu:AddOption('RULES', function() menu:ShowPanel( 'html', gmodz.menu.panels.rules() )  end)
	menu:AddOption('DONATE', function() menu:ShowPanel( 'html', gmodz.menu.panels.rules() ) end)
	menu:AddOption('CLOSE', function() menu:Remove() end)
end);


-- 
-- REQUEST SPAWN
-- 
function gmodz.menu.requestSpawn( )
	net.Start('gmodz_requestspawn');
	net.SendToServer( );
end



--
-- PANEL GEN UTILS
--
gmodz.menu.panels = {};

function gmodz.menu.panels.rules()
	local html = vgui.Create( 'DHTML' );
	html:OpenURL( 'http://www.lastpenguin.com/' );
	return html ;
end 

function gmodz.menu.panels.modelpreview( )
	local panel = vgui.Create( 'DPanel' );
	function panel:Paint(w,h) end
	
	local stats = vgui.Create( 'DPanel', panel );
	local statLabels = {};
	function stats:Paint( w, h )
		draw.RoundedBoxEx( 16, 0, 0, w, h, Color(50,50,50,220), true, false, true, false );
	end
	function stats:AddLabel( t1, t2 )
		
		local n1 = Label( t1, self );
		n1:SetFont( 'GmodZ_KG_48' );
		n1:SizeToContents( );
		
		local n2 = Label( t2, self );
		n2:SetFont( 'GmodZ_KG_48' );
		n2:SizeToContents( );
		
		n1:SetColor( Color(200,200,200) );
		n2:SetColor( Color(220,220,220) );
		
		table.insert( statLabels, {n1, n2} );
		return n1, n2;
	end
	
	local statTitle = Label( 'STATS', stats );
	statTitle:SetFont( 'GmodZ_GRUNGE_64' );
	statTitle:SizeToContents( );
	
	function stats:PerformLayout( )
		statTitle:CenterHorizontal( );
		
		local yoff = 80;
		local padding = 20;
		for k,v in ipairs( statLabels )do
			local l1, l2 = unpack( v );
			
			l1:SetPos( padding, yoff );
			l2:SetPos( self:GetWide() - l2:GetWide() - padding, yoff );
			
			yoff = yoff + math.max( l1:GetTall( ), l2:GetTall() ) + 30;
		end
	end
	
	stats:AddLabel( 'Time Played: ', (LocalPlayer():GetUData('TimePlayed') or 'n/a' ) );
	stats:AddLabel( 'Deaths: ', (LocalPlayer():GetUData('Deaths') or 'n/a' ) );
	stats:AddLabel( 'Zombies Killed: ', (LocalPlayer():GetUData('KilledZombies') or 'n/a' ) );
	stats:AddLabel( 'Civilians Killed: ', (LocalPlayer():GetUData('KilledCivilians') or 'n/a' ) );
	stats:AddLabel( 'Bandits Killed', (LocalPlayer():GetUData('KilledBandits') or 'n/a' ) );
	stats:AddLabel( 'Karma: ', (LocalPlayer():GetUData('karma') or 'n/a' ) );
	
	function panel:PerformLayout( )
		local w, h = self:GetSize();
		stats:SetSize( w * 0.3, h * 0.8 );
		stats:SetPos( w * 0.7, h * 0.1 );
		stats:InvalidateLayout( true );
	end
	
	return panel ;	
end