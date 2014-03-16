
util.AddNetworkString( 'gmodz_hotbar_equipslot' );
net.Receive( 'gmodz_hotbar_equipslot', function( len, pl )
	local slot = net.ReadUInt(16);
	local inv = pl:GetInv( 'inv' );
	if not inv then
		gmodz.print("ERROR PLAYER "..pl:Name().."DOESN'T HAVE A LOADED INVENTORY!!");
		return ;
	end
	
	-- PUT AWAY THE LAST WEAPON
	if pl.activeslot then
		local slot = pl.activeslot ;
		local mt = slot.meta;
		if mt.Weapon then
			local wep = pl:GetWeapon( mt.Weapon );
			if IsValid( wep ) then
				local clip1 = wep:Clip1( );
				slot:SetData( {
						clip1 = clip1
					} )
			else
				gmodz.print('ERROR PLAYER IS MISSING WEAPON... COULDN\'T PUT IT AWAY' );
			end
		end
	end
	local stack = inv:GetSlot( slot );
	if stack then
		local mt = stack.meta;
		if mt.Weapon then
			pl:StripWeapons( );
			pl:StripAmmo( );
			pl:Give( mt.Weapon );
			pl:SelectWeapon( mt.Weapon );
			local wep = pl:GetWeapon( mt.Weapon );
			pl.activewep = wep;
			
			local data = stack:GetData();
			if data and data.clip1 ~= nil then
				wep:SetClip1( data.clip1 );
			end
		end
	end
	pl.activeslot = stack;
	pl.equippedStack = stack;
end);