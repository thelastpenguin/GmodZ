AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
end

function ENT:SetStack( stack )
	local stack = stack:Copy();
	
	self.stack = stack;
	self:SetType( stack:GetClass() );
	self:SetAmount( stack:GetCount() );
	
	self:EnableTimeout( );
	
	
	
	local meta = self.stack.meta;
	self:SetModel( meta.SVModel or meta.Model );
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup( COLLISION_GROUP_WORLD );
	
	self:PhysWake( );
	
end
function ENT:EnableTimeout( )
	self.TimeOut = CurTime() + gmodz.cfg.item_despawn;	
end
function ENT:DisableTimeout( )
	self.TimeOut = nil;
end

function ENT:Use( pl, caller )
	if self.OnUse then self.OnUse( self, pl ) end
	
	self:EmitSound( 'weapons/ammopickup.wav', 500, 100 );
	if not pl:IsPlayer() then return end
	local inv = pl:GetInv( 'inv' );
	if not inv then
		pl:ChatPrint("Your inventory is not properly loaded. Could not pickup item.");
		return ;
	end
	
	if self.stack:GetCount() < 1 then -- >_<
		self:Remove()
		return
	end
	
	local remainder = inv:AddStack( self.stack )
	if remainder > 0 then
		pl:ChatPrint("Your inventory is full. "..remainder.." items left over.");
		return ;
	end
	
	local item = gmodz.item.GetMeta( self.stack.meta.class )
	if item.attch then
		pl:FAS2_PickUpAttachment(item.attch, true)
	end
	
	pl:CallClientHook( 'ItemStackNoticePickup', self.stack.meta.class, self.stack:GetCount() );
	
	self:Remove()
end
function ENT:SetUseCallback( func )
	self.OnUse = func;
end

do
	local CurTime = _G.CurTime ;
	function ENT:Think( )
		if self.TimeOut ~= nil and CurTime() > self.TimeOut then
			gmodz.print('Item drop timed out. Garbage collected.');
			self:Remove( );
		end	
	end
end