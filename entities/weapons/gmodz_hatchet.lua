if SERVER then AddCSLuaFile( ) end

SWEP.PrintName = 'Fire Axe'
SWEP.Base = 'gmodz_wep_base'
SWEP.Author = 'thelastpenguin'
SWEP.Contact = 'thelastpenguin212@gmail.com'
SWEP.Purpose = "bash n smash"
SWEP.Instructions = 'Left Click to hit'


SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/warz/melee/hatchet.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["gc"] = { type = "Model", model = "models/warz/melee/hatchet.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 1.363, -7.728), angle = Angle(-1.024, 154.432, 180), size = Vector(1.741, 1.741, 1.741), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["sh"] = { type = "Model", model = "models/warz/melee/hatchet.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 3.181, -8.636), angle = Angle(-170.795, -35.795, 1.023), size = Vector(1.286, 1.286, 1.286), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.SwingTime = 1;
SWEP.MeleeRange = 60;
SWEP.MeleeSize = Vector( 5, 5, 5 );
SWEP.MeleeDamage = 60

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
