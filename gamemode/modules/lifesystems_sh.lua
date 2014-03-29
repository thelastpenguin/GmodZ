if SERVER then
	--
	-- LIFE SYSTEMS.
	--
	timer.Create( 'gmodz_lifesystems', 10, 0, function()
		local mw, mf = gmodz.cfg.max_water, gmodz.cfg.max_food;
		local mh = gmodz.cfg.starting_health;
		for k,pl in pairs( player.GetAll())do
			
			local rate = pl:GetVelocity():Length() > 30 and 2 or 1;
			
			local w, f = pl:GetUData( 'water', 0 ), pl:GetUData( 'food', 0 );
			local fw, ff = w / mw, f / mf ;
			if f <= 0 then
				pl:TakeDamage( math.random(2,3), NULL, NULL );
			else
				pl:SetUData( 'food', f - rate);
			end
			
			if w <= 0 then
				pl:TakeDamage( math.random(2,3), NULL, NULL );
			else
				pl:SetUData( 'water', w - rate );
			end
			
			if fw > 0.8 and ff > 0.8 and pl:Health() < mh then
				pl:SetHealth( math.Clamp( pl:Health() + math.random(4,6), 0, mh ) );
				pl:SetUData( 'food', f - rate*2);
				pl:SetUData( 'water', w - rate*2);
			end
		end
	end);
	
	util.AddNetworkString( 'gmodz_syncstamina' );
	local function syncStamina( pl, stamina, delta )
		print('Syncing change in stamina!');
		net.Start( 'gmodz_syncstamina' );
			net.WriteInt( stamina, 8 );
			net.WriteInt( delta, 8 );
		net.Send( pl )
	end
	
	local function updateStamina( pl, stamina, delta )
		pl.stamina = stamina; 
		if pl.stamina_delta ~= delta then
			pl.stamina_delta = delta;
			syncStamina( pl, stamina, delta );
		end
	end
	
	local speedfast = gmodz.cfg.speedrun ;
	local speedwalk = gmodz.cfg.speedwalk;
	timer.Create( 'gmodz_stamina', 0.2, 0, function()
	
		for _, pl in pairs( player.GetAll() )do
			local s, d = pl.stamina or 100, 0 ;
			if pl:KeyDown( IN_SPEED ) then
				if s > 0 then
					s = math.Clamp( s - 2, 0, 100 );
					d = -2;
					
					if pl:GetRunSpeed() ~= speedfast then pl:SetRunSpeed( speedfast ) end
				else
					s = 0;
					d = 0;
					
					if pl:GetRunSpeed() ~= speedwalk then pl:SetRunSpeed( speedwalk ); end
				end
				updateStamina( pl, s, d );
			else
				if s < 100 then
					s = s + 1;
					d = 1;
				else
					s = 100;
					d = 0;
				end
				updateStamina( pl, s, d );
			end
		end	
	end);
	
	-- 
	-- REFIL LIFE RESOURCES ON PLAYER SPAWN. 
	--	note: this needs to be prevented from overriding mysql loaded data.
	gmodz.hook.Add( 'PlayerDeath', function( pl )
		pl:SetUData( 'water', gmodz.cfg.max_water );
		pl:SetUData( 'food', gmodz.cfg.max_food );
		pl:SetUData( 'stamina', 100 );
	end);
	
	--
	-- CONSOLE COMMAND TO DRINK WATER
	--
	concommand.Add( '_gmodz_drinkwater', function( pl )
		if pl:WaterLevel() >= 1 then
			pl:SetUData( 'water', gmodz.cfg.max_water );
		end	
	end);

else
	local LocalPlayer = _G.LocalPlayer ;
	-- PROMPT
	local function canDrink( )
		return LocalPlayer():WaterLevel() >= 1 ;
	end
	
	-- HUD PROMPT: Drink Water
	gmodz.hook.Add( 'hud_prompt', function()
		if canDrink() then
			return 'Press \'E\' to drink water';
		end
	end);
	
	-- BIND DETECT: Drink Water
	gmodz.hook.Add('PlayerBindPress', function( pl, bind )
		if bind == '+use' and canDrink() then
			LocalPlayer():ConCommand( '_gmodz_drinkwater\n' );
		end
	end);
	
	--
	-- DRAW STAMINA
	--
	do
		local lastalpha = 0;
		local stamina = 100;
		local delta = 0;
		local sf = 0;
		local ScrW, ScrH, Lerp, FrameTime, surface = ScrW, ScrH, Lerp, FrameTime, surface ;
		gmodz.hook.Add('HUDPaintBackground',function()
			sf = Lerp( FrameTime()*5, sf, stamina / 100 );
			if stamina ~= 100 then
				lastalpha = Lerp( FrameTime()*10, lastalpha, 1 );
			else
				lastalpha = Lerp( FrameTime()*10, lastalpha, 0 );
			end
			if lastalpha < 0.05 then return end
			
			local w, h = ScrW()*0.3, 22;
			local ox, oy = ScrW()*0.5, ScrH()*0.05
			
			draw.RoundedBox( 8, ox - w*0.5, oy, w, h, Color(0, 0, 0, 200*lastalpha), true, false, true, false );
			
			if sf > 0.02 then
				draw.RoundedBoxEx( 8, ox - w*0.5, oy, w*sf, h, Color(200,150,0,255*lastalpha), true, false, true, false );
			end
			draw.SimpleText( 'STAMINA: '..math.Round( stamina ), 'GmodZ_Font22', ox, oy, Color(255,255,255,255*lastalpha), TEXT_ALIGN_CENTER );
		end);
		
		timer.Create( 'gmodz_stamina', 0.1, 0, function()
			stamina = math.Clamp( stamina + delta*0.5, 0, 100 );	
		end);
		
		net.Receive( 'gmodz_syncstamina', function()
			stamina = net.ReadInt( 8 );
			delta = net.ReadInt( 8 );	
		end);
	end
end
