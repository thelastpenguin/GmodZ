if SERVER then
	--
	-- LIFE SYSTEMS.
	--
	timer.Create( 'gmodz_lifesystems', 10, 0, function()
		for k,pl in pairs( player.GetAll())do
			
			local rate = pl:GetVelocity():Length() > 30 and 2 or 1;
			
			local w, f = pl:GetUData( 'water', 0 ), pl:GetUData( 'food', 0 );
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
			
		end
	end);
	
	-- 
	-- REFIL LIFE RESOURCES ON PLAYER SPAWN. 
	--	note: this needs to be prevented from overriding mysql loaded data.
	gmodz.hook.Add( 'PlayerSpawn', function( pl )
		pl:SetUData( 'water', gmodz.cfg.max_water );
		pl:SetUData( 'food', gmodz.cfg.max_food );
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
end
