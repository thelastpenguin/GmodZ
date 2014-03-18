
--
-- BASE CLASS FOR ALL ITEMS IN THIS FILE
--
local item = {};

item.base = 'base';
item.PrintName = 'FAS2 Base'
item.StackSize = 1
item.Desc = [[
A trusty metal crowbar. 
Useful for prying open locks or bashing in brains.
]]
item.Model = 'models/weapons/w_crowbar.mdl'
item.Weapon = 'weapon_crowbar'
item.lootBias = 1

gmodz.item.register( 'base_fas2', item );


-- AK-12
local item = {};

item.base = 'base_fas2';
item.PrintName = 'AK-12'
item.StackSize = 1
item.Desc = [[
The Kalashnikov AK-12 is the newest derivative of the Soviet/Russian AK-47 series of assault rifles and was proposed for possible general issue to the Russian Army.
]]
item.Model = "models/weapons/world/rifles/ak12.mdl"
item.SVModel = "models/weapons/world/rifles/ak12.mdl"
item.Weapon = 'fas2_ak12'
item.lootBias = 0.84

gmodz.item.register( 'weapon_fas2_ak12', item );


-- AK-12
local item = {};

item.base = 'base_fas2';
item.PrintName = 'AK-12'
item.StackSize = 1
item.Desc = [[
A gun.
]]
item.Model = "models/weapons/world/rifles/ak12.mdl"
item.SVModel = "models/weapons/world/rifles/ak12.mdl"
item.Weapon = 'fas2_ak12'
item.lootBias = 0.9

gmodz.item.register( 'weapon_fas2_ak12', item );


-- fas2_ak47
local item = {};

item.base = 'base_fas2';
item.PrintName = 'AK-47'
item.StackSize = 1
item.Desc = [[
The AK-47 is a selective-fire, gas-operated 7.62×39mm assault rifle, first developed in the Soviet Union by Mikhail Kalashnikov.
]]
item.Model = "models/weapons/w_ak47.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_ak47'
item.lootBias = 0.8

gmodz.item.register( 'weapon_fas2_ak47', item );


-- fas2_ak74
local item = {};

item.base = 'base_fas2';
item.PrintName = "AK-74"
item.StackSize = 1
item.Desc = [[
The AK-74 is an assault rifle developed in the early 1970s in the Soviet Union as the replacement for the earlier AKM.
]]
item.Model = "models/weapons/w_ak47.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_ak74'

gmodz.item.register( 'weapon_fas2_ak74', item );



-- fas2_an94
local item = {};

item.base = 'base_fas2';
item.PrintName = "AN-94"
item.StackSize = 1
item.Desc = [[
The AN-94 is an advanced assault rifle of Russian origin.
]]
item.Model = "models/weapons/world/rifles/an94.mdl"
item.SVModel = "models/weapons/world/rifles/an94.mdl"
item.Weapon = 'fas2_an94'

gmodz.item.register( 'weapon_fas2_an94', item );


-- fas2_deagle
local item = {};

item.base = 'base_fas2';
item.PrintName = "Desert Eagle"
item.StackSize = 1
item.Desc = [[
The Israel Military Industries Desert Eagle is a large-framed gas-operated semi-automatic pistol designed by Magnum Research in the US together with IMI in Israel.
]]
item.Model = "models/weapons/w_deserteagle.mdl"
item.SVModel = "models/weapons/w_pist_deagle.mdl"
item.Weapon = 'fas2_deagle'
item.lootBias = 1.5

gmodz.item.register( 'weapon_fas2_deagle', item );


-- fas2_dv2
/*local item = {};

item.base = 'base_fas2';
item.PrintName = "Combat Knife"
item.StackSize = 1
item.Desc = [[
Slash and gash.
]]
item.Model = "models/weapons/w_dv2.mdl"
item.SVModel = "models/weapons/w_dv2.mdl"
item.Weapon = 'fas2_dv2'
gmodz.item.register( 'weapon_fas2_combatknife', item );*/

-- fas2_famas
local item = {};

item.base = 'base_fas2';
item.PrintName = "FAMAS F1"
item.StackSize = 1
item.Desc = [[
The FAMAS is a bullpup-styled assault rifle designed and manufactured in France.
]]
item.Model = "models/weapons/w_famas.mdl"
item.SVModel = "models/weapons/w_rif_famas.mdl"
item.Weapon = 'fas2_famas'
item.lootBias = 0.5

gmodz.item.register( 'weapon_fas2_famas', item );


-- fas2_g3
local item = {};

item.base = 'base_fas2';
item.PrintName = "G3A3"
item.StackSize = 1
item.Desc = [[
A powerful gun...
]]
item.Model = "models/weapons/w_g3a3.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_g3'
item.lootBias = 0.3

gmodz.item.register( 'weapon_fas2_g3', item );


-- fas2_g36c
local item = {};

item.base = 'base_fas2';
item.PrintName = "G36C"
item.StackSize = 1
item.Desc = [[
The G36C is a Compact variant of the G36.
]]
item.Model = "models/weapons/w_g36e.mdl"
item.SVModel = "models/weapons/w_rif_m4a1.mdl"
item.Weapon = 'fas2_g36c'
item.lootBias = 0.8

gmodz.item.register( 'weapon_fas2_g36c', item );


-- fas2_galil
local item = {};

item.base = 'base_fas2';
item.PrintName = "IMI Galil"
item.StackSize = 1
item.Desc = [[
The Galil is a family of Israeli small arms designed by Yisrael Galil and Yaacov Lior in the late 1960s and produced by Israel Military Industries Ltd of Ramat HaSharon.
]]
item.Model = "models/weapons/view/rifles/galil.mdl"
item.SVModel = "models/weapons/w_rif_galil.mdl"
item.Weapon = 'fas2_galil'
item.lootBias = 0.9

gmodz.item.register( 'weapon_fas2_galil', item );


-- fas2_glock20
local item = {};

item.base = 'base_fas2';
item.PrintName = "Glock-20"
item.StackSize = 1
item.Desc = [[
The Glock 20, introduced in 1991, was developed for the then-growing law enforcement and security forces market for the 10mm Auto.
]]
item.Model = "models/weapons/w_pist_glock18.mdl"
item.SVModel = "models/weapons/w_pist_glock18.mdl"
item.Weapon = 'fas2_glock20'
item.lootBias = 2

gmodz.item.register( 'weapon_fas2_glock20', item );



-- fas2_ks23
local item = {};

item.base = 'base_fas2';
item.PrintName = "KS-23"
item.StackSize = 1
item.Desc = [[
The KS-23 is a Russian shotgun, although because it uses a rifled barrel it is officially designated by the Russian military as a carbine. 
]]
item.Model = "models/weapons/world/shotguns/ks23.mdl"
item.SVModel = "models/weapons/w_shot_m3super90.mdl"
item.Weapon = 'fas2_ks23'
item.lootBias = 1

gmodz.item.register( 'weapon_fas2_ks23', item );


-- fas2_m3s90
local item = {};

item.base = 'base_fas2';
item.PrintName = "M3 Super 90"
item.StackSize = 1
item.Desc = [[
The Benelli M3 (Super 90) is a dual-mode (both pump-action and semi-automatic) shotgun designed and manufactured by Italian firearms manufacturer Benelli.
]]
item.Model = "models/weapons/w_m3.mdl"
item.SVModel = "models/weapons/w_shot_m3super90.mdl"
item.Weapon = 'fas2_m3s90'
item.lootBias = 0.5

gmodz.item.register( 'weapon_fas2_m3s90', item );


-- fas2_m4a1
local item = {};

item.base = 'base_fas2';
item.PrintName = "M4A1"
item.StackSize = 1
item.Desc = [[
The M4A1 carbine is a fully automatic variant of the basic M4 carbine intended for special operations use.
]]
item.Model = "models/weapons/w_m4.mdl"
item.SVModel = "models/weapons/w_rif_m4a1.mdl"
item.Weapon = 'fas2_m4a1'
item.lootBias = 1.1

gmodz.item.register( 'weapon_fas2_m4a1', item );


-- fas2_m14
local item = {};

item.base = 'base_fas2';
item.PrintName = "M14"
item.StackSize = 1
item.Desc = [[
The M14 rifle is an American selective fire automatic rifle that fires 7.62×51mm NATO ammunition.
]]
item.Model = "models/weapons/w_m14.mdl"
item.SVModel = "models/weapons/w_snip_awp.mdl"
item.Weapon = 'fas2_m14'
item.lootBias = 1.1

gmodz.item.register( 'weapon_fas2_m14', item );


-- fas2_m21
local item = {};

item.base = 'base_fas2';
item.PrintName = "M21"
item.StackSize = 1
item.Desc = [[
The M21 Sniper Weapon System (SWS) is the semi-automatic sniper rifle adaptation of the M14 rifle.
]]
item.Model = "models/weapons/w_m14.mdl"
item.SVModel = "models/weapons/w_snip_awp.mdl"
item.Weapon = 'fas2_m21'
item.lootBias = 0.1

gmodz.item.register( 'weapon_fas2_m21', item );


-- fas2_m24
local item = {};

item.base = 'base_fas2';
item.PrintName = "M24"
item.StackSize = 1
item.Desc = [[
The M24 Sniper Weapon System (SWS) is the military and police version of the Remington 700 rifle
]]
item.Model = "models/weapons/w_m24.mdl"
item.SVModel = "models/weapons/w_snip_awp.mdl"
item.Weapon = 'fas2_m24'
item.lootBias = 0.1

gmodz.item.register( 'weapon_fas2_m24', item );



-- fas2_m79
/*local item = {};

item.base = 'base_fas2';
item.PrintName = "M79"
item.StackSize = 1
item.Desc = [[
M79
]]
item.Model = "models/weapons/w_m79.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_m79'

gmodz.item.register( 'weapon_fas2_m79', item );
*/
 	


-- fas2_m67
/*local item = {};

item.base = 'base_fas2';
item.PrintName = "Grenade"
item.StackSize = 1
item.Desc = [[
A frag grenade.
]]
item.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl"
item.SVModel = "models/weapons/w_eq_fraggrenade_thrown.mdl"
item.Weapon = 'fas2_m67'

gmodz.item.register( 'weapon_fas2_m67', item );*/


-- fas2_m82
local item = {};

item.base = 'base_fas2';
item.PrintName = "M82"
item.StackSize = 1
item.Desc = [[
The M82, standardized by the US Military as the M107, is a recoil-operated, semi-automatic anti-materiel rifle
]]
item.Model = "models/weapons/w_m82.mdl"
item.SVModel = "models/weapons/w_snip_sg550.mdl"
item.Weapon = 'fas2_m82'
item.lootBias = 0.05

gmodz.item.register( 'weapon_fas2_m82', item );


-- fas2_m1191
/*local item = {};

item.base = 'base_fas2';
item.PrintName = "M1911"
item.StackSize = 1
item.Desc = [[
The M1911 is a single-action, semi-automatic, magazine-fed, recoil-operated pistol
]]
item.Model = "models/weapons/w_1911.mdl"
item.SVModel = "models/weapons/w_pist_p228.mdl"
item.Weapon = 'fas2_m1191'

gmodz.item.register( 'weapon_fas2_m1191', item );*/



-- fas2_machete
/*local item = {};

item.base = 'base_fas2';
item.PrintName = "Machete"
item.StackSize = 1
item.Desc = [[
Clearing a path... of zombies.
]]
item.Model = "models/weapons/w_machete.mdl"
item.SVModel = "models/weapons/w_machete.mdl"
item.Weapon = 'fas2_machete'

gmodz.item.register( 'weapon_fas2_machete', item );*/



-- fas2_mp5a5
local item = {};

item.base = 'base_fas2';
item.PrintName = "MP5A5"
item.StackSize = 1
item.Desc = [[
The MP5A5 features a sliding stock and four-position trigger groups.
]]
item.Model = "models/weapons/w_mp5.mdl"
item.SVModel = "models/weapons/w_smg_mp5.mdl"
item.Weapon = 'fas2_mp5a5'
item.lootBias = 1

gmodz.item.register( 'weapon_fas2_mp5a5', item );




-- fas2_mp5k
local item = {};

item.base = 'base_fas2';
item.PrintName = "MP5K"
item.StackSize = 1
item.Desc = [[
MP5K
]]
item.Model = "models/weapons/w_mp5.mdl"
item.SVModel = "models/weapons/w_smg_mp5.mdl"
item.Weapon = 'fas2_mp5k'
item.lootBIas = 0.9

gmodz.item.register( 'weapon_fas2_mp5k', item );



-- fas2_ots33
local item = {};

item.base = 'base_fas2';
item.PrintName = "OTs-33 Pernach"
item.StackSize = 1
item.Desc = [[
The OTs-33 Pernach is a Russian 9x18 Makarov machine pistol
]]
item.Model = "models/weapons/world/pistols/ots33.mdl"
item.SVModel = "models/weapons/world/pistols/ots33.mdl"
item.Weapon = 'fas2_ots33'
item.lootBias = 0.6

gmodz.item.register( 'weapon_fas2_ots33', item );


-- fas2_p226
local item = {};

item.base = 'base_fas2';
item.PrintName = "P226"
item.StackSize = 1
item.Desc = [[
The SIG P226 is a full-sized, service-type pistol made by SIG Sauer.
]]
item.Model = "models/weapons/w_pist_p228.mdl"
item.SVModel = "models/weapons/w_pist_p228.mdl"
item.Weapon = 'fas2_p226'
item.lootBias = 2.3

gmodz.item.register( 'weapon_fas2_p226', item );



-- fas2_pp19
local item = {};

item.base = 'base_fas2';
item.PrintName = "PP-19 Bizon"
item.StackSize = 1
item.Desc = [[
The Bizon is primarily intended for counter-terrorist and law enforcement units that usually need fast and accurate fire at close ranges.
]]
item.Model = "models/weapons/w_smg_biz.mdl"
item.SVModel ="models/weapons/w_smg_biz.mdl"
item.Weapon = 'fas2_pp19'
item.lootBias = 0.9

gmodz.item.register( 'weapon_fas2_pp19-bizon', item );



-- fas2_pp19
local item = {};

item.base = 'base_fas2';
item.PrintName = "Raging Bull"
item.StackSize = 1
item.Desc = [[
The Raging Bull is a revolver. 
In its larger calibers it is marketed as a hunter's sidearm because it is a potent weapon with plenty of stopping power.
]]
item.Model = "models/weapons/view/pistols/ragingbull.mdl"
item.SVModel = "models/weapons/w_357.mdl"
item.Weapon = 'fas2_ragingbull'
item.lootBias = 1.4

gmodz.item.register( 'weapon_fas2_ragingbull', item );


-- fas2_rem870
local item = {};

item.base = 'base_fas2';
item.PrintName = "Remington 870"
item.StackSize = 1
item.Desc = [[
Remington 870
]]
item.Model = "models/weapons/w_m3.mdl"
item.SVModel = "models/weapons/w_shot_m3super90.mdl"
item.Weapon = 'fas2_rem870'
item.lootBias = 1.5

gmodz.item.register( 'weapon_fas2_rem870', item );



-- fas2_rk95
local item = {};

item.base = 'base_fas2';
item.PrintName = "Sako RK-95"
item.StackSize = 1
item.Desc = [[
The RK 95 TP (known commercially as the M95) is a 7.62x39mm Finnish assault rifle
]]
item.Model = "models/weapons/world/rifles/rk95.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_rk95'
item.lootBias = 1.2

gmodz.item.register( 'weapon_fas2_rk95', item );



-- fas2_sg550
local item = {};

item.base = 'base_fas2';
item.PrintName = "SG 550"
item.StackSize = 1
item.Desc = [[
]]
item.Model = "models/weapons/w_sg550.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_sg550'
item.lootBias = 0.5

gmodz.item.register( 'weapon_fas2_sg550', item );



-- fas2_sg552
local item = {};

item.base = 'base_fas2';
item.PrintName = "SG 552"
item.StackSize = 1
item.Desc = [[

]]
item.Model = "models/weapons/w_sg550.mdl"
item.SVModel = "models/weapons/w_rif_ak47.mdl"
item.Weapon = 'fas2_sg552'
item.lootBias = 0.4

gmodz.item.register( 'weapon_fas2_sg552', item );


-- fas2_sks
local item = {};

item.base = 'base_fas2';
item.PrintName = "SKS"
item.StackSize = 1
item.Desc = [[
The SKS is a Soviet semi-automatic carbine chambered for the 7.62×39mm round
]]
item.Model = "models/weapons/world/rifles/sks.mdl"
item.SVModel = "models/weapons/w_snip_awp.mdl"
item.Weapon = 'fas2_sks'
item.lootBias = 1

gmodz.item.register( 'weapon_fas2_sks', item );



-- fas2_sr25
local item = {};

item.base = 'base_fas2';
item.PrintName = "SR-25"
item.StackSize = 1
item.Desc = [[
The SR-25 is a semi-automatic special application sniper rifle
]]
item.Model = "models/weapons/w_sr25.mdl"
item.SVModel = "models/weapons/w_snip_sg550.mdl"
item.Weapon = 'fas2_sr25'
item.lootBias = 0.08

gmodz.item.register( 'weapon_fas2_sr25', item );


-- fas2_toz34
local item = {};

item.base = 'base_fas2';
item.PrintName = "TOZ-34"
item.StackSize = 1
item.Desc = [[
The TOZ-34 is an over/under style hunting shotgun
]]
item.Model = "models/weapons/world/rifles/ak12.mdl"
item.SVModel = "models/weapons/world/rifles/ak12.mdl"
item.Weapon = 'fas2_toz34'
item.lootBias = 1.7

gmodz.item.register( 'weapon_fas2_toz34', item );



-- fas2_uzi
local item = {};

item.base = 'base_fas2';
item.PrintName = "IMI Uzi"
item.StackSize = 1
item.Desc = [[
The Uzi is a family of Israeli open-bolt, blowback-operated submachine guns.
]]
item.Model = "models/weapons/w_mp5.mdl"
item.SVModel = "models/weapons/w_smg_mp5.mdl"
item.Weapon = 'fas2_uzi'
item.lootBias = 1.7

gmodz.item.register( 'weapon_fas2_uzi', item );





