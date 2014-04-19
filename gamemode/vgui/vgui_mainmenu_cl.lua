local PANEL = {};
local menu ;
function PANEL:Init( )
	if ValidPanel( menu )then menu:Remove( ) end
	menu = self ;
	
	self:SetSize( ScrW(), ScrH() );
	self:SetPos( 0, 0 );
	self:MakePopup( );
	self:MoveToBack( );
	
	self.header = vgui.Create( 'gmodz_mainmenu_header', self );
	self.footer = vgui.Create( 'gmodz_mainmenu_footer', self );
	
	self.header:SetSize( self:GetWide(), self:GetTall()*0.12 );
	self.header:SetPos( 0, -self.header:GetTall())
	self.header:MoveTo( 0, 0, 1, 0, 1 );
	
	self.footer:SetSize( self:GetWide(), self:GetTall()*0.12 );
	self.footer:SetPos( 0, self:GetTall() );
	self.footer:MoveTo( 0, self:GetTall() - self.footer:GetTall(), 1, 0, 1 )
	
	self.sidebar = vgui.Create( 'gmodz_mainmenu_sidebar', self );
	self.sidebar:SetSize( self:GetWide()*0.2, self:GetTall() );
	self.sidebar:MoveToBack( );
	self.sidebar:PerformLayout( );
	
	self.content = vgui.Create( 'gmodz_contentwrapper', self );
	self.content:SetSize( self:GetWide()*0.8 - 5, self:GetTall()*(1-0.12*2)-10 );
	self.content:SetPos( self:GetWide()*0.2 + 5, self:GetTall()*0.12 + 5);
	self.content:ShowPanel( 'mdlpreview', gmodz.menu.panels.modelpreview( ) );
	
	self.header:Populate();
	self.footer:Populate( );
end

function PANEL:AddOption( t, f )
	self.sidebar:AddOption( t, f );
end

function PANEL:ShowPanel( id, p )
	if isfunction( id ) then p = id; id = tostring( p ) end
	self.content:ShowPanel( id, p );
end



-- GRAPHICAL EFFECTS
local gmodz = gmodz ;
function PANEL:Think( )
	if _G.gmodz ~= gmodz then self:Remove() end
end

local matBlurScreen = Material( "pp/blurscreen" )
local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_colour" ] = 0

function PANEL:Paint( w, h )
	surface.SetDrawColor(255,255,255);
	surface.SetMaterial( matBlurScreen );
	for i = 0.33, 1, 0.33 do
		matBlurScreen:SetFloat('$blur', i*5 );
		matBlurScreen:Recompute();
		render.UpdateScreenEffectTexture( );
		surface.DrawTexturedRect( 0, 0, w, h );
	end
	
	DrawColorModify( tab );
end

vgui.Register( 'gmodz_mainmenu', PANEL, 'EditablePanel' );



--
-- HEADER
-- 
local PANEL = {};
function PANEL:Init() end
function PANEL:Populate()
	self.label = Label('GmodZ', self );
	self.label:SetFont( 'GmodZ_GRUNGE_128' );
	self.label:SizeToContents( );
	self.label:SetPos( 50, -10 );
	
	self.credits = Label( 'by TheLastPenguin', self );
	self.credits:SetFont( 'GmodZ_KG_32' );
	self.credits:SetSize( self:GetWide(), 32 );
	self.credits:SetPos( self.label:GetWide() + 70, self:GetTall() - self.credits:GetTall() - 35)
	
	local credits = {
		'created by TheLastPenguin',
		'stalker retextured by Snipa',
		'map and artwork by Hibbafrabba',
		'created for TPS Servers'
	}
	local function cycle( )
		if not ValidPanel( self )then return end
		
		self.credits:AlphaTo( 0, 1, 4 );
		self.credits:SetText( credits[1] );
		self.credits:AlphaTo( 255, 1, 0 );
		table.insert( credits, table.remove( credits, 1 ) );
		
		timer.Simple( 5, cycle );
	end
	cycle();
end
function PANEL:Paint(w,h)
	surface.SetDrawColor(0,0,0,255);
	surface.DrawRect(0,0,w,h);
end
vgui.Register( 'gmodz_mainmenu_header', PANEL );

--
-- FOOTER
--
local PANEL = {};
function PANEL:Init() end
function PANEL:Populate()
	
end
function PANEL:Paint(w,h)
	surface.SetDrawColor(0,0,0,255);
	surface.DrawRect(0,0,w,h);
end
vgui.Register( 'gmodz_mainmenu_footer', PANEL );


--
-- SIDEBAR
--
local PANEL = {};

function PANEL:Init( )
end

function PANEL:PerformLayout( )
	self.yoffset = self:GetTall()*0.20;	
end

function PANEL:AddOption( title, func )
	local butt = vgui.Create('DButton', self );
	function butt:Paint( ) end
	butt.DoClick = func;
	butt:SetPos( 0, self.yoffset );
	butt:SetText( title );
	butt:SetFont( 'GmodZ_KG_64' );
	butt:SetSize( self:GetWide(), 64 );
	self.yoffset = self.yoffset + butt:GetTall()*2;
end

function PANEL:Paint( w, h )
	surface.SetDrawColor(0,0,0,250);
	surface.DrawRect(0,0,w,h);
end
vgui.Register( 'gmodz_mainmenu_sidebar', PANEL );
