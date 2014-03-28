local gmodz, surface, render, math = gmodz, surface, render, math ;

local PANEL = {};
function PANEL:Init( )
	if( ValidPanel( gmodz_hudpanel ) )then
		gmodz_hudpanel:Remove( );
	end
	gmodz_hudpanel = self;
	
	self.healthmodel = vgui.Create( 'gmodz_healthmodel', self );
	--self.foodbar = vgui.Create( 'gmodz_foodbar', self );
	--self.waterbar = vgui.Create( 'gmodz_waterbar', self );
	
	self:InvalidateLayout( true );
end
function PANEL:PerformLayout( )
	local size = ScrH()*0.3;
	self:SetSize( size, size );
	self:SetPos( 0, ScrH() - self:GetTall() );
	
	local w, h = self:GetSize();
		
	self.healthmodel:SetSize( w, h );
	
	--self.waterbar:SetSize( w*0.05, h*0.8 );
	--self.foodbar:SetSize( w*0.05, h*0.8 );
	
	--self.waterbar:SetPos( w*0.15, h*0.1 );
	--self.foodbar:SetPos( w*(0.85-0.05), h*0.1 );
end
function PANEL:Paint( w, h )
end
vgui.Register( 'gmodz_hud', PANEL );


local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "aLookAngle", 		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )


--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096
	
	self:SetCamPos( Vector( 450, 0, 35 ) )
	self:SetLookAt( Vector( 0, 0, 35 ) )
	self:SetFOV( 10 )
	
	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )
	
	self:SetAmbientLight( Color( 50, 50, 50 ) )
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	
	self:SetColor( Color( 255, 255, 255, 255 ) )
	
	self.hpFrac = 0;
end

--[[---------------------------------------------------------
   Name: SetDirectionalLight
-----------------------------------------------------------]]
function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[iDirection] = color
end

--[[---------------------------------------------------------
   Name: OnSelect
-----------------------------------------------------------]]
function PANEL:SetModel( strModelName )

	-- Note - there's no real need to delete the old 
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil		
	end
	
	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end
	
	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	self.Entity2 = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid(self.Entity) ) then return end

	self.Entity:SetNoDraw( true )
	self.Entity2:SetNoDraw( true )
	
	-- Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" );
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end
	
	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) self.Entity2:ResetSequence( iSeq ) end
	
	
	local scale = Vector(1.1,1.1,1.1);
	for i = 1, self.Entity2:GetBoneCount() do
		self.Entity2:ManipulateBoneScale( i, scale );
	end
end

function PANEL:Think( )
	if( not IsValid( self.Entity ) or self.Entity:GetModel() ~= LocalPlayer():GetModel() )then
		self:SetModel( LocalPlayer():GetModel() );
	end	
end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
local matOutline = Material( "color" )
function PANEL:Paint()

	if ( !IsValid( self.Entity ) ) then return end
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	local ang = self.aLookAngle
	if ( !ang ) then
		ang = (self.vLookatPos-self.vCamPos):Angle()
	end
	
	local w, h = self:GetSize()
	
	
	
	
	
	
	-- SET UP FOG
	render.FogStart( 5 );
	render.FogEnd( 6 );
	
	-- CAM STUFFZ
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end
	
	-- CALCULATIONS
	local _frac = LocalPlayer():Health()/100;
	self.hpFrac = math.Clamp( Lerp( FrameTime()*10, self.hpFrac, _frac ), 0, 1 );
	
	
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
		
		render.SetBlend( 0.5 );
		render.FogColor( 100, 100, 100 );
		render.FogMode( MATERIAL_FOG_LINEAR );
		render.FogStart( 0 );
		render.FogEnd( 1 );
		
		self.Entity2:DrawModel()
		
	cam.End3D()
	
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
		cam.IgnoreZ( true );
		
		render.FogMode( MATERIAL_FOG_NONE );
		render.SetBlend( 1 );
		self.Entity:DrawModel()
		
		render.SetBlend( 0.93 );
		render.FogColor( 200, 0, 0 );
		render.FogMode( MATERIAL_FOG_LINEAR );
		render.SetScissorRect( x, y, x+w, y+h*(1-self.hpFrac), true );
		self.Entity:DrawModel( )
		render.SetScissorRect(0,0,0,0,false);
		
		render.FogMode( MATERIAL_FOG_NONE );
		
		cam.IgnoreZ( false );
	cam.End3D()
	
	
	render.SuppressEngineLighting( false );
	
	self.LastPaint = RealTime()
	
	-- x, y, radius, linewidth, startangle, endangle, aa
	draw.NoTexture( );
	
	-- RIGHT - FOOD
	local food = LocalPlayer():GetUData( 'food' );
	if not food then return end;
	local frac = 1-math.Clamp( food / gmodz.cfg.max_food, 0, 1 );
	
	local aStart = -45;
	surface.SetDrawColor(0,0,0,150);
	surface.DrawArc( w*0.45, h*0.5, w*0.5-20, w*0.5, aStart, aStart+90, 15 )
	
	surface.SetDrawColor(100,155,0);
	surface.DrawArc( w*0.45, h*0.5, w*0.5-20, w*0.5, aStart+90*frac, aStart+90, 15 )
	
	surface.SetDrawColor(255,255,255,50);
	surface.DrawArcOutline( w*0.45, h*0.5, w*0.5-20, w*0.5, aStart, aStart+90, 15 )
	
	-- LEFT - WATER
	local water = LocalPlayer():GetUData( 'water' );
	if not water then return end;
	local frac = math.Clamp( water / gmodz.cfg.max_water, 0, 1 );
	
	local aStart = 90+45
	surface.SetDrawColor(0,0,0,150);
	surface.DrawArc( w*0.55, h*0.5, w*0.5-20, w*0.5, aStart, aStart+90, 15 )
	
	surface.SetDrawColor(0,70,155);
	surface.DrawArc( w*0.55, h*0.5, w*0.5-20, w*0.5, aStart, aStart+90*frac, 15 )
	
	surface.SetDrawColor(255,255,255,50);
	surface.DrawArcOutline( w*0.55, h*0.5, w*0.5-20, w*0.5, aStart, aStart+90, 15 )
end

derma.DefineControl( "gmodz_healthmodel", "Health Model", PANEL )











--
-- STAT BARS
--
local PANEL = {};
function PANEL:Init()
	
end
function PANEL:Paint( w, h )
	local food = LocalPlayer():GetUData( 'food' );
	if not food then return end;
	local frac = math.Clamp( food / gmodz.cfg.max_food, 0, 1 );
	surface.SetDrawColor(100,155,0);
	surface.DrawRect(0,h*(1-frac),w,h);
	
	surface.SetDrawColor(100,155,0,20);
	surface.DrawRect(0,0,w,h);

	surface.SetDrawColor(100,155,0);
	surface.DrawOutlinedRect(0,0,w,h);
	draw.NoTexture( );
	surface.SetDrawColor(255,255,255);
	surface.DrawPartialCircle(0, 0, 50, 10, 0, 260, 20 );
end
vgui.Register( 'gmodz_foodbar', PANEL );


local PANEL = {};
function PANEL:Init()
	
end
function PANEL:Paint( w, h )
	local water = LocalPlayer():GetUData( 'water' );
	if not water then return end;
	local frac = math.Clamp( water / gmodz.cfg.max_water, 0, 1 );
	
	surface.SetDrawColor(0,70,155);
	surface.DrawRect(0,h*(1-frac),w,h);
		
	surface.SetDrawColor(0,70,155,20);
	surface.DrawRect(0,0,w,h);
	
	surface.SetDrawColor(0,70,155);
	surface.DrawOutlinedRect(0,0,w,h);
end
vgui.Register( 'gmodz_waterbar', PANEL );
