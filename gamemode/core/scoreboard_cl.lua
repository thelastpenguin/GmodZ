local scoreboard;
function GM:ScoreboardShow( )
	scoreboard = vgui.Create( 'gmodz_scoreboard', self );
	scoreboard:SetSize( ScrH()*0.8, ScrH()*0.8 );
	scoreboard:Center( );
	return true;
end

function GM:ScoreboardHide( )
	scoreboard:Remove( );
	return true;
end


--
-- SCOREBOARD
--
local PANEL = {};
function PANEL:Init( )
	-- MAKE IT SHOW
	self:MakePopup();
	self:SetKeyBoardInputEnabled( false );
	
	-- MODIFY THE SCROLL BAR
	local scroller = vgui.Create( 'DScrollPanel', self );
	scroller:SetSize( self:GetSize() );
	scroller:SetPos( 0, 0 );

	local scrollbar = scroller.VBar;
	local scrollbar_bg = Color( 255, 255, 255, 100 );
	local scrollbar_grip = Color( 255, 255, 255, 20 );
	function scrollbar:Paint( w, h ) end
	function scrollbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 4, 3, 0, w-6, h, scrollbar_grip );
	end
	function scrollbar.btnUp:Paint() end
	function scrollbar.btnDown:Paint() end
	
	self.scroller = scroller;
	
	-- SETUP THE TITLE
	self.title = Label('GmodZ - ALPHA', self );
	self.title:SetFont('GmodZ_KG_64');
	self.title:SizeToContents( );
	self.subtitle = Label( 'by TheLastPenguin', self );
	self.subtitle:SetFont( 'GmodZ_KG_32' );
	self.subtitle:SizeToContents( );
	
	
	-- POPULATE PLAYERS
	self.pListPlayers = {};
	for k,v in pairs( player.GetAll() )do
		local n = vgui.Create( 'gmodz_scoreboard_row', self.scroller );
		n:SetPlayer( v );
		table.insert( self.pListPlayers, n );
	end
	
	self:PerformLayout( );
end
function PANEL:PerformLayout( )
	-- LAYOUT THE TITLE
	local w, h = self:GetSize();
	self.title:CenterHorizontal( );
	self.subtitle:SetPos( 0, self.title:GetTall() );
	self.subtitle:CenterHorizontal( );
	
	-- LAYOUT THE SCROLLAREA
	self.scroller:SetPos( 0, self.title:GetTall()+self.subtitle:GetTall() );
	self.scroller:SetSize(w,h-self.title:GetTall()-self.subtitle:GetTall());
	
	
	-- LAYOUT NAMES
	local pw = self.scroller:GetCanvas():GetWide();
	local colWidth = self:GetWide()/2 ;
	local padding = 5;
	
	for k,panel in pairs( self.pListPlayers )do
		local index = k-1;
		local x = index % 2 == 0 and 0 or colWidth + padding; 
		
		panel:SetWide( colWidth - padding );
		panel:PerformLayout( );
		panel:SetPos( x, math.floor(index/2) * (panel:GetTall()+padding) );
	end
end
function PANEL:Paint( )
end
vgui.Register( 'gmodz_scoreboard', PANEL );


local PANEL = {};
function PANEL:Init( )
	
end
function PANEL:SetPlayer( pl )
	self.pl = pl;
	self.pName = Label( pl:Name(), self );
	self.pName:SetFont( 'GmodZ_Font22');
	self.pName:SizeToContents( );
	
	if pl:IsAdmin( ) then
		local rank = Label(pl:IsSuperAdmin() and '[SA]' or '[A]', self );
		rank:SetFont( 'GmodZ_Font22');
		rank:Dock( RIGHT );
		rank:SetTextColor( Color(255,0,0));
	end
end
function PANEL:PerformLayout( )
	self:SetTall( self.pName:GetTall() + 10 );
	self.pName:SetPos( 10, 0 );
	self.pName:CenterVertical( );
end

local mat = Material( 'gmodz/gui/concrete/512x128.png' );
function PANEL:Paint( w, h )
	surface.SetMaterial( mat );
	if self:IsHovered() then
		surface.SetDrawColor(255,255,255);
	else
		surface.SetDrawColor(200,200,200);
	end
	surface.DrawTexturedRect(0,0,w,h);
end
vgui.Register( 'gmodz_scoreboard_row', PANEL );