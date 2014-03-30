local PANEL = {};
function PANEL:Init( )
	self:Dock( FILL );
	self:InvalidateLayout( true );
	self.text = {};
	self:MakePopup( );
	self:SetZPos( 100000 );
	
	local messages = {
		{1,'Loading...'},
		{0.5,'Networking Initalized'},
		{2,'Loading User Data'},	
		{0.5,'Precaching Models'},
		{0.5,'Precaching Textures'},
		{0.5,'Loading Nodes...'},
		{1,'Receiving Data Pack'},
		{1,'Validating Data'},
		{1,'Done'}
	}
	
	gmodz.vgui_loading_screen = true ;
	local function message( )
		if not ValidPanel( self )then return end
		if #messages == 0 then gmodz.hook.Call('OpenStartMenu' ) self:Remove() gmodz.vgui_loading_screen = false return end
		local m = table.remove( messages, 1 );
		table.insert( self.text, 1, m[2] );
		timer.Simple( (math.random()*m[1]+m[1])*1/gmodz.cfg.d_loadrate*0.5, message );
	end
	timer.Simple( 1, message );
end

function PANEL:Think()
end

function PANEL:Paint( w, h )
	surface.SetDrawColor(0,0,0)
	surface.DrawRect( 0, 0, w, h );
	
	--draw.SimpleText( String Text, String Font, Number X, Number Y, Color Color, Number Xalign, Number Yalign )
	local x, y = w*0.5, h*0.3 + 100;
	for k,v in pairs( self.text )do
		local c = 255-k*255/10;
		draw.SimpleText( v, 'GmodZ_Font32', x, y, Color(c,c,c,255), TEXT_ALIGN_CENTER );
		y = y + 40;
	end
	table.remove( self.text, 10 );
	
	local t = CurTime();
	surface.SetDrawColor(255,255,255);
	draw.NoTexture( );
	
	surface.DrawArc( w*0.5, h*0.3, 30, 35, t*30, t*30+230, 20 )
	
	surface.DrawArc( w*0.5, h*0.3, 37, 39, -t*40-140, -t*40, 20 )
	
	surface.DrawArc( w*0.5, h*0.3, 41, 46, t*80, t*80+180, 20 )
	
end

vgui.Register( 'gmodz_loading', PANEL );