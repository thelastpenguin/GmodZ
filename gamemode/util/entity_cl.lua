local Entity = FindMetaTable( 'Entity' );

do
	local surface, cam, Lerp, LocalPlayer = surface, cam, Lerp, LocalPlayer;
	local color_white = color_white;
	function Entity:DrawEntLabel( text, extra )
		
		if not self.anim then self.anim = 0 end
		local val
		do 
			local trace = LocalPlayer():GetEyeTrace();
			if trace.Entity == self then
				local len = trace.HitPos:Distance( trace.StartPos );
				val = len < 200 and 1 or 0;
			else
				val = 0;
			end
		end
		self.anim = Lerp( FrameTime()*4, self.anim, val );
		
		if self.anim < 0.04 then return end
		
		local pos = self:GetPos():ToScreen( );
		
		surface.SetFont( 'GmodZ_ItemNameTag' );
		
		local tw, th = surface.GetTextSize( text );
		
		local bh = th;
		cam.Start2D();
		cam.IgnoreZ( true );
		if self.anim > 0.9 then
			surface.SetDrawColor(200,225,200,55);
			surface.DrawRect(pos.x-tw*0.5-5, pos.y-bh*0.5, tw+10, bh );
			surface.SetDrawColor(0,155,0,155);
			surface.DrawOutlinedRect(pos.x-tw*0.5-5, pos.y-bh*0.5, tw+10, bh );
			
			surface.SetTextColor(255,255,255,255);
			surface.SetTextPos( pos.x-tw*0.5, pos.y-bh*0.5 );
			surface.DrawText( text );
			
			if extra then
				surface.SetFont( 'GmodZ_Font18' );
				local line, text, color;
				local x, y = pos.x, pos.y + bh*0.5;
				for i = 1, #extra do
					line = extra[i];
					text = line.text;
					color = line.color or color_white;
					surface.SetTextColor( color );
					local w, h = surface.GetTextSize( text );
					surface.SetTextPos( x - w*0.5, y );
					surface.DrawText( text );
					y = y + h;
				end
			end
			
		elseif self.anim > 0.5 then
			local prog = (self.anim-0.5)*2;
			local w, h = tw, 2+(bh-2)*prog;
			surface.SetDrawColor(200,225,200,(1-prog)*200+55);
			surface.DrawRect(pos.x-w*0.5-5, pos.y-h*0.5, w+10, h );
			surface.SetDrawColor(0,155,0,155);
			surface.DrawOutlinedRect(pos.x-w*0.5-5, pos.y-h*0.5, w+10, h );
		else
			local prog = self.anim*2;
			local w, h = prog*tw, 2;
			surface.SetDrawColor(200,225,200,255);
			surface.DrawRect(pos.x-w*0.5-5, pos.y-h*0.5, w+10, h );
		end
		cam.IgnoreZ( false );
		cam.End2D();
		
	end
end