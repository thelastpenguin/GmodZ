gmodz.invmenu = {};

function gmodz.invmenu.DropItems( invid, slotid, qty )
	net.Start( 'gmodz_inv_dropitem' );
		net.WriteUInt( invid, 32 );
		net.WriteUInt( slotid, 16 );
		net.WriteUInt( qty, 8 );
	net.SendToServer( );
end
function gmodz.invmenu.UseItem( invid, slotid )
	gmodz.print('Using item in "'..invid..'" at slot "'..slotid..'".', Color(0,255,0));
	net.Start( 'gmodz_inv_useitem' )
		net.WriteUInt( invid, 32 );
		net.WriteUInt( slotid, 16 );
	net.SendToServer( );
end

local invmenuCalcView = gmodz.rendereffects.BuildViewCalc( 20, 20, 0, function( pl, pos, ang, fov )
	ang.p = 0;
	ang.y = ang.y + 20;
end )

local isOpen = false;
gmodz.hook.Add( 'CalcViewAnim', function()
	if isOpen then return invmenuCalcView end 
end);

function gmodz.OpenInventoryMenu( )
	gmodz.print('Opening inventory menu.');
	LocalPlayer():ConCommand( 'gmodz_holster' );
	gmodz.vgui_invpanel = vgui.Create( LocalPlayer():InSafezone() and 'gmodz_menu_invbank' or 'gmodz_menu_inventory'  );
	gmodz.gui3d.addPanel( 'inv', gmodz.vgui_invpanel );
	
	isOpen = true;
end

function gmodz.CloseInventoryMenu( )
	gmodz.print('Closing inventory menu.');
	LocalPlayer():ConCommand( 'gmodz_unholster' );
	gmodz.gui3d.delPanel( 'inv' );
	gmodz.vgui_invpanel:Remove( );
	
	isOpen = false;
end


do
	local dInv, dIndex, dStack = nil, nil, nil;
	local pDragging = nil;
	function gmodz.invmenu.DragSetHolding( inv, index, qty )
		dInv, dIndex = inv, index;
		local stack = inv:GetSlot( index );
		if not stack then
			gmodz.print("[INV-GUI] Slot at "..index.." is empty!");
			return ;
		end
		
		dStack = stack:Copy();
		dStack:SetCount( qty );
		
		pDragging = vgui.Create( 'gmodz_inv_dragging' );
		pDragging:SetStack( dStack );
		return pDragging;
	end
	function gmodz.invmenu.DragGetPanel( )
		return pDragging;
	end
	
	function gmodz.invmenu.DragClearHolding( )
		if ValidPanel( pDragging ) then
			pDragging:Remove( );
		end
		dInv, dIndex, dStack, pDragging = nil, nil, nil, nil;
	end
	
	function gmodz.invmenu.DragUpdateQuantity( qty )
		if qty == 0 then
			gmodz.invmenu.DragClearHolding( );
		else
			dStack:SetCount( qty );
			pDragging:SetStack( dStack );
		end
	end
	
	function gmodz.invmenu.DragGetHolding( )
		return dInv, dIndex, dStack;
	end
	
	function gmodz.invmenu.PaintDragging( )
		if ValidPanel( pDragging )then
			local mousex, mousey = gui.MousePos();
			local w, h = pDragging:GetSize();
			pDragging:SetPaintedManually(false);
			pDragging:PaintAt( mousex - w*0.5, mousey - h*0.5 );
			if ValidPanel( pDragging )then
				pDragging:SetPaintedManually(true);
			end
		end
	end
	
end


--
-- THE MAIN INVENTORY VIEW
--
local PANEL = {};
function PANEL:Init( )
	self:SetSize( 500, 500 );
	self.lblTitle = Label( 'INVENTORY', self );
	self.lblTitle:SetFont( 'GmodZ_3DH1' );
	self.lblTitle:SetTextColor( Color(200,200,200) );
	self.lblTitle:SizeToContents( );
	self.lblTitle:SetTall( self.lblTitle:GetTall()*0.8);
	
	self.pInv = vgui.Create( 'gmodz_inv', self );
	self.pInv:SetInv( LocalPlayer():GetInv( 'inv' ) );
	self.pInv:EnableHotbar( true );
	
	self.pDesc = vgui.Create( 'gmodz_stackdesc', self );
	self.pInv:SetSlotHoverCBack( function( p, stack )
		self.pDesc:SetStack( stack );
	end);
	
	gmodz.invmenu.pInv = self.pInv;
	gmodz.invmenu.pInvMenu = self.pInv;
end

function PANEL:PerformLayout( )
	self.lblTitle:SetPos( 0, 0 );
	self.lblTitle:CenterHorizontal( );
	
	if not ValidPanel( self.pDesc ) or not ValidPanel( self.pInv ) then return end ;
	
	self.pDesc:SetSize(self:GetWide()*0.25, self:GetTall() - self.lblTitle:GetTall() );
	self.pDesc:SetPos( self:GetWide() - self.pDesc:GetWide(), self:GetTall() - self.pDesc:GetTall() );
	
	self.pInv:SetPos( 0, self.lblTitle:GetTall() );
	self.pInv:SetSize( self:GetWide() - self.pDesc:GetWide(), self:GetTall() - self.lblTitle:GetTall() )
end
function PANEL:Paint(w,h) end
function PANEL:PaintOver( w, h )
	gmodz.invmenu.PaintDragging( );
end
function PANEL:CalcRenderSettings( pos, ang )
	local xpos = ScrW()*0.6;
	local ypos = ScrH()*0.5;
	local vecOffset = gui.ScreenToVector( xpos, ypos );
	local campos = pos + vecOffset * 30;
	
	local ang = ang
	ang.p = 90;
	ang.r = 0;
	ang.y = ang.y + 180;
	ang:RotateAroundAxis( ang:Up(), 90 )
	return campos, ang, 0.05;
end
vgui.Register('gmodz_menu_inventory', PANEL );

--
-- BANK INVENTORY VIEW
--
local PANEL = {};
function PANEL:Init( )
	self:SetSize( 900, 500 );
	self.lblTitle = Label( 'INVENTORY & BANK', self );
	self.lblTitle:SetFont( 'GmodZ_3DH1' );
	self.lblTitle:SetTextColor( Color(200,200,200) );
	self.lblTitle:SizeToContents( );
	self.lblTitle:SetTall( self.lblTitle:GetTall()*0.8);
	
	self.pInv = vgui.Create( 'gmodz_inv', self );
	self.pInv:SetInv( LocalPlayer():GetInv( 'inv' ) );
	--self.pInv:EnableHotbar( true );
	
	self.pBankTabs = vgui.Create( 'gmodz_menu_bankview', self );
	
	self.pDesc = vgui.Create( 'gmodz_stackdesc', self );
	self.pInv:SetSlotHoverCBack( function( p, stack )
		self.pDesc:SetStack( stack );
	end);
	
	gmodz.invmenu.pInv = self.pInv;
	gmodz.invmenu.pInvMenu = self.pInv;
	
	self:InvalidateLayout( true );
end

function PANEL:PerformLayout( )
	self.lblTitle:SetPos( 0, 0 );
	self.lblTitle:CenterHorizontal( );
	
	self.pDesc:SetSize(self:GetWide()*0.125, self:GetTall() - self.lblTitle:GetTall() );
	self.pDesc:SetPos( self:GetWide() - self.pDesc:GetWide(), self:GetTall() - self.pDesc:GetTall() );
	
	self.pInv:SetPos( 0, self.lblTitle:GetTall() );
	self.pInv:SetSize( self:GetWide()*0.5 - self.pDesc:GetWide()*0.5, self:GetTall() - self.lblTitle:GetTall() )
	
	self.pBankTabs:SetPos( self.pInv:GetWide(), self.lblTitle:GetTall() );
	self.pBankTabs:SetSize( self:GetWide()*0.5 - self.pDesc:GetWide()*0.5, self:GetTall() - self.lblTitle:GetTall() );
	
	self.pInv:InvalidateLayout( true );
	self.pBankTabs:InvalidateLayout( true );
end
function PANEL:Paint(w,h) end
function PANEL:PaintOver( w, h )
	gmodz.invmenu.PaintDragging( );
end
function PANEL:CalcRenderSettings( pos )
	local xpos = ScrW()*0.5;
	local ypos = ScrH()*0.5;
	local vecOffset = gui.ScreenToVector( xpos, ypos );
	local campos = pos + vecOffset * 30;
	
	local ang = LocalPlayer():GetAngles();
	ang.p = 90;
	ang.r = 0;
	ang.y = ang.y + 180;
	ang:RotateAroundAxis( ang:Up(), 90 )
	return campos, ang, 0.05;
end
vgui.Register('gmodz_menu_invbank', PANEL );



local PANEL = {};
function PANEL:Init( )
	self.tabButtons = {};
	self.pInv = vgui.Create( 'gmodz_inv', self );
	self.pInv:SetInv( LocalPlayer():GetInv( 'bank1' ) );
	self.pInv:SetSlotHoverCBack( function( p, stack )
		self:GetParent().pDesc:SetStack( stack );
	end);
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	self.pInv:SetSize( self:GetSize() );
	self.pInv:InvalidateLayout( true );
end
vgui.Register( 'gmodz_menu_bankview', PANEL );