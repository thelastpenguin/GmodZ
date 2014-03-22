if SERVER then AddCSLuaFile( ) end

SWEP.PrintName = 'Base Ball Bat'
SWEP.Base = 'gmodz_wep_base'
SWEP.Author = 'thelastpenguin'
SWEP.Contact = 'thelastpenguin212@gmail.com'
SWEP.Purpose = "bash n smash"
SWEP.Instructions = 'Left Click to hit'

SWEP.Sounds = string.combinations('weapons/melee/keyboard/keyboard_hit-0',{'1.ogg','2.ogg','3.ogg','4.ogg'})

SWEP.HoldType = "melee"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/warz/melee/baseballbat_spike.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["Bip01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["baseballbat_spike"] = { type = "Model", model = "models/warz/melee/baseballbat_spike.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 2.273, -15.91), angle = Angle(180, 0, 0), size = Vector(1.059, 1.059, 1.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["baseballbat_spike"] = { type = "Model", model = "models/warz/melee/baseballbat_spike.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.599, 2.273, -15), angle = Angle(-164.659, -11.25, 0), size = Vector(1.116, 1.116, 1.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.SwingTime = 1.4;
SWEP.MeleeRange = 60;
SWEP.MeleeSize = Vector( 5, 5, 5 );
SWEP.MeleeDamage = 60

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
