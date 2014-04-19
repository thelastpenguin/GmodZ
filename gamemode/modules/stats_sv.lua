gmodz.print( ' = LOADED MODULE: stats_sv.lua = ' );

gmodz.hook.Add("PlayerDeath",function( pl, infl, attacker ) 
	pl:SetUData('Deaths', pl:GetUData('Deaths',0) + 1 );
	
	if not IsValid( attacker ) or not attacker:IsPlayer() then return end
	if pl:IsBandit( ) then
		attacker:SetUData('KilledBandits', pl:GetUData('KilledBandits', 0 ) + 1 );
		attacker:AddKarma( 10 );
	else
		attacker:SetUData('KilledCivilians', pl:GetUData('KilledCivilians', 0 ) + 1 );
		attacker:AddKarma( -5 );
	end
end);

gmodz.hook.Add('OnNPCKilled', function( npc, killer, wep )
	if not killer:IsPlayer() then return end
	killer:SetUData( 'KilledZombies', killer:GetUData('KilledZombies',0) + 1 );
end);


timer.Create( 'gmodz_timeplayed', 60, 0, function()
	for k,v in pairs( player.GetAll() )do
		v:SetUData('TimePlayed', v:GetUData('TimePlayed') + 60 );
	end
end);