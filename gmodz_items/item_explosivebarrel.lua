
local item = {};

item.base = 'base';
item.PrintName = 'Explosive Barrel'
item.Desc = [[
A barrel of extremely explosive feul.
Be careful when handling.
]]
item.Model = 'models/props_c17/oildrum001.mdl'
item.StackSize = 1;

item.OnUse = function( self, pl )
	local vPoint = pl:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	
	for k, v in pairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter and not v:GetClass() == "scrap_metal" then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(pl:GetPos())
			v:TakeDamage(distance / 200 * 100, self, self)
		end
	end
	
	for i = 0, 10 do
		local fire = ents.Create("env_fire")
		local randvec = Vector(math.random(-100,100),math.random(-100,100),0)

		fire:SetKeyValue("StartDisabled","0")
		fire:SetKeyValue("health",math.random(12,38))
		fire:SetKeyValue("firesize",math.random(32,72))
		fire:SetKeyValue("fireattack","2")
		fire:SetKeyValue("ignitionpoint","0")
		fire:SetKeyValue("damagescale","10")
		fire:SetKeyValue("spawnflags",2 + 4 + 128)
		
		fire:SetPos(pl:GetPos() + randvec)
		fire:Spawn()
		fire:Fire("StartFire","","0")
	end
	pl:Kill( );
end

gmodz.item.register( 'explosive_barrel', item );
