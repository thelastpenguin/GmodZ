
gmodz.print( ' = LOADED MODULE: movement_sh.lua = ' );
gmodz.hook.Add('Move', function( pl, move )
	if pl:Team() ~= TEAM_SURVIVER then 
		move:SetMaxSpeed( 0 );
		move:SetMaxClientSpeed( 0 );
		return ;
	end
	
	if move:GetForwardSpeed() < 0 then
		move:SetMaxSpeed( move:GetMaxSpeed()*0.7 );
		move:SetMaxClientSpeed( move:GetMaxClientSpeed()*0.7 );
	elseif move:GetForwardSpeed() == 0 then
		move:SetMaxSpeed( move:GetMaxSpeed() * 0.85 );
		move:SetMaxClientSpeed( move:GetMaxClientSpeed() * 0.85 );
	end
	
	if pl:Health() < 30 then
		local scale = pl:Health() / 30 * 0.5 + 0.5;
		move:SetMaxSpeed( move:GetMaxSpeed() * scale )
		move:SetMaxClientSpeed( move:GetMaxClientSpeed() * scale );
	end
end);