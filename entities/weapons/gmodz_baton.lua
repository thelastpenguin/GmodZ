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
SWEP.WorldModel = "models/warz/melee/nailgun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["m"] = { type = "Model", model = "models/warz/melee/policebaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 3.181, 2.273), angle = Angle(180, -170.795, 0), size = Vector(1.343, 1.343, 1.343), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w"] = { type = "Model", model = "models/warz/melee/policebaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.363, 1, -5), angle = Angle(0, 72.613, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.SwingTime = 1;
SWEP.MeleeRange = 60;
SWEP.MeleeSize = Vector( 5, 5, 5 );
SWEP.MeleeDamage = 30

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
