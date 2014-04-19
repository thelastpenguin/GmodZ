include("shared.lua")

function ENT:Initialize()
end

function ENT:OnRemove( )	

end

local drawLine = render.DrawLine ;
function ENT:Draw( )
	if not self.pts then return end
	
	local color ;
	if LocalPlayer():GetPos():Distance( self:GetPos() ) < self:GetRadius() then
		color = Color(0,255,0);
	else
		color = Color(0,0,255);
	end
	
	if LocalPlayer():GetNWBool( 'sz_cooldown' ) then
		color = Color(255,0,0);
	end
	
	
	local ptc = #self.pts;
	for i = 1, ptc do
		local p = self.pts[i];
		local npt = i < ptc and self.pts[i+1] or self.pts[1];
		drawLine( p, npt, color, true );
	end
	
end

do
	local segs = 80;
	function ENT:Think()
		if self.lRadius ~= self:GetRadius( ) then
			self.lRadius = self:GetRadius( );
			local r = self:GetRadius( );
			if not r then return end
			
			local pts = {};
			
			local rotang = 360/segs;
			local ang = self:GetAngles( ):Right():Angle( );
			local mpos = self:GetPos( ) + Vector(0,0,40);
			
			local minx, miny, minz, maxx, maxy, maxz = mpos.x, mpos.y, mpos.z, mpos.x, mpos.y, mpos.z;
			for i = 1, segs do
				local dpos = ang:Forward() * r; -- delta pos.
				local pos = mpos + dpos;
				
				local tr = util.TraceLine( {
						start = pos,
						endpos = pos + Vector(0,0,-1000),
						filter = function( ent ) return false end
					} )
				local ppos = tr.HitPos + tr.HitNormal*2 ;
				
				minx, miny, minz = math.min( minx, ppos.x ), math.min( miny, ppos.y ), math.min( minz, ppos.z );
				maxx, maxy, maxz = math.max( maxx, ppos.x ), math.max( maxy, ppos.y ), math.max( maxz, ppos.z );
				
				pts[i] = ppos;
				
				ang:RotateAroundAxis( ang:Up(), rotang );
			end
			
			self:SetRenderBoundsWS( Vector( minx, miny, minz ), Vector( maxx, maxy, maxz ) );
			
			self.pts = pts;
		end
	end
end


local LocalPlayer = LocalPlayer ;
gmodz.hook.Add( 'hud_prompt', function()
	if LocalPlayer():InSafezone( )then
		return 'SAFE ZONE'
	end
end);