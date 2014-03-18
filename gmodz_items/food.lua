local item = {};
item.base = 'base';
item.PrintName = 'Base Food'
item.StackSize = 16
item.Desc = [[
Base Food Entity.
]]
function item:OnUse( pl, stack )
	local fm, wm = gmodz.cfg.max_food/100, gmodz.cfg.max_water/100;
	if self.addFood then
		pl:SetUData( 'food', math.Clamp( pl:GetUData( 'food', 0 ) + self.addFood*fm, 0, gmodz.cfg.max_food ) );
	end
	
	if self.addWater then
		pl:SetUData( 'water', math.Clamp( pl:GetUData( 'water', 0 ) + self.addWater*wm, 0, gmodz.cfg.max_water ) );
	end
	
	if self.Sound then
		pl:EmitSound(self.Sound, 50, 100)
	end
end
item.Model = "models/Items/BoxMRounds.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 1
item.lootBias = 3
gmodz.item.register( 'base_food', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Apple Juice'
item.Desc = [[
Little bottle of apple juice.
]]
item.Model = "models/FoodNHouseholdItems/juicesmall.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.addFood = 5
item.addWater = 20;
item.lootBias = 5
gmodz.item.register( 'food_applejuice', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Bacon'
item.Desc = [[
Some strips of dried bacon. High in protine.
]]
item.Model = "models/FoodNHouseholdItems/bacon.mdl"
item.addFood = 5
item.lootBias = 5
gmodz.item.register( 'food_bacon', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Bacon Slab'
item.Desc = [[
Large slab of bacon strips. High in protine.
]]
item.Model = "models/FoodNHouseholdItems/bacon_2.mdl"
item.addFood = 20
item.lootBias = 2
gmodz.item.register( 'food_bacon_slab', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Bagette'
item.Desc = [[
A long, slender loaf of bred, bit of mold but otherwise fine.
]]
item.Model = "models/FoodNHouseholdItems/bagette.mdl"
item.Sound = "eating_and_drinking/eating_long.wav"
item.addFood = 20
item.lootBias = 5
gmodz.item.register( 'food_bacon_slab', item );

local item = {};
item.base = 'base_food';
item.PrintName = 'Cake'
item.Desc = [[
A birthday cake somehow preserved. Poor kid didn't have a great party did he... Sweets are a rare luxury in a world like this...
]]
item.Model = "models/FoodNHouseholdItems/cake.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.addFood = 70
item.lootBias = 0.1
gmodz.item.register( 'food_bacon_slab', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Cabbage'
item.Desc = [[
Hunger will drive men to eat anything to survive... even vegetables.
]]
item.Model = "models/FoodNHouseholdItems/cabbage1.mdl"
item.addFood = 15
item.lootBias = 6
gmodz.item.register( 'food_cabbage1', item );



local item = {};
item.base = 'base_food';
item.PrintName = 'Champagne'
item.Desc = [[
Can't let a good bottle of Champagne go to waste...
]]
item.Model = "models/FoodNHouseholdItems/champagne.mdl"
item.Sound = "eating_and_drinking/champagne.wav"
item.addWater = 50
item.lootBias = 0.1
gmodz.item.register( 'food_champagne', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Doritos'
item.Desc = [[
Doritos... still crispy even in the apocolypse!
]]
item.Model = "models/FoodNHouseholdItems/chipsdoritos.mdl"
item.Sound = "eating_and_drinking/chips.wav"
item.addFood = 10;
item.lootBias = 2
gmodz.item.register( 'food_chipsdoritos', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Fritos'
item.Desc = [[
Fritos... still crispy even in the apocolypse!
]]
item.Model = "models/FoodNHouseholdItems/chipsfritos.mdl"
item.Sound = "eating_and_drinking/chips.wav"
item.addFood = 13
item.lootBias = 2
gmodz.item.register( 'food_chipsfritos', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Lays Chips'
item.Desc = [[
Lays potato chips! Something gives me a feeling these arn't being manufactured anymore...
]]
item.Model = "models/FoodNHouseholdItems/chipslays.mdl"
item.Sound = "eating_and_drinking/chips.wav"
item.addFood = 13
item.lootBias = 2
gmodz.item.register( 'food_chipslays', item );




local item = {};
item.base = 'base_food';
item.PrintName = 'Cookies!'
item.Desc = [[
Cookies! Who doesn't love cookies?!
]]
item.Model = "models/FoodNHouseholdItems/cookies.mdl"
item.Sound = "eating_and_drinking/crunchy_double.wav"
item.addFood = 4
item.lootCount = 8
item.lootBias = 0.3
gmodz.item.register( 'food_cookies', item );




local item = {};
item.base = 'base_food';
item.PrintName = 'Banannas'
item.Desc = [[
Banannas... monkies are extinct so I'm sure they won't mind.
]]
item.Model = "models/props/cs_italy/bananna_bunch.mdl"
item.Sound = "eating_and_drinking/eating_long.wav"
item.addFood = 15
item.lootBias = 4
gmodz.item.register( 'food_bananna', item );



local item = {};
item.base = 'base_food';
item.PrintName = 'Orange'
item.Desc = [[
Orange for your thoughts?
]]
item.Model = "models/props/cs_italy/orange.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.addFood = 5
item.addWater = 1
item.lootBias = 5
gmodz.item.register( 'food_orange', item );



local item = {};
item.base = 'base_food';
item.PrintName = 'Cat Fish'
item.Desc = [[
Something smell fishy to you?
]]
item.Model = "models/FoodNHouseholdItems/fishcatfish.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.addFood = 15
item.lootBias = 5
gmodz.item.register( 'food_fish1', item );



local item = {};
item.base = 'base_food';
item.PrintName = 'Cat Fish'
item.Desc = [[
Something smell fishy to you?
]]
item.Model = "models/FoodNHouseholdItems/fishcatfish.mdl"
item.Sound = "eating_and_drinking/eating_long.wav"
item.addFood = 15
item.lootBias = 5
gmodz.item.register( 'food_fish1', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Gold Fish'
item.Desc = [[
I had one of these when I was little...
]]
item.Model = "models/FoodNHouseholdItems/fishgolden.mdl"
item.Sound = "eating_and_drinking/eating_long.wav"
item.addFood = 15
item.lootBias = 5
gmodz.item.register( 'food_fish2', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Orange Juice'
item.Desc = [[
Some orange juice.
]]
item.Model = "models/FoodNHouseholdItems/juice.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.addWater = 20
item.lootBias = 8
gmodz.item.register( 'food_orangejuice', item );

