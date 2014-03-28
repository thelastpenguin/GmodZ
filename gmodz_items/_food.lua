local item = {};
item.base = 'base';
item.PrintName = 'Base Food'
item.StackSize = 16
item.Desc = [[
Base Food Entity.
]]
function item:OnUse( pl, stack )
	local fm, wm = 1, 1 -- gmodz.cfg.max_food/100, gmodz.cfg.max_water/100;
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
item.lootBias = 7
item.flags = ITEMFLAG_BASECLASS ;
gmodz.item.register( 'base_food', item );


-- CHIPS
local item = {};
item.base = 'base_food';
item.PrintName = 'Bag o\' Chips'
item.Desc = [[
An old bag of chips.
]]
item.Model = "models/warz/consumables/bag_chips.mdl"
item.Sound = "eating_and_drinking/crunchy_double.wav"
item.addFood = 30
item.lootBias = 5
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_chips', item );

-- MRE - Ready To Eat
local item = {};
item.base = 'base_food';
item.PrintName = 'MRE'
item.Desc = [[
MRE - Meal Ready to Eat
]]
item.Model = "models/warz/consumables/bag_mre.mdl"
item.Sound = "eating_and_drinking/eating_long.wav"
item.addFood = 100
item.lootBias = 5
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_mre', item );

-- BAG OAT
local item = {};
item.base = 'base_food';
item.PrintName = 'Oatmeal'
item.Desc = [[
Bag of Oatmeal. More chemical than oat, these things never get stale.
]]
item.Model = "models/warz/consumables/bag_oat.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.addFood = 50
item.lootBias = 5
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_oatmeal', item );

-- BAR CHOCOLATE
local item = {};
item.base = 'base_food';
item.PrintName = 'Chocolate'
item.Desc = [[
An old bar of chocolate, a rare taste of divinity in a world of detritus.
]]
item.Model = "models/warz/consumables/bar_chocolate.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 2
item.addFood = 20
item.lootBias = 1
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_chocolate', item );

-- BAR CHOCOLATE
local item = {};
item.base = 'base_food';
item.PrintName = 'Granola'
item.Desc = [[
A few granola bars, high in energy and fibre!
]]
item.Model = "models/warz/consumables/bar_granola.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 2
item.addFood = 30
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_granola', item );

-- CAN OF PASTA
local item = {};
item.base = 'base_food';
item.PrintName = 'Pasta'
item.Desc = [[
A tin can of pasta, looks like it's still sealed.
]]
item.Model = "models/warz/consumables/can_pasta.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 1
item.addFood = 50
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_pasta', item );



-- CAN OF SOUP
local item = {};
item.base = 'base_food';
item.PrintName = 'Soup'
item.Desc = [[
A tin can of soup, looks like it's still sealed.
]]
item.Model = "models/warz/consumables/can_soup.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 1
item.addFood = 30
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_soup', item );

-- CAN OF SPAM
local item = {};
item.base = 'base_food';
item.PrintName = 'SPAM'
item.Desc = [[
A tin can of spam, not sure what animal went into this but it looks like it's still sealed.
]]
item.Model = "models/warz/consumables/can_spam.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 1
item.addFood = 40
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_spam', item );

-- CAN OF TUNA
local item = {};
item.base = 'base_food';
item.PrintName = 'Tuna'
item.Desc = [[
They say mercury can kill you... like I need to worry about cancer
]]
item.Model = "models/warz/consumables/can_tuna.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 1
item.addFood = 50
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_tuna', item );

-- CAN OF TUNA
local item = {};
item.base = 'base_food';
item.PrintName = 'Tuna'
item.Desc = [[
They say mercury can kill you... like I need to worry about cancer
]]
item.Model = "models/warz/consumables/can_tuna.mdl"
item.Sound = "eating_and_drinking/eating.wav"
item.lootCount = 1
item.addFood = 50
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_tuna', item );


--
-- DRINKS
--

-- COCONUTS
local item = {};
item.base = 'base_food';
item.PrintName = 'Coconut Water'
item.Desc = [[
Maybe these still grow somewhere... somewhere far far away from this hellhole.
]]
item.Model = "models/warz/consumables/coconut_water.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 1
item.addWater = 30
item.lootBias = 6
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_coconut_water', item );


-- COCONUTS
local item = {};
item.base = 'base_food';
item.PrintName = 'Energy Drink'
item.Desc = [[
Energy Drink! This'll keep me going for a while.
]]
item.Model = "models/warz/consumables/energy_drink.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 1
item.addWater = 30
item.addFood = 30
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_energy_drink', item );

local item = {};
item.base = 'base_food';
item.PrintName = 'Gatorade'
item.Desc = [[
Gatorade, pure sugar, I love it.
]]
item.Model = "models/warz/consumables/gatorade.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 1
item.addWater = 50
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_gatorade', item );

local item = {};
item.base = 'base_food';
item.PrintName = 'Juice'
item.Desc = [[
Some nice fruit juice, not so fresh, but still nice.
]]
item.Model = "models/warz/consumables/juice.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 1
item.addWater = 34
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_juice', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Juice'
item.Desc = [[
Soda, gone flat but better than nothing.
]]
item.Model = "models/warz/consumables/soda.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 1
item.addWater = 44
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_soda', item );

local item = {};
item.base = 'base_food';
item.PrintName = 'Water Bottle'
item.Desc = [[
A large bottle of water.
]]
item.Model = "models/warz/consumables/water_l.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 1
item.addWater = 80
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_water_l', item );


--
-- MEDICINE
--

local item = {};
item.base = 'base_food';
item.PrintName = 'Medicine'
item.Desc = [[
Medicine!!!
]]
item.Model = "models/warz/consumables/medicine.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 2
function item:OnUse( pl )
	pl:SetHealth( math.Clamp( pl:Health() + 20, 0, 100 ) );
end
item.lootBias = 0.5
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_medicine', item );

local item = {};
item.base = 'base_food';
item.PrintName = 'Medicine'
item.Desc = [[
Medicine!!!
]]
item.Model = "models/warz/consumables/painkillers.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.lootCount = 2
function item:OnUse( pl )
	pl:SetHealth( math.Clamp( pl:Health() + 10, 0, 100 ) );
end
item.lootBias = 0.5
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'food_painkillers', item );


/*
local item = {};
item.base = 'base_food';
item.PrintName = 'Apple Juice'
item.Desc = [[
Little bottle of apple juice.
]]
item.Model = "models/FoodNHouseholdItems/juicesmall.mdl"
item.Sound = "eating_and_drinking/drinking.wav"
item.addFood = 5
item.addWater = 25;
item.lootBias = 5
gmodz.item.register( 'food_applejuice', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Bacon'
item.Desc = [[
Some strips of dried bacon. High in protine.
]]
item.Model = "models/FoodNHouseholdItems/bacon.mdl"
item.addFood = 20
item.lootBias = 5
gmodz.item.register( 'food_bacon', item );


local item = {};
item.base = 'base_food';
item.PrintName = 'Bacon Slab'
item.Desc = [[
Large slab of bacon strips. High in protine.
]]
item.Model = "models/FoodNHouseholdItems/bacon_2.mdl"
item.addFood = 50
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
item.addWater = 100
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
item.addFood = 30;
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
item.addFood = 30
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
item.addFood = 33
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
item.addFood = 10
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
item.addFood = 40
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
item.addFood = 19
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
item.addFood = 35
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
item.addFood = 34
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
item.addWater = 50
item.lootBias = 8
gmodz.item.register( 'food_orangejuice', item );

*/