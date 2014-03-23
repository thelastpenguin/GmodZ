-- DRAW QUAD
do
	local q = {{},{},{},{}};
	function surface.DrawQuad( x1, y1, x2, y2, x3, y3, x4, y4 )
		q[1].x, q[1].y = x1, y1;
		q[2].x, q[2].y = x2, y2;
		q[3].x, q[3].y = x3, y3;
		q[4].x, q[4].y = x4, y4;
		surface.DrawPoly( q );
	end
end

do
	local cos, sin = math.cos, math.sin ;
	local ang2rad = 3.141592653589/180
	local drawquad = surface.DrawQuad ;
	function surface.DrawArc( _x, _y, r1, r2, aStart, aFinish, steps )
		aStart, aFinish = aStart*ang2rad, aFinish*ang2rad ;
		local step = (( aFinish - aStart ) / steps);
		local c = steps;
		
		local a, c1, s1, c2, s2 ;
		
		c2, s2 = cos(aStart), sin(aStart);
		for _a = 0, steps - 1 do
			a = _a*step + aStart;
			c1, s1 = c2, s2;
			c2, s2 = cos(a+step), sin(a+step);
			
			drawquad( _x+c1*r1, _y+s1*r1, 
												_x+c1*r2, _y+s1*r2, 
												_x+c2*r2, _y+s2*r2,
												_x+c2*r1, _y+s2*r1 );
			c = c - 1;
			if c < 0 then break end
		end
	end
end

do
	local cos, sin = math.cos, math.sin ;
	local ang2rad = 3.141592653589/180
	local drawline = surface.DrawLine ;
	function surface.DrawArcOutline( _x, _y, r1, r2, aStart, aFinish, steps )
		aStart, aFinish = aStart*ang2rad, aFinish*ang2rad ;
		local step = (( aFinish - aStart ) / steps);
		local c = steps;
		
		local a, c1, s1, c2, s2 ;
		
		c2, s2 = cos(aStart), sin(aStart);
		drawline( _x+c2*r1, _y+s2*r1, _x+c2*r2, _y+s2*r2 );
		for _a = 0, steps - 1 do
			a = _a*step + aStart;
			c1, s1 = c2, s2;
			c2, s2 = cos(a+step), sin(a+step);
			
			
			drawline( _x+c1*r2, _y+s1*r2, 
												_x+c2*r2, _y+s2*r2 );
			drawline( _x+c1*r1, _y+s1*r1,
												_x+c2*r1, _y+s2*r1 );
			c = c - 1;
			if c < 0 then break end
		end
		drawline( _x+c2*r1, _y+s2*r1, _x+c2*r2, _y+s2*r2 );
	end
end