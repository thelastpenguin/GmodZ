local Player = FindMetaTable( 'Player' );
local Entity = FindMetaTable( 'Entity' );


--
-- IS PLAYER USING WEAPON SCOPE
--
function Player:IsAimingWeapon( )
	local wep = self:GetActiveWeapon( );
	return wep.dt and wep.dt.Status == FAS_STAT_ADS or false;
end

function Player:IsReady( )
	return self:GetNWBool('gmz_ready') or false;
end

-- CUSTOM AMMO SYSTEM
if not Player._OldGetAmmoCount then Player._OldGetAmmoCount = Player.GetAmmoCount end
if not Player._OldRemoveAmmo then Player._OldRemoveAmmo = Player.RemoveAmmo end
function Player:GetAmmoCount( ammo_type )
	local inv = self:GetInv( 'inv' );
	if not inv then return self:_OldGetAmmoCount( ammo_type ); end
	
	return inv:CountItems( function( s )
				return s.meta.ammo_type == ammo_type;
		end);
end
function Player:RemoveAmmo( count, ammo_type )
	local inv = self:GetInv( 'inv' );
	if not inv then return self:_OldRemoveAmmo( ammo_type ); end
	
	for k,v in pairs( inv.stacks )do
		if v.meta.ammo_type == ammo_type then
			local c = v:GetCount( );
			if c > count then
				c = c - count;
				v:SetCount( c );
				inv:SyncSlot( k );
			else
				count = count - c;
				inv:SetSlot( k, nil, nil );
			end
		end
	end
end



do
	local bpos, blookup = Entity.GetBonePosition, Entity.LookupBone ;
	function Player:HeadPos( )
		return bpos( self, blookup( self, "ValveBiped.Bip01_Head1") or 1000 );
	end
end

-- SAFE ZONE
function Player:InSafezone( )
	return self:GetNWBool( 'gmodz_sz', false );
end