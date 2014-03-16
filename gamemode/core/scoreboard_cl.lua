local scoreboard;
function GM:ScoreboardShow( )
	scoreboard = vgui.Create( 'gmodz_scoreboard', self );
	scoreboard:SetSize( ScrH()*0.6, ScrH()*0.8 );
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
	self:MakePopup();
	self:SetKeyBoardInputEnabled( false );
	
	local scroller = vgui.Create( 'DScrollPanel', self );
	scroller:SetSize( self:GetSize() );
	scroller:SetPos( 0, 0 );

	-- MODIFY THE SCROLLBAR
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
	local w, h = self:GetSize();
	self.title:CenterHorizontal( );
	self.subtitle:SetPos( 0, self.title:GetTall() );
	self.subtitle:CenterHorizontal( );
	
	self.scroller:SetPos( 0, self.title:GetTall()+self.subtitle:GetTall() );
	self.scroller:SetSize(w,h-self.title:GetTall()-self.subtitle:GetTall());
	
	local y = 0;
	local pw = self.scroller:GetCanvas():GetWide();
	for k,v in pairs( self.pListPlayers )do
		v:SetSize( pw, 64*gmodz.ScrScale )
		v:SetPos( 0, y );
		y = y + v:GetTall() + 5;
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
	self.pName:SetFont( 'GmodZ_Font28');
	self.pName:SizeToContents( );
	
	if pl:IsAdmin( ) then
		local rank = Label(pl:IsSuperAdmin() and '[SA]' or '[A]', self );
		rank:SetFont( 'GmodZ_Font28');
		rank:Dock( RIGHT );
		rank:SetTextColor( Color(255,0,0));
	end
end
function PANEL:PerformLayout( )
	self:SetTall( self.pName:GetTall() + 10 );
	self.pName:SetPos( 10, 0 );
	self.pName:CenterVertical( );
end
local bgColor = Color(100,100,100,200);
function PANEL:Paint( w, h )
	draw.RoundedBox( 16, 0, 0, w, h, bgColor )
end
vgui.Register( 'gmodz_scoreboard_row', PANEL );