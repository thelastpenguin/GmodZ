--
--
--
local PANEL = {};
function PANEL:Init( )
	self.labels = {};
end
function PANEL:AddNotice( p )
	table.insert( self.labels, p ) 
	p:SetParent( self );
	p:SetSize( self:GetWide(), 32 );
	
	self:PerformLayout( );
end

function PANEL:Think( )
	for k,v in pairs( self.labels )do
		if not ValidPanel( v )then
			table.remove( self.labels, k );
			self:Think( );
			self:PerformLayout( );
			return ;
		end
	end
end
function PANEL:PerformLayout( )
	self:SetPos( ScrW()/3, ScrH()/2 + 20 );
	self:SetSize( ScrW()/3, ScrH()/2);
	
	local yoff = 0;
	for k,v in pairs( self.labels )do
		v:SetPos( 0, yoff );
		v:CenterHorizontal( );
		yoff = yoff + v:GetTall() + 10;
	end
end
vgui.Register( 'gmodz_noticearea', PANEL );


local PANEL = {};
function PANEL:Init( )
end
function PANEL:SetIconImage( img )
	self.icon = vgui.Create( 'DImage', self );
	self.icon:SetSize( self:GetTall() - 4, self:GetTall() - 4 );
	self.icon:SetImage( img );
	self.icon:InvalidateLayout( true );
	
	
	self.icon2 = vgui.Create( 'DImage', self );
	self.icon2:SetSize( self:GetTall() - 4, self:GetTall() - 4 );
	self.icon2:SetImage( img );
	self.icon2:InvalidateLayout( true );
end
function PANEL:SetIconModel( mdl )
	self.icon = vgui.Create( 'SpawnIcon', self );
	self.icon:SetSize( self:GetTall() - 4, self:GetTall() - 4 );
	self.icon:SetModel( mdl );
	self.icon:InvalidateLayout( true );
	
	self.icon2 = vgui.Create( 'SpawnIcon', self );
	self.icon2:SetSize( self:GetTall() - 4, self:GetTall() - 4 );
	self.icon2:SetModel( mdl );
	self.icon2:InvalidateLayout( true );
end
function PANEL:SetText( txt )
	self.lbl = Label( txt, self );
	self.lbl:SetFont( 'GmodZ_KG_32' );
	self.lbl:SetColor( color_white );
	self.lbl:SizeToContents( );
end
function PANEL:SetTime( time )
	timer.Simple( time-1, function()
		if not ValidPanel( self )then return end ;
		self:AlphaTo( 0, 1, 0 );
	end);
	timer.Simple( time, function()
		if ValidPanel( self ) then self:Remove() end
	end);
end

local mat = Material( "gui/gradient" );
function PANEL:Paint( w, h )
	surface.SetDrawColor( 50,50,50,255 );
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( w*0.5, 0, w*0.5, h );
	surface.DrawTexturedRectUV( 0, 0, w*0.5, h, -0.05, 0, -0.95, 1 );
	
end

function PANEL:PerformLayout( )
	self.lbl:Center( );
	local lblx = self.lbl:GetPos() ;
	local lblw = self.lbl:GetSize();
	self.icon:SetPos( lblx + lblw + 4, 2 );
	self.icon2:SetPos( lblx - self.icon2:GetWide() - 4, 2 );
end

vgui.Register( 'gmodz_notice', PANEL );


gmodz.notice = {};

local noticearea = vgui.Create( 'gmodz_noticearea' );

function gmodz.notice.stackpickup( stack )
	local panel = vgui.Create( 'gmodz_notice' );
	noticearea:AddNotice( panel );
	panel:SetTime( 3 );
	panel:SetText( 'PICKED UP '..stack:GetCount()..'x '..stack.meta.PrintName..'! ' );
	
	if stack.meta.Material then
		panel:SetIconImage( stack.meta.Material );
	else
		panel:SetIconModel( stack.meta.Model );
	end
	
	
end
