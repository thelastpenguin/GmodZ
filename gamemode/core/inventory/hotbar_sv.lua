
util.AddNetworkString( 'gmodz_hotbar_equipslot' );
net.Receive( 'gmodz_hotbar_equipslot', function( len, pl )
	
	gmodz.playerequipslot( pl, net.ReadUInt(16) );
	
end);

gmodz.playerequipslot = function( pl, slot )
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
				local d = ( slot:GetData() or {} )
				d.clip1 = clip1;
				slot:SetData( d )
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
	else
		pl:StripWeapons();
		pl:Give( 'weapon_fists' );
	end
	pl.activeslot = stack; 
	pl.activeSlotIndex = slot;
end