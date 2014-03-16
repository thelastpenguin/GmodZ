ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "GmodZ Item Stack"
ENT.Author = "thelastpenguin"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Type")
	self:NetworkVar("Int",1,"Amount")
end
