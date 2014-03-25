local gmodz = gmodz;

--
-- THINK
--
function GM:Think()
	gmodz.hook.Call( 'Think' );
end

--
-- RENDER SCREEN SPACE EFFECTS
--
function GM:RenderScreenspaceEffects( ... )
	return gmodz.hook.Call( 'RenderScreenspaceEffects', ... );
end

--
-- POST DRAW OPAQUE RENDERABLES
--
function GM:PostDrawOpaqueRenderables( ... )
	return gmodz.hook.Call( 'PostDrawOpaqueRenderables', ... );
end
function GM:PostDrawTranslucentRenderables( ... )
	return gmodz.hook.Call( 'PostDrawTranslucentRenderables', ... );
end

-- 
-- SHOULD DRAW LOCAL PLAYER
-- 
function GM:ShouldDrawLocalPlayer( ... )
	return gmodz.hook.Call( 'ShouldDrawLocalPlayer', ... );
end

--
-- ON ENTITY CREATED
--
function GM:OnEntityCreated( ... )
	gmodz.hook.Call('OnEntityCreated', ... );
end

--
-- SPAWN MENU OPEN
--
function GM:OnSpawnMenuOpen( )
	gmodz.OpenInventoryMenu( );
end

function GM:OnSpawnMenuClose( )
	gmodz.CloseInventoryMenu( );
end

--
-- PLAYER BIND PRESSED
--
function GM:PlayerBindPress( ply, bind, pressed )
	return gmodz.hook.Call('PlayerBindPress', ply, bind, pressed );
end

function GM:PrePlayerDraw( pl )
	if pl == LocalPlayer() then
		pl:SetAngles( Angle(0,math.sin( CurTime() ) * 60, 0 ) )	
	end
end

-- HIDE THE DEFAULT MESSAGES
function GM:HUDItemPickedUp( itemName ) return true end
function GM:HUDAmmoPickedUp( itemName, amount ) return true end
function GM:HUDDrawPickupHistory( ) return true end

-- DRAWING HOOKS.
function GM:PostRenderVGUI( ... ) gmodz.hook.Call( 'PostRenderVGUI', ... ); end
function GM:HUDPaintBackground( ... ) gmodz.hook.Call( 'HUDPaintBackground', ... ); end

function GM:HUDShouldDraw( ... ) return gmodz.hook.Call( 'HUDShouldDraw', ... ) ~= false end


--
-- WEIRD HOOKS...
--
timer.Create( 'gmodz_nwready', 1, 1, function()
	-- tell the server we're ready for data.
	net.Start( 'gmodz_nwready' );
	net.SendToServer( );
	
end);



--
-- HANDS
--
function GM:PostDrawViewModel( vm, ply, weapon )
	if ( weapon.UseHands || !weapon:IsScripted() ) then
		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
	self.BaseClass:PostDrawViewModel( vm, ply, weapon );
end
