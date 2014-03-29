local PANEL = {};
function PANEL:Init( )
	self.panels = {};
	self.history = {};
end

function PANEL:ShowPanel( id, panel )
	self:Clear( );
	panel:SetMouseInputEnabled( true );
	panel:SetKeyBoardInputEnabled( true );
	panel:SetSize( self:GetSize( ) );
	panel:SetParent( self );
	panel:InvalidateLayout( true );
end
	
vgui.Register( 'gmodz_contentwrapper', PANEL, 'EditablePanel' );