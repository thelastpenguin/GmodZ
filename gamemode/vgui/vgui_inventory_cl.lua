local matFrame = Material( 'gmodz/gui/grunge_frame_x128.png' );
local matCorners = Material( 'gmodz/gui/grunge_corners.png' );

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




local invPanels = {};
local descPanels = {};


local function InvUpdateSlot( id, index )
	gmodz.print( '[VGUI] performing inventory panel update.');
	for k, p in pairs( invPanels )do
		if not ValidPanel( p ) then
			invPanels[ k ] = nil;
			continue ;
		end
		if( p.inv.id == id )then
			p:UpdateSlot( index );
		end
	end
end
local function InvUpdate( id )
	gmodz.print( '[VGUI] performing inventory panel update.');
	for k, p in pairs( invPanels )do
		if not ValidPanel( p ) then
			invPanels[ k ] = nil;
			continue ;
		end
		if( p.inv.id == id )then
			p:UpdateContent( );
		end
	end
end

gmodz.hook.Add( 'ReceivedInventory', function( inv )
	InvUpdate( inv.id );
end )
gmodz.hook.Add( 'UpdatedInventory', function( inv, index )
	InvUpdateSlot( inv.id, index );
end);



--
-- MAIN INVENTORY PANEL
--
local PANEL = {};

function PANEL:Init( )
	self.slots = {};
end

function PANEL:GetInv()
	return self.inv;
end

function PANEL:SetInv( inv )
	self.inv = inv;
	invPanels[ self ] = self;
	
	local w, h = inv:GetSize();
	for i = 0, w*h-1 do
		local n = vgui.Create('gmodz_inv_slot', self );
		n:SetIndex( i );
		self.slots[i] = n;
	end
	
	self:UpdateContent( );
	
	self:PerformLayout( true );
	
end

function PANEL:UpdateContent( )
	local slots = self.slots;
	local w, h = self.inv:GetSize();
	local x, y = nil, nil;
	for i = 0, w*h-1 do
		slots[i]:SetStack( self.inv:GetSlot( i ) );
	end
end
function PANEL:UpdateSlot( i )
	self.slots[i]:SetStack( self.inv:GetSlot( i ) );	
end

function PANEL:PerformLayout( )
	local w, h = self.inv:GetSize();
	
	local size = math.min(
				(self:GetWide()-2)/w-2,
				(self:GetTall()-2-(self.hotbar and 5 or 0 ))/h-2
			)
	local sizePadded = size + 2;
	size, sizePadded = math.floor( size ), math.floor( sizePadded );
	
	local vOffset, hOffset = (self:GetTall() - sizePadded*h)*0.5, (self:GetWide() - sizePadded*w)*0.5;
	
	
	local x, y = nil, nil;
	for i = 0, w*h-1 do
		x = i % w;
		y = (i-x)/w;
		
		local cs = self.slots[i];
		cs:SetPos( x*sizePadded + hOffset, y*sizePadded + vOffset + ((self.hotbar and y > 0) and 5 or 0 ));
		cs:SetSize( size, size );
	end
	
end
function PANEL:EnableHotbar( )
	self.hotbar = true;
	local w, h = self.inv:GetSize();
	for i = 0, w - 1 do
		self.slots[i]:SetHotslot( true );
	end	
	self:PerformLayout();
end
function PANEL:SetSlotHoverCBack( cback )
	self.OnSlotHover = cback;
end

vgui.Register( 'gmodz_inv', PANEL, 'EditablePanel' );

--
-- INVENTORY PANEL SLOT
--
local PANEL = {};
function PANEL:Init( )
	self.icon = vgui.Create( 'gmodz_inv_stackicon', self );
	self:PerformLayout( );
	self.IsSlot = true;
end

-- GET AND SET INDEX
function PANEL:SetIndex( ind )
	self.index = ind;
end
function PANEL:Index()
	return self.index;
end

-- GET INVENTORY
function PANEL:GetInv()
	return self:GetParent():GetInv();
end

-- GET AND SET THE STACK
function PANEL:GetStack( )
	return self.stack;
end
function PANEL:SetStack( stack )
	self.stack = stack;
	if stack then
		self.icon:SetVisible( true );
	else
		self.icon:SetVisible( false );
	end
	self.icon:SetStack( stack );
	self:InvalidateLayout( true );
end

function PANEL:SetHotslot( bool )
	self.IsHotslot = true;
end

function PANEL:PerformLayout( )
	self.icon:SetSize( self:GetSize( ) );
	self.icon:InvalidateLayout( true );
end

function PANEL:Paint( w, h )
	if self.IsHotslot then
		surface.SetDrawColor( 200, 255, 200, 255);
	else
		surface.SetDrawColor( 200, 200, 200, 255);
	end
	draw_tile( 0,0,w,h );
	
	if( self:IsHovered( ) )then
		surface.SetDrawColor( 255,0,0,155 );
		draw_selected( 0,0,w,h );
	end
end

local dragIndex = nil;
local dragInv = nil;
function PANEL:OnMousePressed( keycode )
	local pDragging = gmodz.invmenu.DragGetPanel( );
	local ms = self:GetStack( );
	if not ms then return end
	
	if not ValidPanel( pDragging ) and keycode == MOUSE_LEFT then
		-- PICK UP THE CURRENTLY HOVERED PANEL.
		self:SetStack( nil );
		
		local p = gmodz.invmenu.DragSetHolding( self:GetInv(), self:Index(), ms:GetCount() );
		if p then p:SetSize(self:GetWide()*0.7, self:GetTall()*0.7) end
		return ;
	elseif not ValidPanel( pDragging ) and ms and keycode == MOUSE_RIGHT then
		-- DISPLAY A LIST OF OPTIONS TO DO WITH THIS STACK.
		local optionList = vgui.Create( 'gmodz_inv_ItemOptionList', self );
		optionList:SetSize( self:GetSize( ) );
		optionList:SetStack( self:GetStack( ) );
	end
end

function PANEL:OnMouseReleased( keycode )
	
end

function PANEL:OnCursorEntered( )
	local cback = self:GetParent().OnSlotHover;
	if( cback )then
		cback( self, self:GetStack(), self:GetInv(), self:Index() );
	end
end

vgui.Register( 'gmodz_inv_slot', PANEL );

--
-- DRAGGING ITEM STACK PANEL
--
local PANEL = {};
function PANEL:Init( )
	self:SetMouseInputEnabled( true );
end
function PANEL:SetStack( stack )
	if ValidPanel( self.icon ) then self.icon:Remove() end
	self.stack = stack;
	self.icon = vgui.Create( 'gmodz_inv_stackicon', self );
	self.icon:SetStack( stack );
	return self;
end
function PANEL:GetStack( stack )
	return self.stack;
end
function PANEL:PerformLayout( )
	self.icon:SetSize( self:GetSize() );	
end
function PANEL:Paint(w,h)
	surface.SetDrawColor(255,255,255,200);
	surface.DrawOutlinedRect(0,0,w,h);
	surface.SetDrawColor(220,220,255,10 );
	surface.DrawRect(0,0,w,h);
	
	-- drop if mouse is released.
	if not input.IsMouseDown( MOUSE_LEFT )then
		local sInv, sIndex, sStack = gmodz.invmenu.DragGetHolding( );
		local pHovered = vgui.GetHoveredPanel( );
		
		-- if we are hovered over a slot...
		if ValidPanel( pHovered ) and pHovered.IsSlot then
			-- what's in the slot?
			local ms = pHovered:GetStack( );
			
			-- stacks must have same item type in order to merge...
			if ms and ms.meta ~= sStack.meta then
				gmodz.print("[GUI] Can not merge stacks. Meta classes do not match.");
				gmodz.invmenu.DragUpdateQuantity( 0 );
				InvUpdate( sInv.id );
				return ;
			end
			
			-- actually do the drop...
			if ms then
				local qty = math.Clamp( sStack:GetCount(), 0, ms.meta.StackSize - ms:GetCount());
				if( qty == 0 )then
					gmodz.print('[GUI] Stack is already full!');
					gmodz.invmenu.DragUpdateQuantity( 0 );
					InvUpdate( sInv.id );
					return ;
				end
				sStack:SetCount( sStack:GetCount() - qty );
				
				pHovered:SetStack( ms:Copy():SetCount( ms:GetCount() + qty ) );
				gmodz.InvTransfer( sInv, sIndex, pHovered:GetInv(), pHovered:Index(), qty );
				gmodz.invmenu.DragUpdateQuantity( 0 );
			else
				self:SetStack( sStack:Copy() );
				gmodz.InvTransfer( sInv, sIndex, pHovered:GetInv(), pHovered:Index(), math.min( sStack:GetCount(), sStack.meta.StackSize ) );
				gmodz.invmenu.DragUpdateQuantity( 0 );
			end
			
			-- done droppin.
		else
			gmodz.invmenu.DropItems( sInv.id, sIndex, sStack:GetCount() );
			gmodz.invmenu.DragUpdateQuantity( 0 );
		end
	end
end
vgui.Register( 'gmodz_inv_dragging', PANEL );

--
-- ITEM OPTION LIST
--
local PANEL = {};
function PANEL:Init( )
	self.options = {};
	
end
function PANEL:AddOption( text, func )
	local p = vgui.Create( 'gmodz_inv_ItemOptionRow', self );
	p:SetOption( text, function()
		func( self:GetParent(), self:GetParent():GetStack() )
	end );
	self.options[ #self.options + 1 ] = p;	
end
function PANEL:RemoveOptions()
	for k,v in pairs( self.options )do
		v:Remove( );
		self.options[k] = nil;
	end
end
function PANEL:SetStack( stack )
	self.stack = stack;
	local stack = self.stack;
	local meta = stack.meta;
	local parent = self:GetParent( );
	local inv = parent:GetInv( );
	local pIndex = parent:Index( );
	-- ADD STACK OPTIONS
	self:AddOption( 'drop', function()
		-- DROP A CERTAIN QUANTITY.
		self.stayOpen = true;
		self:RemoveOptions( );
		
		Label('Drop Qty', self ):Dock( TOP );
		
		local counter = vgui.Create( 'gmodz_numcycler', self );
		counter:Dock( FILL );
		counter:SetSize(self:GetWide(), self:GetTall()/2 );
		counter:SetMouseInputEnabled( true );
		counter:SetRange( 1, stack:GetCount( ))
		counter:SetValue( math.floor( stack:GetCount()/2 ) );
		
		local bDrop = vgui.Create( 'DButton', self );
		bDrop:SetText('DROP');
		bDrop:SetSize( self:GetWide(),20);
		bDrop:SetTextColor( color_white );
		bDrop:SetFont('GmodZ_Font3D18');
		bDrop:Dock( BOTTOM );
		bDrop:CenterHorizontal( );
		function bDrop:Paint(w,h)
			if not self:IsHovered() then return end
			surface.SetDrawColor(255,255,255,20);
			surface.DrawRect(0,0,w,h);
		end
		function bDrop:DoClick( )
			surface.PlaySound( 'weapons/ammopickup.wav' )
			gmodz.invmenu.DropItems( inv.id, pIndex, counter:GetValue( ) );
			self:GetParent():Remove( );
		end
	end );
	
	-- USE THE STACK...
	if meta.OnUse then
		self:AddOption( 'use', function()
			surface.PlaySound( 'weapons/ammopickup.wav' )
			gmodz.invmenu.UseItem( inv.id, pIndex );
			self:Remove( );
		end );
	end
	if stack:GetCount() > 1 then
		self:AddOption( 'split', function()
			local ms = parent:GetStack( ):Copy();
			local half = math.Round( ms:GetCount()*0.5 );
			local new = ms:Copy():SetCount( ms:GetCount() - half );
			
			-- PICK UP THE CURRENTLY HOVERED PANEL.
			parent:SetStack( new );
			
			local p = gmodz.invmenu.DragSetHolding( parent:GetInv(), parent:Index(), half );
			if p then p:SetSize(parent:GetWide()*0.7, parent:GetTall()*0.7) end
			
			self:Remove( );
		end );
	end
	self:AddOption( 'cancel', function()
		self:Remove( );
	end );
	
	
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	local w, h = self:GetSize();
	h = h * 0.9;
	local height = math.Clamp( h/(#self.options), 15, h*0.33 );
	for k,v in ipairs( self.options )do
		v:SetSize( w, height );
		v:SetPos( 0, h*0.05 + (k-1) * height );
	end
end
function PANEL:Paint( w, h )
	surface.SetDrawColor(0,0,0,200);
	surface.DrawRect(0,0,w,h);
	
	local posx, posy = self:LocalToScreen(0,0);
	local mousex, mousey = gui.MousePos();
	if mousex > posx and mousey > posy and mousex < posx+w and mousey < posy+h then return end
	self:Remove( );
end
vgui.Register( 'gmodz_inv_ItemOptionList', PANEL );

--
-- ITEM OPTION ROW
--
local PANEL = {};
function PANEL:Init( )
end
function PANEL:SetOption( text, func )
	self.text = Label( text, self );
	self.text:SetFont( 'GmodZ_Font3D18' );
	self.text:SizeToContents( );
	
	self.func = func;
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	self.text:Center( );
end
function PANEL:OnMousePressed( )
	self.func( );	
end
function PANEL:Paint( w, h )
	if self:IsHovered() then
		surface.SetDrawColor(255,255,255,30);
		surface.DrawRect(0,0,w,h);
	end	
end
vgui.Register( 'gmodz_inv_ItemOptionRow', PANEL );

--
-- STACK ICON
--
local PANEL = {};
function PANEL:Init( )
	self:SetMouseInputEnabled( false );
	
	self.icon = vgui.Create('SpawnIcon', self );
	self.icon:SetMouseInputEnabled( false );
	self.count = Label('',self);
	self.count:SetFont( 'GmodZ_Font3D18' );
	self.name = Label('',self);
	self.name:SetFont( 'GmodZ_Font3D12' );
end
function PANEL:SetStack( stack )
	self.stack = stack;
	
	if stack then
			
		self.count:SetText( stack:GetCount( ) );
		self.count:SizeToContents( );
		
		self.name:SetText( stack.meta.PrintName );
		self.name:SizeToContents( );
		
		self.count:SetVisible( true );
		self.name:SetVisible( true );
		self.icon:SetVisible( true );
		
	else
		
		self.count:SetVisible( false );
		self.name:SetVisible( false );
		self.icon:SetVisible( false );
		
	end
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	local w, h = self:GetSize();
	
	if self.stack then
		self.icon:InvalidateLayout( true );
		self.icon:SetSize( w*1, h*1 );
		self.icon:SetModel( self.stack.meta.Model );
		self.icon:Center( );
	end
	
	self.count:SetPos( w*0.95 - self.count:GetWide(), h*0.05 );
	self.name:SetPos((w-self.name:GetWide())*0.5, h*0.97-self.name:GetTall())
end

function PANEL:Paint( w, h )
end

vgui.Register( 'gmodz_inv_stackicon', PANEL );


--
-- GUI ITEM DESCRIPTION
--
local PANEL = {};
function PANEL:Init( )
	self.desc = Label( '', self );
	self.desc:SetFont( 'GmodZ_Font3D18_OUTLINED' );
	self.desc:SetWrap( true );
	
	self.icon = vgui.Create( 'gmodz_inv_stackicon', self );
	function self.icon:Paint( w, h )
		surface.SetDrawColor(200,200,200,255);
		draw_tile( 0,0,w,h );
	end
end

function PANEL:SetStack( stack )
	if stack then
		self.stack = stack;
		self.desc:SetText( stack.meta.Desc or '' );
		self.desc:SizeToContents( );
		self:SetVisible( true );
	else
		self:SetVisible( false );
	end
	
	self.icon:SetStack( stack );
	self:InvalidateLayout( true );
end

function PANEL:PerformLayout( )
	local w, h = self:GetSize();
	self.icon:SetSize( self:GetWide(), self:GetWide() );
	self.icon:SetPos(0,0);
	self.desc:SizeToContents( );
	self.desc:SetWide( w )
	self.desc:SetPos( 0, self.icon:GetTall() + 5 );
end

function PANEL:Paint( w, h )	
end

vgui.Register( 'gmodz_stackdesc', PANEL, 'EditablePanel' );