local NODE = {};
NODE.PrintName = 'Unknown'
NODE.Color = color_white;
NODE.zOff = 4;

do
	local vUP = Vector( 0, 0, 10 );
	local cUP = Color(255,0,0);
	local vRIGHT = Vector( 10, 0, 0 );
	local cRIGHT = Color(0,255,0);
	local vFORWARD = Vector( 0, 10, 0 );
	local cFORWARD = Color(0,0,255);
	
	local render, cam, surface = render, cam, surface
	
	local function DrawData( x, y, data )
		surface.SetTextColor(155,155,155);
		for k,v in pairs( data )do
			if type( v ) == 'table' then
				local w, h = surface.GetTextSize( k );
				surface.SetTextPos( x, y );
				surface.DrawText( k .. ' =' );
				y = y + h;
				y = DrawData( x + 10, y, v );
			else
				local text = tostring( k )..' = '..tostring( v ) ;
				local w, h = surface.GetTextSize( text );
				surface.SetTextPos( x, y );
				surface.DrawText( text );
				y = y + h;
			end
		end
		return y;
	end
	
	function NODE:Draw( node )
		local pos = node:GetPos( )
		local ang = node:GetAngles();
		render.DrawLine( pos, pos + ang:Up()*10, cFORWARD, false )
		render.DrawLine( pos, pos + ang:Right()*10, cRIGHT, false )
		render.DrawLine( pos, pos + ang:Forward()*10, cUP, false )
		
		local eyepos = EyePos();
		local dir = ( pos - eyepos );
		dir:Normalize( );
		
		local ang = dir:Angle( );
		ang:RotateAroundAxis( ang:Right(), 90 );
		ang:RotateAroundAxis( ang:Up(), -90 );
		
		cam.Start3D2D( pos, ang, 0.2 )
			cam.IgnoreZ( true );
			surface.SetFont( 'GmodZ_Font3D18_OUTLINED' );
			surface.SetTextColor( self.Color );
			
			local text = ('['..node.id..'] ')..self.PrintName;
			local w, h = surface.GetTextSize( text );
			surface.SetTextPos( 0, 0 );
			surface.DrawText( text );
			
			if pos:Distance( eyepos ) < 200 then
				surface.SetFont( 'GmodZ_Font3D12_OUTLINED' );
				DrawData( 0, h + 3, node:GetData( ) );
			end
			cam.IgnoreZ( false );
		cam.End3D2D( );
	end
end


function NODE:Cleanup( node )
	if IsValid( node.ent ) then
		node.ent:Remove( );
	end
end
function NODE:Activate( node )
	
end

medit.nodetype.register( 'base', NODE );