function EFFECT:Init(data)
	local ent = data:GetEntity()
	if ent:IsValid() then
		self.DieTime = CurTime() + 0.5
		
		self.Entity:SetModel(ent:GetModel())
		self.Entity:SetPos(data:GetOrigin())
		self.Entity:SetAngles(data:GetAngles());
		self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA );
		self.Entity:SetMaterial( 'models/debug/debugwhite' )
		
		self.movedir = Vector( math.random() - 0.5, math.random() - 0.5, 0 )*0.2;
	else
		self.DieTime = 0
	end
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local mat = Material( "models/debug/debugwhite" );
function EFFECT:Render()
	local delta = self.DieTime - CurTime()
	local frac = delta * 2;
	
	self.Entity:SetPos( self.Entity:GetPos() + self.movedir * FrameTime() * 20 );
	self.Entity:SetColor(Color(200,200,200, frac*20 ))
	self.Entity:SetModelScale(0.95, 0)
	
	render.SuppressEngineLighting( true );
	render.MaterialOverride( mat );
	self.Entity:DrawModel()
	render.MaterialOverride( 0 );
	render.SuppressEngineLighting( true );
	
	self.movedir.z = self.movedir.z + FrameTime();
end
