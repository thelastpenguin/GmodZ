local item = {};
item.base = 'base';
item.PrintName = 'Base Crafting'
item.StackSize = 16
item.Desc = [[
Base Food Entity.
]]
item.Model = "models/Items/BoxMRounds.mdl"
item.lootBias = 5
item.flags = ITEMFLAG_BASECLASS ;
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

local function onuse_explosive_super( self, pl )
	local vPoint = pl:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	
	for k, v in pairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" then
			v:Ignite(math.random(50, 100), 0)
		end
	end
	
	for i = 0, 50 do
		local fire = ents.Create("env_fire")
		local randvec = Vector(math.random(-200,200),math.random(-200,200),0)

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
item.StackSize = 16
item.Desc = [[
A tank of propane. Handle with care.
]]
item.OnUse = onuse_explosive;
item.Model = "models/props_junk/propane_tank001a.mdl"
item.lootCount = 1
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_propane', item );

-- GAS TANK
local item = {};
item.base = 'base_material';
item.PrintName = 'Gas Tank'
item.StackSize = 16
item.Desc = [[
A tank of gas. Handle with care.
]]
item.OnUse = onuse_explosive;
item.Model = "models/props_junk/gascan001a.mdl"
item.lootCount = 1
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_gas', item );


-- CIRCUIT
local item = {};
item.base = 'base_material';
item.PrintName = 'Circuit'
item.StackSize = 16
item.Desc = [[
A simple circuit. Pretty simple.
]]
item.Model = "models/props_lab/reciever01d.mdl"
item.lootCount = 1
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_circuit', item );

-- ADVANCED CIRCUIT
local item = {};
item.base = 'base_material';
item.PrintName = 'Adv Circuit'
item.StackSize = 16
item.Desc = [[
A simple circuit. Pretty simple.
]]
item.Model = "models/props_lab/reciever01b.mdl"
item.lootCount = 1
item.lootBias = false ;
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_circuit_adv', item );


-- UNUBTANIUM
local item = {};
item.base = 'base_material';
item.PrintName = 'Unubtanium'
item.StackSize = 1
item.Desc = [[
Unubtanium - high tech alloy. Unstable Form of Matter. HIGHLY EXPLOSIVE.
]]
item.OnUse = onuse_explosive_super;
item.Model = "models/props_c17/consolebox05a.mdl"
item.lootCount = 16
item.lootBias = 0.2
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_techtrium', item );

-- RUBBER
local item = {};
item.base = 'base_material';
item.PrintName = 'Rubber'
item.StackSize = 16
item.Desc = [[
Some vulcanized rubber. Useful for crafting.
]]
item.Model = "models/props_vehicles/tire001b_truck.mdl"
item.lootCount = 4
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_rubber', item );


-- NITRATE
local item = {};
item.base = 'base_material';
item.PrintName = 'NITRATE'
item.StackSize = 16
item.Desc = [[
POWERFUL OXIDANT HANDLE WITH CARE
]]
item.OnUse = function( _, pl ) pl:Ignite( 10, 10 ) end
item.Model = "models/props_lab/jar01a.mdl"
item.lootCount = 4
item.lootBias = 7
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_nitrate', item );


-- PLASTIC RESIN
local item = {};
item.base = 'base_material';
item.PrintName = 'Plastic Resin'
item.StackSize = 16
item.Desc = [[
Plastic Resin. It's plastic...
]]
item.OnUse = function( _, pl ) pl:Ignite( 10, 10 ) end
item.Model = "models/props_junk/plasticbucket001a.mdl"
item.lootCount = 4
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_plastic', item );



-- TECH REACTOR
local item = {};
item.base = 'base_material';
item.PrintName = 'Tech Reactor'
item.StackSize = 1
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
item.StackSize = 16
item.Desc = [[
A terracotta pot. Useful for farming.
]]
item.Model = "models/props_junk/terracotta01.mdl"
item.lootCount = 1
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_terracottapot', item );


-- SPARE PARTS
local item = {};
item.base = 'base_material';
item.PrintName = 'Spare Parts'
item.StackSize = 16
item.Desc = [[
Bin of misc electronic parts
]]
item.Model = "models/props_lab/partsbin01.mdl"
item.lootCount = 4
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_spareparts', item );

-- METAL RODS
local item = {};
item.base = 'base_material';
item.PrintName = 'Copper Rods'
item.StackSize = 16
item.Desc = [[
Rods of copper, useful in electronics.
]]
item.Model = "models/Items/CrossbowRounds.mdl"
item.lootCount = 4
item.lootBias = 10
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_copper', item );

-- SCRAP METAL
local item = {}; 
item.base = 'base_material';
item.PrintName = 'Scrap Metal'
item.StackSize = 16
item.Desc = [[
Scrap Metal
]]
item.Model = "models/gibs/metal_gib1.mdl"
item.lootCount = 4
item.lootBias = 10
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'material_metal', item );



-- SCRAP METAL
local item = {}; 
item.base = 'base_material';
item.PrintName = 'Gun Powder'
item.StackSize = 16
item.Desc = [[
Gun Powder. Highly explosive. Handle with care.
]]
item.OnUse = onuse_explosive_super ;
item.Model = "models/props_c17/woodbarrel001.mdl"
item.flags = 0;
gmodz.item.register( 'material_gunpowder', item );




gmodz.hook.Add( 'PostItemsLoaded', function()
	print("RECIPES ADDED:");
	
	-- GUN POWDER
	local recip = gmodz.crafting.new( );
	recip:SetTitle( 'Black Powder' );
	recip:AddMaterialEx( 'material_nitrate', 1 );
	recip:AddProductEx( 'material_gunpowder', 1 );
	gmodz.crafting.register( 'gunpowder', recip );
	
	-- 9mm AMMO
	local recip = gmodz.crafting.new( )
	recip:SetTitle( '9mm Ammo (32)' );
	recip:AddMaterialEx( 'material_copper', 2, {} );
	recip:AddMaterialEx( 'material_gunpowder', 1, {} );
	recip:AddProductEx( 'ammo_9mm', 30, {} );
	gmodz.crafting.register( 'ammo_9mm', recip );
	
	-- 7.62 AMMO
	local recip = gmodz.crafting.new( )
	recip:SetTitle( '7.62 Ammo (28)' );
	recip:AddMaterialEx( 'material_copper', 2, {} );
	recip:AddMaterialEx( 'material_metal', 2, {} );
	recip:AddMaterialEx( 'material_gunpowder', 1, {} );
	recip:AddProductEx( 'ammo_9mm', 20, {} );
	gmodz.crafting.register( 'ammo_7.62', recip );
	
	
	-- ammo_5.56
	local recip = gmodz.crafting.new( );
	recip:SetTitle( '5.56 Ammo (28)' );
	recip:AddMaterialEx( 'material_copper', 1, {} );
	recip:AddMaterialEx( 'material_metal', 2, {} );
	recip:AddMaterialEx( 'material_gunpowder', 1, {} );
	recip:AddProductEx( 'ammo_5.56', 20, {} )
	gmodz.crafting.register( 'ammo_5.56', recip )
	
	-- Shotgun Shells
	local recip = gmodz.crafting.new( );
	recip:SetTitle( 'Buckshot (16)' );
	recip:AddMaterialEx( 'material_plastic', 1, {} );
	recip:AddMaterialEx( 'material_metal', 1, {} );
	recip:AddMaterialEx( 'material_gunpowder', 1, {} );
	recip:AddProductEx( 'ammo_Buckshot', 20, {} )
	gmodz.crafting.register( 'ammo_Buckshot', recip );
	
	-- 50 Cal Ammo
	local recip = gmodz.crafting.new( )
	recip:SetTitle( '50 Cal Ammo (20)')
	recip:AddMaterialEx( 'material_copper', 2, {} );
	recip:AddMaterialEx( 'material_metal', 2, {} );
	recip:AddMaterialEx( 'material_gunpowder', 2, {} );
	recip:AddProductEx( 'ammo_50cal', 20, {} );
	gmodz.crafting.register( 'ammo_50cal', recip );
	
	-- SPIKED BASEBALL BAT.
	local recip = gmodz.crafting.new( )
	recip:SetTitle( 'Spiked Bat' );
	recip:AddMaterialEx( 'melee_bballBat', 1, {} );
	recip:AddMaterialEx( 'material_metal', 5, {} );
	recip:AddProductEx( 'melee_bballBat_spiked', 1, {} );
	gmodz.crafting.register( 'spikedbat', recip );
	
	-- ADVANCED CIRCUIT
	local recip = gmodz.crafting.new( )
	recip:SetTitle( 'Advanced Circuit' );
	recip:AddMaterialEx( 'material_techtrium', 1, {} );
	recip:AddMaterialEx( 'material_circuit', 1, {} );
	recip:AddProductEx( 'material_circuit_adv', {} );
	gmodz.crafting.register( 'advcirc', recip );
	
	-- MEDICAL KIT
	local recip = gmodz.crafting.new( );
	recip:SetTitle( 'Medical Kit' );
	recip:AddMaterialEx( 'ammo_Bandages', 1, {} );
	recip:AddMaterialEx( 'ammo_Quikclots', 1, {} );
	recip:AddMaterialEx( 'ammo_Hemostats', 1, {} );
	recip:AddProductEx( 'healthkit', 1, {} );
	
	-- SALVAGE IRON
	local recip = gmodz.crafting.new( );
	recip:SetTitle( 'Scrap Metal' );
	recip:AddMaterialEx( 'melee_fryingpan', 1, {} );
	recip:AddProductEx( 'material_metal', 5 );
end);