include("shared.lua")

local cTable;
local enabled = false;
--
-- ENTITY STUFF
--

function ENT:Initialize()
end

local extraInfo = {
	{ text = 'Press E to open'}
}
function ENT:Draw()
	self:DrawModel()
	
	if cTable == self then return end
	self:DrawEntLabel( 'Crafting Table', extraInfo );
end


--
-- GUI STUFF
--

-- LOCALS
local surface = surface ;

local function calcview( pl, _pos, _ang, fov )
	local ang = cTable:GetAngles( );
	local pos = cTable:GetPos( ) + ang:Up()*100 - ang:Forward()*10;
	
	ang:RotateAroundAxis( ang:Right(), -90 );
	ang:RotateAroundAxis( ang:Right(), 10 );
	
	return pos, ang, fov
end

gmodz.hook.Add( 'CalcViewAnim', function( pl, _pos, _ang, fov )
	if not enabled then return end -- nothing to do here.
	return calcview;
end )


-- OPEN THE MENU
net.Receive( 'gmodz_craftingtbl_openmenu', function()
	cTable = net.ReadEntity( );
	enabled = true;
	
	if not IsValid( cTable ) then return end
	
	local panel = vgui.Create( 'gmodz_ctbl_menu' );
	panel:SetSize( 1000, 500 );
	gmodz.gui3d.addPanel( 'ctbl', panel );
	
end);


local PANEL = {};
function PANEL:Init( )
	self.pInv = vgui.Create( 'gmodz_inv', self );
	self.pInv:SetInv( LocalPlayer():GetInv( 'inv' ) );
	
	self.pItemList = vgui.Create( 'gmodz_ctbl_itemlist', self );
	
	self.pTitle = Label( 'CRAFTING TABLE', self );
	self.pTitle:SetFont( 'GmodZ_KG_3D32' );
	self.pTitle:SizeToContents( );
	self.pTitle:SetPos( 10, 0 );
	
	self.buttonClose = vgui.Create( 'DButton', self );
	self.buttonClose.DoClick = function()
		enabled = false;
		self:Remove( );
	end
	function self.buttonClose:Paint( ) end
	self.buttonClose:SetText('X');
	self.buttonClose:SetFont('GmodZ_Font3D48');
	self.buttonClose:SetTextColor( color_white );
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout()
	local w, h = self:GetSize( );
	
	self.buttonClose:SetPos( w - self.buttonClose:GetWide(), 0 );
	local butH = self.buttonClose:GetTall()+10;
	
	self.pInv:SetPos( 0, butH );
	self.pInv:SetSize( w*0.4, h - butH );
	
	self.pItemList:SetSize( w*0.3, h - butH );
	self.pItemList:SetPos( w*0.4, butH );
	self.pItemList:InvalidateLayout( true );
	
	
	if ValidPanel( self.recipeView ) then
		self.recipeView:SetSize( w*0.3-10, h - butH );
		self.recipeView:SetPos( w*0.7+5, butH );
		self.recipeView:InvalidateLayout( true );
	end
end

function PANEL:CalcRenderSettings( pos )
	local cTable = cTable;
	
	local ang = cTable:GetAngles( );
	ang:RotateAroundAxis( ang:Up(), -90 );
	local pos = cTable:GetPos( );
	
	local obbmaxs = cTable:OBBMaxs( );
	
	return pos + ang:Up()*obbmaxs.z, ang, 0.09;
end

function PANEL:ViewRecipe( recipe )
	if ValidPanel( self.recipeView )then
		self.recipeView:Remove( );
	end
	self.recipeView = vgui.Create( 'gmodz_ctbl_recipeview', self );
	self.recipeView:SetRecipe( recipe )
	
	self:InvalidateLayout(true);
end

function PANEL:Paint( w, h )
end

function PANEL:PaintOver( w, h )
	gmodz.invmenu.PaintDragging( );
end

vgui.Register( 'gmodz_ctbl_menu', PANEL );


--
-- RECIPE LIST
--
local PANEL = {};

local curList = nil;
function PANEL:Init( )
	curList = self;
	
	-- SCROLL PANEL.
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
	
	self.recipes = {}; -- a place to put the panels.
	
	-- done.
	self:UpdateMakable( );
end
function PANEL:UpdateMakable( )
	local s = SysTime();
	local canMake = gmodz.crafting.GetMakeable( LocalPlayer():GetInv('inv') );
	gmodz.print("Updated craftable item list in "..(SysTime()-s).." seconds.");
	
	-- remove any old list contents.
	for k,v in pairs( self.recipes )do
		self.recipes[ k ]:Remove( );
		self.recipes[ k ] = nil;
	end
	
	-- add new list contents.
	for k,v in pairs( canMake )do
		local n = vgui.Create( 'gmodz_ctbl_itemrow', self.scroller );
		n:SetRecipe( v );
		function n.DoClick( )
			self:GetParent():ViewRecipe( v );
		end
		self.recipes[ #self.recipes + 1 ] = n;
	end
	
	-- update layout since shiz changed.
	self:InvalidateLayout( true );
end

gmodz.hook.Add('UpdatedInventory', function( inv )
		timer.Create( 'invupdate', 1, 1, function()
			if ValidPanel( curList ) and inv == LocalPlayer():GetInv( 'inv' ) then
				curList:UpdateMakable( );
				lastUpdate = CurTime() + 1;
			end
		end);
	end);

function PANEL:PerformLayout( )
	self.scroller:SetSize( self:GetSize() );
	local h = 0;
	for k,v in pairs( self.recipes )do
		v:PerformLayout( );
		v:SetWide( self.scroller:GetCanvas():GetWide() );
		v:SetPos(0, h )
		h = h + v:GetTall() + 5;
	end
end

function PANEL:Paint( w, h )
end
vgui.Register( 'gmodz_ctbl_itemlist', PANEL );


-- 
-- RECIPE
-- 
local PANEL = {};

function PANEL:Init( )
	self.icons = {};
end
function PANEL:SetRecipe( recipe )
	self.recipe = recipe;
	self.label = Label( recipe:GetTitle(), self );
	self.label:SetFont( 'GmodZ_Font3D22' );
	self.label:SizeToContents( );
	
	for k,v in pairs( recipe.materials )do
		local ico = vgui.Create( 'gmodz_ctbl_stackicon', self );
		ico:SetStack( v );
		
		self.icons[#self.icons+1] = ico;
	end
	
	self:InvalidateLayout( true );	
end
function PANEL:PerformLayout()
	self.label:SetPos(10,0);
	self:SetTall( self.label:GetTall() * 2 );
	
	local w, h = self:GetSize();
	local x = w;
	for _, p in pairs( self.icons )do
		p:SetSize( h * 0.7, h*0.7 );
		local pw, ph = p:GetSize();
		x = x - pw - 3;
		p:SetPos( x, h - ph - 3 );
	end
end

do
	local background = Material( 'gmodz/gui/concrete/512x128.png' );
	function PANEL:Paint(w,h)
		if self:IsHovered( ) then
			surface.SetDrawColor(255,255,255);
		else
			surface.SetDrawColor(190,190,190);
		end
		surface.SetMaterial( background );
		surface.DrawTexturedRect(0,0,w,h);
	end
end
function PANEL:OnMousePressed( )
	
end

vgui.Register( 'gmodz_ctbl_itemrow', PANEL );



--
-- SUPPLY ICON -- CUSTOM ICON CLASS TYPE.
--
local PANEL = {};
function PANEL:Init()
	self:SetMouseInputEnabled( false );
	
end
function PANEL:SetStack( stack )
	self.stack = stack;
		
	self.icon = vgui.Create('SpawnIcon', self );
	
	local lbl = Label( stack:GetCount(), self );
		lbl:SetFont('GmodZ_Font24_OUTLINE');
		lbl:SizeToContents( );
		self.lbl = lbl;
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	self.icon:InvalidateLayout( true );
	self.icon:SetSize( self:GetSize() );
	self.icon:SetModel( self.stack.meta.Model );
	self.lbl:SetPos( (self:GetWide()-self.lbl:GetWide())*0.5, (self:GetTall()-self.lbl:GetTall())*0.5 );
end

vgui.Register( 'gmodz_ctbl_stackicon', PANEL );

--
-- CRAFT - CONFIRM GUI
--
local PANEL = {};
function PANEL:Init()
	
end
function PANEL:SetRecipe( recipe )
	self.recipe = recipe;
	
	self.pTitle = Label( recipe:GetTitle(), self );
	self.pTitle:SetFont( 'GmodZ_KG_3D48' );
	self.pTitle:SizeToContents( );
	
	-- LIST PRODUCTS...
	self.pCaptionProducts = Label('CREATES', self );
	self.pCaptionProducts:SetFont( 'GmodZ_KG_3D38' );
	self.pCaptionProducts:SizeToContents( );
	
	self.pListProducts = {};
	for k,stack in pairs( recipe.products )do
		local n = vgui.Create( 'gmodz_ctbl_matrow', self );
		n:SetStack( stack );
		n.lbl:SetFont('GmodZ_KG_3D38');
		n.lbl:SizeToContents( );
		
		table.insert( self.pListProducts, n );
	end
	
	
	-- LIST RESOURCES...
	self.pCaptionMaterials = Label('MATERIALS', self );
	self.pCaptionMaterials:SetFont( 'GmodZ_KG_3D38' );
	self.pCaptionMaterials:SizeToContents( );
	
	self.pListMaterials = {};
	for k,stack in pairs( recipe.materials )do
		local n = vgui.Create( 'gmodz_ctbl_matrow', self );
		n:SetStack( stack );
		table.insert( self.pListMaterials, n );
	end
	
	
	-- CRAFT IT!
	self.pButtonCraft = vgui.Create( 'DButton', self );
	self.pButtonCraft:SetFont( 'GmodZ_KG_3D48' );
	self.pButtonCraft:SetText('CRAFT ITEM');
	self.pButtonCraft:SetTextColor(color_white);
	
	local modeConfirm = false;
	function self.pButtonCraft:Paint( w, h )
		if self:IsHovered() then
			if input.IsMouseDown( MOUSE_LEFT ) or input.IsMouseDown( MOUSE_RIGHT )then
				surface.SetDrawColor(230,255,230,50);
			else
				surface.SetDrawColor(230,255,230,20);
			end
		else
			surface.SetDrawColor(255,255,255,10);
		end
		surface.DrawRect(0,0,w,h);
		
		if modeConfirm and not self:IsHovered( ) then
			self:SetText( 'CRAFT ITEM' );
			self:SetTextColor( color_white );
			modeConfirm = false;
		end
	end
	function self.pButtonCraft.DoClick( )
		if modeConfirm then
			net.Start( 'gmodz_craftingtbl_craft')
				net.WriteString( recipe.id );
			net.SendToServer( );
			self:Remove( );
		else
			modeConfirm = true;
			self.pButtonCraft:SetTextColor( Color(255,100,0 ));
			self.pButtonCraft:SetText( 'CONFIRM' );
		end
	end
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout()
	local w, h = self:GetSize();
	
	self.pTitle:CenterHorizontal( );
	
	local y = self.pTitle:GetTall() + 30;
	
	
	-- PRODUCTS
	self.pCaptionProducts:SetPos( 7, y );
	y = y + self.pCaptionProducts:GetTall() + 5;
	for k,v in SortedPairs( self.pListProducts )do
		v:SetSize( w, 48 );
		v:PerformLayout( );
		v:SetPos( 0, y );
		y = y + v:GetTall() + 3;
	end
	
	-- MATERIALS
	self.pCaptionMaterials:SetPos( 7, y );
	y = y + self.pCaptionMaterials:GetTall() + 5;
	for k,v in SortedPairs( self.pListMaterials )do
		v:SetSize( w, 38 );
		v:PerformLayout( );
		v:SetPos( 0, y );
		y = y + v:GetTall() + 3;
	end
	
	-- CRAFT IT!
	self.pButtonCraft:SetSize( w, 48 );
	self.pButtonCraft:SetPos(0,h-self.pButtonCraft:GetTall());
	
end
do
	local background = Material( 'gmodz/gui/concrete/256x512.png' );
	function PANEL:Paint(w,h)
		surface.SetMaterial( background );
		surface.SetDrawColor(255,255,255);
		surface.DrawTexturedRect(0,0,w,h);
	end
end
vgui.Register( 'gmodz_ctbl_recipeview', PANEL );


--
-- MATERIAL LIST ROW
--
local PANEL = {};

function PANEL:Init( )
	end

function PANEL:SetStack( stack )
	self.stack = stack;
	
	self.icon = vgui.Create( 'gmodz_ctbl_stackicon', self );
	self.icon:SetStack( stack );
	
	self.lbl = Label( stack:GetCount()..'x '..stack.meta.PrintName, self );
	self.lbl:SetFont( 'GmodZ_KG_3D32' );
	self.lbl:SizeToContents( );
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	local w, h = self:GetSize();
	self.lbl:SetPos( 10, ( h - self.lbl:GetTall() )*0.5);
	
	self.icon:SetSize( self:GetTall(), self:GetTall() );
	self.icon:SetPos( w - self.icon:GetWide(), 0 );
end
function PANEL:Paint( w, h )
	if self:IsHovered() then
		surface.SetDrawColor(200,200,200,10);
	else
		surface.SetDrawColor(200,200,200,5);
	end
	surface.DrawRect(0,0,w,h);
end
vgui.Register( 'gmodz_ctbl_matrow', PANEL );