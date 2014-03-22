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
SWEP.WorldModel = "models/warz/melee/machete.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["k"] = { type = "Model", model = "models/warz/melee/katana1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.181, 1.363, -5.909), angle = Angle(180, 54.205, 3.068), size = Vector(1.003, 1.003, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["k"] = { type = "Model", model = "models/warz/melee/katana1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1.399, -5.909), angle = Angle(176.932, 72.613, 3.068), size = Vector(1.059, 1.059, 1.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.SwingTime = 2;
SWEP.MeleeRange = 40;
SWEP.MeleeSize = Vector( 5, 5, 5 );
SWEP.MeleeDamage = 100

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
