include("shared.lua")

function ENT:Initialize()
	self.initted = true;
	self.meta = gmodz.item.GetMeta( self:GetType() );
	
	if self.meta.SVModel then
		self.csModel = ClientsideModel( self.meta.Model, RENDERMODE_TRANSALPHA );
		self.csModel:SetNoDraw( true );
		self.csModel:SetPos(Vector(0,0,0) );
	end
	
	local meta = self.meta;
	local count, text = self:GetAmount( );
	if count > 1 then
		text = count..' '..meta.PrintName..'s';
	else
		text = meta.PrintName;
	end
	self.text = text;
end
function ENT:OnRemove( )
	if IsValid( self.csModel )then self.csModel:Remove() end
end

function ENT:Draw()
	if not self.initted then self:Initialize( ) end
	
	render.SuppressEngineLighting( true );
	if self.csModel then
		self.csModel:SetRenderOrigin( self:GetPos( ) );
		self.csModel:SetRenderAngles( self:GetAngles( ) );
		self.csModel:SetupBones( );
		self.csModel:DrawModel( );
	else
		self:DrawModel()
	end
	render.SuppressEngineLighting( false );
	
	local meta = self.meta;
	
	if meta.customDraw then
		meta.customDraw( meta, self );
	end
end

function ENT:GetCaption( )
	return self.text;
end

function ENT:Think()
end
