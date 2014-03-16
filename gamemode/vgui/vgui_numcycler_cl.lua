local PANEL = {};
function PANEL:Init( )
	self.lblValue = Label('-1', self );
	self.lblValue:SetFont( 'GmodZ_Font3D32' );	
	
	self.butUP = vgui.Create( 'gmodz_numcycler_butUP', self );
	self.butDOWN = vgui.Create( 'gmodz_numcycler_butDOWN', self );

	self:SetValue( 0 );
end
function PANEL:SetValue( val )
	self.val = val;
	self.lblValue:SetText( tostring( val ) );
	self.lblValue:SizeToContents( );
	if val == self.max then
		self.butUP:SetMouseInputEnabled( false );
		self.butUP:SetAlpha(30);
	else
		self.butUP:SetAlpha(255);
		self.butUP:SetMouseInputEnabled( true );
	end
	if val == self.min then
		self.butDOWN:SetMouseInputEnabled( false );
		self.butDOWN:SetAlpha(30);
	else
		self.butDOWN:SetAlpha(255);
		self.butDOWN:SetMouseInputEnabled( true );
	end
	
	self:InvalidateLayout( true );
end
function PANEL:SetRange( val1, val2 )
	self.max = val2;
	self.min = val1;
end
function PANEL:GetValue( )
	return self.val;
end
function PANEL:SetFont( f )
	self.lblValue:SetFont( f );
end
function PANEL:OnMousePressed( )
	print("SWAGGER?");
end
function PANEL:PerformLayout( )
	local w, h = self:GetSize( );
	self.lblValue:SetPos( w*0.3-self.lblValue:GetWide()*0.5, (h-self.lblValue:GetTall())*0.5 );
	
	self.butUP:SetSize( h*0.4, h*0.4 );
	self.butUP:SetPos( w*0.75-self.butUP:GetWide()*0.5, h*0.45-self.butUP:GetTall())

	self.butDOWN:SetSize( h*0.4, h*0.4 );
	self.butDOWN:SetPos( w*0.75-self.butUP:GetWide()*0.5, h*0.55 )
end
vgui.Register( 'gmodz_numcycler', PANEL );



-- BUTTON UP
local PANEL = {};
function PANEL:Init( )
	self.poly = {{},{},{}}
end
function PANEL:PerformLayout( )
	local p = self.poly;
	local w, h = self:GetSize();
	p[1].x, p[1].y = 0    , h;
	p[2].x, p[2].y = w*0.5, 0;
	p[3].x, p[3].y = w    , h;
end
function PANEL:OnMousePressed( )
	print("INCREASE...")
	local p = self:GetParent();
	p:SetValue( p:GetValue() + 1 );
end
function PANEL:Paint( w, h )
	surface.SetDrawColor(255,255,255,200);
	draw.NoTexture( );
	surface.DrawPoly( self.poly );
end
vgui.Register( 'gmodz_numcycler_butUP', PANEL );




-- BUTTON DOWN
local PANEL = {};
function PANEL:Init( )
	self.poly = {{},{},{}}
end
function PANEL:PerformLayout( )
	local p = self.poly;
	local w, h = self:GetSize();
	
	p[1].x, p[1].y = 0    , 0;
	p[2].x, p[2].y = w    , 0;
	p[3].x, p[3].y = w*0.5, h;
end
function PANEL:OnMousePressed( )
	local p = self:GetParent();
	p:SetValue( p:GetValue() - 1 );
end
function PANEL:Paint( w, h )
	surface.SetDrawColor(255,255,255,200);
	draw.NoTexture( );
	surface.DrawPoly( self.poly );
end
vgui.Register( 'gmodz_numcycler_butDOWN', PANEL );