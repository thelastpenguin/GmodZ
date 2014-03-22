if SERVER then AddCSLuaFile( ) end

SWEP.PrintName = 'Butterfly Knife'
SWEP.Base = 'gmodz_wep_base'
SWEP.Author = 'thelastpenguin'
SWEP.Contact = 'thelastpenguin212@gmail.com'
SWEP.Purpose = "bash n smash"
SWEP.Instructions = 'Left Click to hit'


SWEP.HoldType = "knife"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/warz/melee/butterflyknife.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["v_weapon.knife_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/warz/melee/butterflyknife.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0, 0, 2), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/warz/melee/butterflyknife.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.9, 1, -1.364), angle = Angle(5.113, -86.932, -168.75), size = Vector(0.947, 0.947, 0.947), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.SwingTime = 0.7;
SWEP.MeleeRange = 60;
SWEP.MeleeSize = Vector( 5, 5, 5 );
SWEP.MeleeDamage = 20

SWEP.HitAnim = ACT_VM_HITCENTER
SWEP.MissAnim = ACT_VM_MISSCENTER
