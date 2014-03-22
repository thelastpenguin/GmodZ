local item = {};
item.base = 'base';
item.PrintName = 'Base Crafting'
item.StackSize = 64
item.Desc = [[
Base Food Entity.
]]
item.Model = "models/Items/BoxMRounds.mdl"
item.lootBias = 2
gmodz.item.register( 'base_material', item );





-- UTILITIES
local function onuse_explosive( self, pl )
	local vPoint = pl:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	
	for k, v in pairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" then
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

-- PROPANE TANK
local item = {};
item.base = 'base_material';
item.PrintName = 'Propane Tank'
item.StackSize = 64
item.Desc = [[
A tank of propane. Handle with care.
]]
item.OnUse = onuse_explosive;
item.Model = "models/props_junk/propane_tank001a.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_propane', item );

-- GAS TANK
local item = {};
item.base = 'base_material';
item.PrintName = 'Gas Tank'
item.StackSize = 64
item.Desc = [[
A tank of gas. Handle with care.
]]
item.OnUse = onuse_explosive;
item.Model = "models/props_junk/gascan001a.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_gas', item );


-- CIRCUIT
local item = {};
item.base = 'base_material';
item.PrintName = 'Circuit'
item.StackSize = 64
item.Desc = [[
A simple circuit. Pretty simple.
]]
item.Model = "models/props_lab/reciever01d.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_circuit', item );

-- ADVANCED CIRCUIT
local item = {};
item.base = 'base_material';
item.PrintName = 'Adv Circuit'
item.StackSize = 64
item.Desc = [[
A simple circuit. Pretty simple.
]]
item.Model = "models/props_lab/reciever01b.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_circuit_adv', item );


-- UNUBTANIUM
local item = {};
item.base = 'base_material';
item.PrintName = 'Unubtanium'
item.StackSize = 64
item.Desc = [[
Unubtanium - high tech alloy.
]]
item.OnUse = onuse_explosive;
item.Model = "models/props_c17/consolebox05a.mdl"
item.lootCount = 1
item.lootBias = 1
gmodz.item.register( 'material_techtrium', item );

-- RUBBER
local item = {};
item.base = 'base_material';
item.PrintName = 'Rubber'
item.StackSize = 64
item.Desc = [[
Some vulcanized rubber. Useful for crafting.
]]
item.Model = "models/props_vehicles/tire001b_truck.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_rubber', item );


-- NITRATE
local item = {};
item.base = 'base_material';
item.PrintName = 'NITRATE'
item.StackSize = 64
item.Desc = [[
POWERFUL OXIDANT HANDLE WITH CARE
]]
item.OnUse = function( _, pl ) pl:Ignite( 10, 10 ) end
item.Model = "models/props_lab/jar01a.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_nitrate', item );


-- PLASTIC RESIN
local item = {};
item.base = 'base_material';
item.PrintName = 'Plastic Resin'
item.StackSize = 64
item.Desc = [[
Plastic Resin. It's plastic...
]]
item.OnUse = function( _, pl ) pl:Ignite( 10, 10 ) end
item.Model = "models/props_junk/plasticbucket001a.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_nitrate', item );



-- TECH REACTOR
local item = {};
item.base = 'base_material';
item.PrintName = 'Tech Reactor'
item.StackSize = 64
item.Desc = [[
Tech Reactor. Required for advanced recipes.
]]
item.Model = "models/props_lab/crematorcase.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_techreactor', item );



-- TERRA COTTA POT
local item = {};
item.base = 'base_material';
item.PrintName = 'Terracotta Pot'
item.StackSize = 64
item.Desc = [[
A terracotta pot. Useful for farming.
]]
item.Model = "models/props_junk/terracotta01.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_terracottapot', item );


-- SPARE PARTS
local item = {};
item.base = 'base_material';
item.PrintName = 'Spare Parts'
item.StackSize = 64
item.Desc = [[
Bin of misc electronic parts
]]
item.Model = "models/props_lab/partsbin01.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_terracottapot', item );

-- METAL RODS
local item = {};
item.base = 'base_material';
item.PrintName = 'Copper Rods'
item.StackSize = 64
item.Desc = [[
Rods of copper, useful in electronics.
]]
item.Model = "models/Items/CrossbowRounds.mdl"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_copper', item );

-- SCRAP METAL
local item = {}; 
item.base = 'base_material';
item.PrintName = 'Scrap Metal'
item.StackSize = 64
item.Desc = [[
Scrap Metal
]]
item.Model = "models/gibs/metal_gib1"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'material_metal', item );


gmodz.hook.Add( 'PostItemsLoaded', function()
	local recip = gmodz.crafting.new( )
	
	
end);