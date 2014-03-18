gmodz.rendereffects = {};


local gmodz = gmodz;
local LocalPlayer, math, FrameTime, Lerp = LocalPlayer, math, FrameTime, Lerp;

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
function GM:CalcView( pl, pos, ang, fov, nearZ, farZ )
	fov = 75
	
	local LocalPlayer = LocalPlayer();
	local hpos = LocalPlayer:HeadPos( );
	
	-- CUSTOM HANDLING FOR WHEN WE  ARE DEAD
	if( not LocalPlayer:Alive() )then
		-- FIRST PERSON DEATH
		if( gmodz.getVar( 'deathmode' ) == gmodz.VM_FIRSTPERSON ) then
			local ragdoll = pl:GetRagdollEntity();
			if not IsValid( ragdoll )then return end
			local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) );
			return eyes.Pos, eyes.Ang, fov;
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
		if pos:Distance( hpos ) < 10 then gmodz.firstperson = true return end ;
		gmodz.firstperson = false ;
		return {
				origin = pos,
				angles = ang,
				fov = fov
			}
	else
		local posA, angA, fovA = calcA( pl, hpos, Angle(ang.p, ang.y, ang.r), fov );
		local posB, angB, fovB = calcB( pl, hpos, Angle(ang.p, ang.y, ang.r), fov, posA, angA, fovA );
		local frac0 = 1 - frac;
		
		local pos = posA*frac0 + posB*frac;
		if pos:Distance( hpos ) < 10 then gmodz.firstperson = true return end ;
		gmodz.firstperson = false ;
		
		return {
				origin = pos,
				angles = LerpAngle( frac, angA, angB ),
				fov = fovA*frac0 + fovB*frac
			}
	end
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

gmodz.rendereffects.SetCamCalc( function( ply, pos, ang, fov )
	local view = {}
	local playerdistance = 50
	local fixeddist = 25

	local hitpos = ply:GetEyeTrace().HitPos
	local targetpos = pos
	local dist = hitpos:Distance(targetpos);
	local newpos = rotpoint(hitpos.x, hitpos.y, hitpos.z, ang:Up().x, ang:Up().y, ang:Up().z, targetpos.x, targetpos.y, targetpos.z, fixeddist/dist) 
	local newangle = Angle(ang.p, math.NormalizeAngle(ang.y - math.deg(fixeddist/dist)), ang.r)
	newangle = (hitpos - newpos):Angle()
	newpos = newpos - newangle:Forward() * playerdistance
	
	
	local tracedata = {
		start = targetpos,
		endpos = newpos, -- Vector( 0, 0, 10 )*camDist,
		filter = function() return false end,
		mins = Vector( -5, -5, -5 ),
		maxs = Vector( 5, 5, 5 )
	}
	local tRes = util.TraceHull( tracedata );
	
	return tRes.HitPos,newangle,fov
end );

/*gmodz.rendereffects.SetCamCalc( function( pl, pos, ang, fov )
	local LocalPlayer = LocalPlayer() ;
	
	local pos = LocalPlayer:HeadPos( );
	if gmodz.getVar( 'viewmode' ) == gmodz.VM_FIRSTPERSON then
		return pos, ang, fov;
	end
	
	local pitch = ang.p;
	if( pitch > 40 or pitch < -60 )then
		ang.p = math.Clamp( pitch, -60, 40 );
		ang.r = 0;
		pl:SetEyeAngles( ang );
	end
	
	local tracedata = {
		start = pos,
		endpos = pos - ang:Forward() * 80 + ang:Right()*20, -- Vector( 0, 0, 10 )*camDist,
		filter = pl,
		mins = Vector( -5, -5, -5 ),
		maxs = Vector( 5, 5, 5 )
	}
	local tRes = util.TraceHull( tracedata );
	
	return tRes.HitPos, ang, fov ;
end );
*/

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
		
		local tracedata = {
			start = pos,
			endpos = pos - ang:Forward() * offy + ang:Right()*offx + offz, -- Vector( 0, 0, 10 )*camDist,
			filter = pl,
			mins = Vector( -5, -5, -5 ),
			maxs = Vector( 5, 5, 5 )
		}
		local tRes = util.TraceHull( tracedata );
		
		
		return tRes.HitPos, ang, fov ;
	end
end

--
-- DRAW THE EYE BEAM
--
local beamTexture = Material( "cable/redlaser" )
local beamColor = Color(255,255,255,100);
gmodz.hook.Add( 'PostDrawOpaqueRenderables', function()
	if gmodz.firstperson then return end
	
	local LocalPlayer = LocalPlayer();
	
	-- FIX FAS2 ANIM GLITCH.
	local wep = LocalPlayer:GetActiveWeapon( );
	if( IsValid( wep ) and wep.Wep )then
		local vm = wep.Wep;
		vm:FrameAdvance( );
	end
	
	if( gmodz.hook.Call( 'ShouldDrawEyeBeam' ) ~= false )then
    local BonePos, BoneAng = LocalPlayer:HeadPos( );
    if( BonePos )then
			render.SetMaterial( beamTexture );
			render.DrawBeam( BonePos, LocalPlayer:GetEyeTrace().HitPos, 5, 1, 1, beamColor );
		end
	end
end );

gmodz.hook.Add( 'ShouldDrawEyeBeam', function()
	if frac > 0.5 then return false end
end);




--
-- SCREEN COLOR REALISM
--
do
	local tab = {}
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_addb" ] = 0
	
	gmodz.hook.Add( 'RenderScreenspaceEffects', function()
		local mod = 1 / ( 1 + math.pow( 2.71, - LocalPlayer():Health() / 5 + 8 ) );
		tab[ "$pp_colour_colour" ] = mod;
		DrawColorModify( tab )
		
		-- DRAW MOTION BLUR
		if( mod < 0.3 )then
			for i = 0, 0.4, 0.1 do
				DrawMotionBlur( 0.2, 0.3, 0.9*i*(1-mod)) -- DrawMotionBlur( Float Additive alpha,Float Draw alpha, Float Frame Update delay. )
			end
		end
	end );
end
