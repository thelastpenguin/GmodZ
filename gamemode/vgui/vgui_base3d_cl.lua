local PANEL = {};

function PANEL:CalcRenderSettings( pos )
	local xpos = ScrW()*0.6;
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

vgui.Register( 'gmodz_base3d', PANEL, 'EditablePanel' );