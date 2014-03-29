--
-- DRAWING UTILITIES
-- 
local matTile = Material( 'gmodz/gui/concrete/tile.png');
local matFrame = Material( 'gmodz/gui/concrete/border.png' );
local matBackground = Material( 'gmodz/gui/concrete/background.png' );
local matSelected = Material( 'gmodz/gui/concrete/borderselected.png' );

local function draw_tile( x, y, w, h )
	surface.SetMaterial( matTile )
	surface.DrawTexturedRect( x, y, w, h );
end
local function draw_selected( x, y, w, h )
	surface.SetMaterial( matSelected );
	surface.DrawTexturedRect( x, y, w, h );
end
local function draw_background( x, y, w, h )
	surface.SetMaterial( matBackground );
	surface.DrawTexturedRect( x, y, w, h );
end
local function draw_frame( x, y, w, h )
	surface.SetMaterial( matFrame );
	surface.DrawTexturedRect( x, y, w, h );
end


-- lolz locals.
local activeSlot = 0;
local lastSwitch = 0;
local animDelay = 2;
local animLength = 1;

--
-- HOTBAR PANEL USING ELEMENTS FROM VGUI_INVENTORY
--

-- THE HOTBAR
local PANEL = {};
function PANEL:Init( )
	
	self.inv = LocalPlayer():GetInv( 'inv' );
	if not self.inv then
		gmodz.print("ERROR. PLAYER INVENTORY ISN'T LOADED YET!");
		Label( 'INVENTORY HASN\'T LOADED YET!', self ):Center();
		return ;
	end
	
	self.slots = {};
	for i = 0, self.inv.w-1 do
		local p = vgui.Create( 'gmodz_hotbar_slot', self );
		p:SetIndex( i );
		
		self.slots[i] = p;
	end
	
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	self:SetSize( ScrW(), ScrH()*0.15*gmodz.getVar( 'gui_scale' ) );
	self:SetPos( 0, ScrH() - self:GetTall() - 5 );
	
	local mw, mh = self:GetSize();
	
	local width = 0;
	local padding = 5;
	for k,v in pairs( self.slots )do
		v:PerformLayout( );
		width = width + v:GetWide() + padding;
	end
	
	
	local x = (self:GetWide()-width)*0.5;
	for i = 0, self.inv.w - 1 do
		local p = self.slots[i];
		p:SetPos( x, mh - p:GetTall() );
		x = x + p:GetWide() + padding;
	end

end
function PANEL:Paint(w,h)
	local t = math.Clamp( CurTime() - lastSwitch, 0, animLength );
	local f = 1 - t / animLength;
	if f == 0 then self:Remove() return end
	self:SetAlpha( f*255 );
end
vgui.Register( 'gmodz_hotbar', PANEL );

-- A SLOT ON THE HOTBAR...
local PANEL = {};
function PANEL:Init( )
	
end
function PANEL:SetIndex( index )
	self.index = index;
	self.label = Label( tonumber( self.index + 1 ), self );
	
	self.icon = vgui.Create('gmodz_inv_stackicon', self );
	self.icon:SetStack( self:GetParent().inv:GetSlot( index ) );
	self:InvalidateLayout( true );
	
end
function PANEL:PerformLayout( )
	local p = self:GetParent();
	local s = self.index == activeSlot and p:GetTall() or p:GetTall()*0.8;
	self:SetSize( s, s );
	self.icon:SetSize( self:GetSize() );
	
	if self.index == activeSlot then
		self.label:SetColor(Color(255,255,255));
		self.label:SetFont( 'GmodZ_KG_64' );
	else
		self.label:SetColor(Color(200,200,200));
		self.label:SetFont( 'GmodZ_KG_32' );
	end
	self.label:SizeToContents();
	self.label:SetPos(5,0);
end
function PANEL:Paint( w, h )
	
	if self.index == activeSlot then
		surface.SetDrawColor(255,255,255,255);
		draw_background(0,0,w,h);
		surface.SetDrawColor(255,255,255);
		draw_frame( 0,0,w,h )
	else
		surface.SetDrawColor(180,180,180);
		draw_tile(0,0,w,h);
	end
end
vgui.Register( 'gmodz_hotbar_slot', PANEL );

--
-- UTILITY
--

local pHotbar = nil;
local function ShowHotbar()
	lastSwitch = CurTime() + animDelay;
	if not ValidPanel( pHotbar ) then
		pHotbar = vgui.Create( 'gmodz_hotbar' );
	end
	pHotbar:InvalidateLayout( true );
end
local function HideHotbar()
	pHotbar:Remove( );
end




--
-- HANDLE USER INPUT
--

local function equipSlot( slotid )
	surface.PlaySound( 'weapons/ammopickup.wav' )
	timer.Create('gmodz_equipslot',0.3,1,function()
		net.Start( 'gmodz_hotbar_equipslot' );
			net.WriteUInt( slotid, 16 );
		net.SendToServer( );
	end);
end

local function nextItem( )
	-- load inventory data.
	local inv = LocalPlayer():GetInv('inv'); -- get our primary inventory.
	if not inv then return end
	local width = inv.w;
	
	-- increment the slot.
	if activeSlot == width - 1 then
		activeSlot = 0;
	else
		activeSlot = activeSlot + 1;
	end
	
	equipSlot( activeSlot );
	ShowHotbar();
end

local function prevItem( )
	-- load inventory data.
	local inv = LocalPlayer():GetInv('inv'); -- get our primary inventory.
	if not inv then return end
	local width = inv.w;
	-- increment the slot.
	if activeSlot == 0 then
		activeSlot = width - 1;
	else
		activeSlot = activeSlot - 1;
	end
	
	-- equip the item in the given slot.
	equipSlot( activeSlot );
	ShowHotbar();
end


gmodz.hook.Add('PlayerBindPress', function( pl, bind, pressed )
	if not pl:Team() == TEAM_ACTIVE then return end
	
	if not pressed then return end
	if bind == 'invprev' then
		gmodz.print("Inventory previous slot...");
		prevItem( );
		return true ;
	elseif bind == 'invnext' then
		gmodz.print("Inventory next slot...");
		nextItem( );
		return true ;
	elseif string.sub( bind, 1, 4 ) == 'slot' then
		activeSlot = tonumber( bind[5] - 1 );
		equipSlot( activeSlot );
		ShowHotbar( );
		return true ;
	end
end);