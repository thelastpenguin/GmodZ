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
	
	-- THESE GET RESET ON SPAWN
	gmodz.hook.Add( 'PlayerSpawn', function( pl )
		pl:SetUData( 'water', gmodz.cfg.max_water );
		pl:SetUData( 'food', gmodz.cfg.max_food );
	end);
	
	concommand.Add( '_gmodz_drinkwater', function( pl )
		if pl:WaterLevel() >= 1 then
			pl:SetUData( 'water', gmodz.cfg.max_water );
		end	
	end);

else
	-- PROMPT
	gmodz.hook.Add( 'hud_prompt', function()
		if LocalPlayer():WaterLevel() >= 1 then
			return 'Press \'E\' to drink water';
		end
	end);
	
	gmodz.hook.Add('PlayerBindPress', function( pl, bind )
		if bind == '+use' then
			LocalPlayer():ConCommand( '_gmodz_drinkwater\n' );
		end
	end);
end