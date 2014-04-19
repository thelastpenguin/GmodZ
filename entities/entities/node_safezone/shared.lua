ENT.Type = "anim"
ENT.PrintName = "GmodZ Safe Zone"
ENT.Author = "thelastpenguin"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int",1,"Radius")
end
