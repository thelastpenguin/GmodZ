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



--
-- WEAPON UTILS
--
local getSVec = gmodz.Memoize( function( s )
	return Vector( s, s, s );
end );

function Player:TraceLine(distance, mask, filter, start)
	start = start or self:GetShootPos()
	return util.TraceLine({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask})
end

function Player:TraceHull(distance, mask, size, filter, start)
	start = start or self:GetShootPos()
	return util.TraceHull({start = start, endpos = start + self:GetAimVector() * distance, filter = filter or self, mask = mask, mins = getSVec( -size ), maxs = getSVec( size )})
end

function Player:DoubleTrace(distance, mask, size, mask2, filter)
	local tr1 = self:TraceLine(distance, mask, filter)
	if tr1.Hit then return tr1 end
	if mask2 then
		local tr2 = self:TraceLine(distance, mask2, filter)
		if tr2.Hit then return tr2 end
	end

	local tr3 = self:TraceHull(distance, mask, size, filter)
	if tr3.Hit then return tr3 end
	if mask2 then
		local tr4 = self:TraceHull(distance, mask2, size, filter)
		if tr4.Hit then return tr4 end
	end

	return tr1
end

function Player:MeleeTrace(distance, size, filter, start)
	return self:TraceHull(distance, MASK_SOLID, size, filter, start)
end