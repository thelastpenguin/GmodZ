gmodz.gui3d = {};

-- CACHES ETC
local isEnabled = false;
local panels = {};

-- VARS THAT WILL BE USED LATER.
local cPanel = nil;
local pHovered = nil;

local injectOverrides, removeOverrides = nil, nil

--
-- WRAPPER PANEL TO CATCH INPUT
--
if ValidPanel( pCatcher )then pCatcher:Remove( ) end
pCatcher = vgui.Create( 'DPanel' );
pCatcher:SetSize(ScrW(), ScrH());
pCatcher:SetKeyBoardInputEnabled( false );
function pCatcher:Paint() end
function pCatcher:OnMousePressed( ... )
	if ValidPanel( pHovered ) and pHovered.OnMousePressed then
		pHovered:OnMousePressed( ... );
	end
	if ValidPanel( pHovered ) and pHovered.DoClick then
		pHovered:DoClick( )
	end
end
function pCatcher:OnMouseReleased( ... )
	if ValidPanel( pHovered ) and pHovered.OnMouseReleased then
		pHovered:OnMouseReleased( ... );
	end
end
function pCatcher:OnMouseWheeled( ... )
	if ValidPanel( pHovered ) and pHovered.OnMouseWheeled then
		pHovered:OnMouseWheeled( ... );
	end
end
function pCatcher:OnCursorEntered( ... )
	if ValidPanel( pHovered ) and pHovered.OnCursorEntered then
		pHovered:OnCursorEntered( ... );
	end
end
function pCatcher:OnCursorExited( ... )
	if ValidPanel( pHovered ) and pHovered.OnCursorExited then
		pHovered:OnCursorExited( ... );
	end
end
function pCatcher:OnCursorMoved( ... )
	if ValidPanel( pHovered ) and pHovered.OnCursorMoved then
		pHovered:OnCursorMoved( ... );
	end
end
pCatcher:SetPopupStayAtBack( true );
	
pCatcher:SetVisible( false );


-- add panels
function gmodz.gui3d.addPanel( id, panel )
	gmodz.gui3d.delPanel( id ); -- just incase.
	
	panels[ id ] = panel;
	panel:SetPaintedManually( true );
end

-- del panels.
function gmodz.gui3d.delPanel( id )
	local p = panels[ id ];
	if( ValidPanel( p ) )then
		p:Remove( );
	end
	panels[ id ] = nil;
end

-- should we see stuff...?
function gmodz.gui3d.setEnabled( state )
	isEnabled = state;
	if( state )then
		pCatcher:MakePopup( );
		pCatcher:MoveToBack( );
		pCatcher:SetVisible( true );
	else
		pCatcher:SetVisible( false );
	end
end

-- 
-- UTILITY FUNCTIONS
--

local function CalcHoveredPanel( mousex, mousey, self )
	local w, h  = self:GetSize( );
	if( mousex < 0 or mousey < 0 or mousex > w or mousey > h ) then
		return nil;
	end
	if self:HasChildren() then
		local cldrn = self:GetChildren();
		for _, p in pairs( cldrn )do
			if not p:IsMouseInputEnabled() then continue end
			local px, py = p:GetPos( );
			local w , h  = p:GetSize( );
			local hPanel = CalcHoveredPanel( mousex - px, mousey - py, p );
			if ValidPanel( hPanel ) then return hPanel end
		end
	end
	return self;
end

local mousex, mousey = 0, 0;
do
	local vgui_new = table.Copy( vgui )
	local gui_new = table.Copy( gui );
	local vgui_old, gui_old = nil, nil;

	function injectOverrides( )
		vgui_old = _G.vgui;
		gui_old = _G.gui;
		_G.vgui = vgui_new
		_G.gui = gui_new
	end
	function removeOverrides( )
		_G.vgui = vgui_old;
		_G.gui = gui_old;
	end

	
	vgui_new.GetHoveredPanel = function()
		return pHovered;
	end
	
	gui_new.MousePos = function()
		return mousex, mousey;
	end
	gui_new.MouseX = function()
		return mousex;
	end
	gui_new.MouseY = function()
		return mousey;
	end
end

-- MATH OMG
function LPCameraScreenToVector( iScreenX, iScreenY, iScreenW, iScreenH, angCamRot, fFoV )
	local d = 4 * iScreenH / ( 6 * math.tan( 0.5 * fFoV ) )	;

	--Forward, right, and up vectors (need these to convert from local to world coordinates
	local vForward = angCamRot:Forward();
	local vRight   = angCamRot:Right();
	local vUp      = angCamRot:Up();

	--Then convert vec to proper world coordinates and return it 
	local vec = ( d * vForward + ( iScreenX - 0.5 * iScreenW ) * vRight + ( 0.5 * iScreenH - iScreenY ) * vUp );
	vec:Normalize();
	return vec;
end


--
-- THE ACTUAL WORK...
--
local rendertarget = GetRenderTarget( 'gmodz_'..tostring( {} ), 512, 512, true );
local rtMat = CreateMaterial( 'gmodz_'..tostring( {} ), 'unlitgeneric', {['$translucent'] = '1'} );

local lastHovered = nil;

local function drawPanels()
	
	local LocalPlayer = LocalPlayer();
	local view = GAMEMODE:CalcView( LocalPlayer, LocalPlayer:EyePos(), LocalPlayer:EyeAngles(), LocalPlayer:GetFOV() ) or GAMEMODE.BaseClass:CalcView( LocalPlayer, LocalPlayer:EyePos(), LocalPlayer:EyeAngles(), LocalPlayer:GetFOV() );
	if not view then return end
	
	local vOrigin = view.origin;
	local vAngle = view.angles;
	
	local x, y =  gui.MousePos( );
	local mouseDir = LPCameraScreenToVector( x, y, ScrW(), ScrH(), vAngle, view.fov/180*math.pi );
	
	injectOverrides( );
	
	pHovered = nil;
	
	for k,panel in pairs( panels )do
		cPanel = panel;
		
		if not ValidPanel( panel )then
			gmodz.gui3d.delPanel( k );
			continue ;
		end
		if not panel:IsVisible() then continue end
		local sPos, sAng, scale = panel:CalcRenderSettings( vOrigin, vAngle );
		sPos = sPos - sAng:Forward()*(panel:GetWide()*0.5*scale) - sAng:Right()*(panel:GetTall()*0.5*scale);
		
		
		local pmVec = util.IntersectRayWithPlane( vOrigin, mouseDir, sPos, sAng:Up( ) ) or Vector(0,0,0);
		
		-- Calculate the vector projection from 3d world coordinate to 2d plane.
		do
			local x, y;
			local wo = sPos; 	-- world origin.
			local wp = pmVec; -- world point coord. 
			
			local w = wp - wo; -- point translated to world orig.
			
			local ux = sAng:Forward() -- unit vector on x axis.
			local uy = sAng:Right() -- unit vector on x axis
			
			x = w:DotProduct( ux );
			y = w:DotProduct( uy );
			
			mousex = x/scale;
			mousey = y/scale;  
		end
		
		local hovered = CalcHoveredPanel( mousex, mousey, panel );
		pHovered = hovered or pHovered;
		
		
		-- do click handling
		cam.Start3D2D( sPos, sAng, scale );
			cam.IgnoreZ( true );
			
			panel:SetPaintedManually( false );
			panel:PaintManual( );
			panel:SetPaintedManually( true );
			
			cam.IgnoreZ( false );
		cam.End3D2D( );
		
	end
	
	if pHovered ~= lastHovered then
		if lastHovered and lastHovered.OnCursorExited then
			lastHovered:OnCursorExited( );
		end
		if pHovered  and pHovered.OnCursorEntered then
			pHovered:OnCursorEntered( );
		end
		lastHovered = pHovered;
	end
	
	
	removeOverrides( );
end


gmodz.hook.Add('PostDrawTranslucentRenderables',function()
	if not isEnabled then return end
	
	-- PREVENT PIXELATION
	for i = 1, 16 do
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	end
		local succ, err = pcall( drawPanels );
		if not succ then
			gmodz.print( 'FAILED TO DRAW TRANSLUCENT RENDERABLES!', Color(255,0,0) );
			print( err );
		end
	for i = 1, 16 do
		render.PopFilterMag()
		render.PopFilterMin()
	end
end);

-- 
-- DISABLE EYE BEAM WHEN DRAWING 3D2D GUI.
-- 
gmodz.hook.Add('ShouldDrawEyeBeam',function()
	if isEnabled then return false end
end);


--
-- THINK ABOUT OURSELF CUZ WE ARE SELF CENTERED
--
gmodz.hook.Add( 'Think', function()
	if isEnabled then
		local needed = false;
		for _, p in pairs( panels )do
			if p:IsVisible() then
				needed = true;
				break;
			end
		end
		if not needed then
			gmodz.print('3D GUI rendering no longer needed. Disabling 3D panel renderer.');
			gmodz.gui3d.setEnabled( false );
		end
	else
		for _, p in pairs( panels )do
			if p:IsVisible() then
				gmodz.print('Detected visible 3d panel. Enabling 3D panel renderer.');
				gmodz.gui3d.setEnabled( true );
				return ;
			end
		end
	end
end);