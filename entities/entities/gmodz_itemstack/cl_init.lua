include("shared.lua")

function ENT:Initialize()
	self.initted = true;
	self.meta = gmodz.item.GetMeta( self:GetType() );
	
	if self.meta.SVModel and self.meta.Model ~= self.meta.SVModel then
		self.csModel = ClientsideModel( self.meta.Model, RENDERGROUP_OPAQUE );
		self.csModel:SetNoDraw( );
	end
	
end
function ENT:OnRemove( )
	if IsValid( self.csModel )then self.csModel:Remove() end	
end

function ENT:Draw()
	if not self.initted then self:Initialize( ) end
	
	if IsValid( self.csModel ) then
		self.csModel:SetPos( self:GetPos( ));
		self.csModel:SetAngles( self:GetAngles() );
		self.csModel:DrawModel();
	else
		self:DrawModel()
	end
	
	local meta = self.meta;
	
	if meta.customDraw then
		meta.customDraw( meta, self );
	end
	
	local count, text = self:GetAmount( );
	if count > 1 then
		text = count..' '..meta.PrintName..'s';
	else
		text = meta.PrintName;
	end
	
	self:DrawEntLabel( text );
end

function ENT:Think()
end