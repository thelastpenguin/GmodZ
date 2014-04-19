gmodz.rendereffects = {};


local gmodz = gmodz;
local LocalPlayer, math, FrameTime, Lerp = LocalPlayer, math, FrameTime, Lerp;
local render, surface = render, surface ;

gmodz.VM_FIRSTPERSON = 0;
gmodz.VM_THIRDPERSON = 1;


--
-- CAMERA VIEW CALC SYSTEM
--
local calcA, calcB;
local frac = 0;
function gmodz.rendereffects.SetCamCalc( func )
	calcA = func;
end


-- FIRST PERSON OVER RIDE
local firstperson = false;
gmodz.hook.Add( 'ShouldDrawLocalPlayer', function()
	return not gmodz.firstperson;
end );

--
-- CALCULATE THE VIEW... At last... 
--
local angDif = math.AngleDifference

function GM:_CalcView( pl, pos, ang, fov, nearZ, farZ )
	fov = 75
	
	local LocalPlayer = LocalPlayer();
	local hpos = LocalPlayer:HeadPos( ) or Vector(0,0,0);
	
	-- CUSTOM HANDLING FOR WHEN WE  ARE DEAD
	if( not LocalPlayer:Alive() )then
		-- FIRST PERSON DEATH
		if( gmodz.getVar( 'deathmode' ) == gmodz.VM_FIRSTPERSON ) then
			local ragdoll = pl:GetRagdollEntity();
			if not IsValid( ragdoll )then return end
			local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) );
			return {
					origin = eyes.Pos,
					angles = eyes.Ang,
					fov = fov
				}
		else
			return ;
		end
	end
	
	-- Are we currently animating?
	local calc = self:CalcViewAnim( pl, hpos, ang, fov );
	local fracGoal ;
	if calc then
		fracGoal = 1;
		calcB = calc;
	else
		fracGoal = 0;
	end
	
	frac = Lerp( FrameTime()*10, frac, fracGoal );
	
	if frac < 0.01 then
		local pos, ang, fov = calcA( pl, hpos, Angle(ang.p, ang.y, ang.r), fov );
		if pos:Distance( hpos ) < 10 then gmodz.firstperson = true return  end ;
		gmodz.firstperson = false ;
		
		local tracedata = {
			start = hpos,
			endpos = pos, 
			filter = function() return false end,
			mins = Vector( -5, -5, -5 ),
			maxs = Vector( 5, 5, 5 )
		}
		local tRes = util.TraceHull( tracedata );
		
		return {
				origin = tRes.HitPos,
				angles = ang,
				fov = fov
			}
	else
		
		-- CALCULATE LERP OF VIEWS.
		local posA, angA, fovA = calcA( pl, hpos, Angle(ang.p, ang.y, ang.r), fov );
		local posB, angB, fovB = calcB( pl, hpos, Angle(ang.p, ang.y, ang.r), fov, posA, angA, fovA );
		local frac0 = 1 - frac;
		
		local pos = posA*frac0 + posB*frac;
		if pos:Distance( hpos ) < 10 then gmodz.firstperson = true return  end ;
		gmodz.firstperson = false ;
		
		-- CHECK VECTOR FOR OBSTICALS
		local ang = LerpAngle( frac, angA, angB );
		
		local tracedata = {
			start = hpos,
			endpos = pos, 
			filter = function() return false end,
			mins = Vector( -5, -5, -5 ),
			maxs = Vector( 5, 5, 5 )
		}
		local tRes = util.TraceHull( tracedata );
		
		-- RETURN
		return {
				origin = tRes.HitPos,
				angles = ang,
				fov = fovA*frac0 + fovB*frac
			}
	end
end


function GM:CalcView( ... )
	return self:_CalcView( ... ) or self.BaseClass:CalcView( ... )
end
-- lots of math... yea...

--
-- DETERMINE IF THERE IS A VIEW OVERRIDE FUNCTION
--
function GM:CalcViewAnim( pl, pos, ang, fov )
	if pl:IsAimingWeapon( ) then 
		return gmodz.rendereffects.vc_FirstPerson
	end
	return gmodz.hook.Call( 'CalcViewAnim', pl, pos, ang, fov );
end

-- USEFUL VIEW OVERRIDES
gmodz.rendereffects.vc_FirstPerson = function( pl, pos, ang, fov )
	return pos, ang, fov;
end





--
-- DEFAULT CALCULATOR FOR VIEW
--
local function rotpoint(a, b, c, u, v, w, x, y, z, t) 
    local l = math.sqrt(u*u + v*v + w*w)
    if l < 1E-9 then
        return
    end
    local u = u/l 
    local v = v/l
    local w = w/l
    local u2 = u*u
    local v2 = v*v
    local w2 = w*w
    local cost = math.cos(t)
    local minuscost = 1 - cost
    local sint = math.sin(t)

    return Vector(
    	(a*(v2 + w2) - u*(b*v + c*w - u*x - v*y - w*z)) * minuscost + x*cost + (-c*v + b*w - w*y + v*z)*sint,
    	(b*(u2 + w2) - v*(a*u + c*w - u*x - v*y - w*z)) * minuscost + y*cost + (c*u - a*w + w*x - u*z)*sint,
    	(c*(u2 + v2) - w*(a*u + b*v - u*x - v*y - w*z)) * minuscost + z*cost + (-b*u + a*v - v*x + u*y)*sint)
end

local _ang, _pos = Angle(0,0,0), Vector(0,0,0);
gmodz.rendereffects.SetCamCalc( function( ply, pos, ang, fov )
	if gmodz.getVar( 'viewmode' ) == 0 then return pos or Vector(0,0,0), ang or Angle(0,0,0), fov or 90 end
	
	local playerdistance = 50
	local fixeddist = 16
	

	local hitpos = LocalPlayer():GetEyeTrace().HitPos
	local targetpos = pos
	local dist = hitpos:Distance(targetpos);
	local newpos = rotpoint(hitpos.x, hitpos.y, hitpos.z, ang:Up().x, ang:Up().y, ang:Up().z, targetpos.x, targetpos.y, targetpos.z, fixeddist/dist) 
	local newangle = Angle(ang.p, math.NormalizeAngle(ang.y - math.deg(fixeddist/dist)), ang.r)
	newangle = (hitpos - newpos):Angle()
	newpos = newpos - newangle:Forward() * playerdistance
	
	_ang = LerpAngle( FrameTime()*20, _ang, newangle );
	_pos = LerpVector( FrameTime()*20, _pos, newpos );
	
	return _pos,_ang,fov
end );

function gmodz.rendereffects.BuildViewCalc( offx, offy, offz, postFunc )
	offz = Vector( 0, 0, offz );
	return function( pl, pos, ang, fov )
		if postFunc then postFunc( pl, pos, ang, fov ) end
		
		local pitch = ang.p;
		if( pitch > 40 or pitch < -60 )then
			ang.p = math.Clamp( pitch, -60, 40 );
			ang.r = 0;
			pl:SetEyeAngles( ang );
		end
		
		return pos - ang:Forward() * offy + ang:Right()*offx + offz, ang, fov ;
	end
end

--
-- DRAW THE EYE BEAM
--
do
	local beamTexture = Material( "cable/redlaser" )
	local beamColor = Color(255,255,255,20);
	gmodz.hook.Add( 'PostDrawOpaqueRenderables', function()
		if gmodz.firstperson then return end
		
		local LocalPlayer = LocalPlayer();
		
		-- FIX FAS2 ANIM GLITCH.
		local wep = LocalPlayer:GetActiveWeapon( );
		if( IsValid( wep ) and wep.Wep )then
			local vm = wep.Wep;
			vm:FrameAdvance( );
		end
		
	end );
end

gmodz.hook.Add( 'ShouldDrawEyeBeam', function()
	if frac > 0.5 then return false end
end);




--
-- SCREEN COLOR REALISM
--
do
	-- FIRST PASS
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0.15
	tab[ "$pp_colour_addg" ] = 0.08
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = -0.12
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0
	
	gmodz.hook.Add( 'RenderScreenspaceEffects', function()
		DrawColorModify( tab )
	end);
	
	
	-- SECOND PASS
	local tab = {}
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_addb" ] = 0
	
	
	gmodz.hook.Add( 'RenderScreenspaceEffects', function()
		local mod = 1 / ( 1 + math.pow( 2.71, - LocalPlayer():Health() / 5 + 8 ) );
		if mod > 0.4 then return end
		
		tab[ "$pp_colour_colour" ] = mod;
		DrawColorModify( tab )
		
		-- DRAW MOTION BLUR
		for i = 0, 0.4, 0.1 do
			DrawMotionBlur( 0.2, 0.3, 0.9*i*(1-mod)) -- DrawMotionBlur( Float Additive alpha,Float Draw alpha, Float Frame Update delay. )
		end
	end );
end

--
-- DRAW CAPTIONS
--
do
	local captioned = {};
	
	gmodz.hook.Add( 'PostDrawTranslucentRenderables', function()
		local LocalPlayer = LocalPlayer( );
		
		local etr = LocalPlayer:GetEyeTrace( );
		local hEnt = etr.Entity ;
		if IsValid( hEnt ) and hEnt.GetCaption then
			captioned[hEnt] = hEnt;
		end
		for k,v in pairs( captioned )do
			if IsValid( v ) then
				v:DrawEntLabel( v:GetCaption( ) );
			else
				captioned[k] = nil;
			end
		end
	end);
end

/*
hook.Add("SetupWorldFog",'gmodz',function()
	render.FogMode( MATERIAL_FOG_LINEAR ) 
	render.FogStart( 1800 )
	render.FogEnd( 2200 )
	render.FogMaxDensity( 1 )
	
	render.FogColor( 89,89,89 )

	return true
end);

hook.Add('SetupSkyboxFog','gmodz',function()
	render.FogMode( MATERIAL_FOG_LINEAR ) 
	render.FogStart( 0 )
	render.FogEnd( 1500  )
	render.FogMaxDensity( 0.99 )
	
	render.FogColor( 70,70,70 )

	return true;
end);*/