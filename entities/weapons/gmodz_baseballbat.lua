if SERVER then AddCSLuaFile( ) end

SWEP.PrintName = 'Base Ball Bat'
SWEP.Base = 'gmodz_wep_base'
SWEP.Author = 'thelastpenguin'
SWEP.Contact = 'thelastpenguin212@gmail.com'
SWEP.Purpose = "bash n smash"
SWEP.Instructions = 'Left Click to hit'

SWEP.Sounds = string.combinations('sound/weapons/melee/keyboardkeyboard_hit-0',{'1.ogg','2.ogg','3.ogg','4.ogg'})

SWEP.HoldType = "melee"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/warz/melee/baseballbat.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["Bip01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["models/warz/melee/baseballbat.mdl"] = { type = "Model", model = "models/warz/melee/baseballbat.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 1.363, -3.182), angle = Angle(1.023, -7.159, 180), size = Vector(1.116, 1.116, 1.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["baseballbat"] = { type = "Model", model = "models/warz/melee/baseballbat.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.039, 2.23, -5), angle = Angle(180, 3.068, 0), size = Vector(1.343, 1.343, 1.343), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Primary.Delay  = 1.4;
SWEP.MeleeRange = 60;
SWEP.MeleeSize = Vector( 5, 5, 5 );
SWEP.MeleeDamage = 35	

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
