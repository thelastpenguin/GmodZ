AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( 'models/props/cs_militia/table_shed.mdl' );
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
end

util.AddNetworkString('gmodz_craftingtbl_openmenu' );
function ENT:Use( pl, _ )
	net.Start( 'gmodz_craftingtbl_openmenu' );
		net.WriteEntity( self );
	net.Send( pl );
end

-- CRAFT RECIPE
util.AddNetworkString( 'gmodz_craftingtbl_craft');
net.Receive( 'gmodz_craftingtbl_craft', function( len, pl )
	local id = net.ReadString();
	
	-- find the recipe...
	local recipe = gmodz.crafting.GetRecipe( id );
	if not recipe then
		pl:ChatPrint("[ERROR] Recipe "..id.." doesn't exist!");
		return ;
	end
	
	-- make sure we have all our toys.
	local inv = pl:GetInv( 'inv' );
	if not inv then pl:ChatPrint('[ERROR] Your inventory isn\'t loaded'); return end
	
	local craftable = recipe:CanMake( inv );
	if craftable then
		pl:ChatPrint("Crafted");
		recipe:Craft( inv );
	else
		pl:ChatPrint('[ERROR] Recipe not currently craftable.');
	end
end);