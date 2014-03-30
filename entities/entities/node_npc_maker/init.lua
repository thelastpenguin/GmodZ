ENT.Type = "point"

function ENT:Initialize()
	gmodz.print('[NPC MAKER] Spawned.');
	self.nextTick = 0;
	self.nextSpawn = 0;
end
function ENT:SetNode( node )
	self:SetPos( node:GetPos() );
	
	
	for k,v in pairs( player.GetAll() )do
		v:SetPos( self:GetPos() );
	end
	
	self.data = node:GetData( );
	PrintTable( self.data );
	
	self.npc_class = self.data.npc_class ;
	if not self.npc_class then self:Remove() end
	
	self.max_children = math.Round( tonumber( self.data.max_children ) );
	self.frequency = tonumber( self.data.spawn_rate );
	
	self.children = {};
	self.alive = 0;
end

function ENT:CreateNPC( )
	print("Spawning O.o");
	local n = ents.Create( self.npc_class[math.random(1,#self.npc_class)]);
	n:Spawn( );
	n:SetPos( self:GetPos() + Vector( 0,0,20 ) );
	n:SetAngles( Angle( 0, math.random(-180,180),0) );
	table.insert( self.children, n );
	return n ;
end

function ENT:CanSpawn( )
	for k,v in pairs( ents.FindInSphere( self:GetPos(), 20 ) )do
		if v ~= self then return false end
	end
	return true ;
end
function ENT:CheckPlayersInRange( )
	for k,v in pairs( player.GetAll())do
		if self:Visible( v ) then
			return true ;
		end
	end
	return false ;
end

local isnumber = _G.isnumber ;
function ENT:Think()
	local ctime = CurTime();
	if ctime > self.nextTick and ctime > self.nextSpawn then
		self.nextTick = ctime + 1;
		if not self:CheckPlayersInRange( ) then
			for k,v in pairs( self.children )do
				if IsValid( v )then
					v:Remove();
				end
			end
			return ;
		end
		
		for k,v in pairs( self.children )do
			if not IsValid( v ) then
				self.nextSpawn = ctime + self.frequency ;
				table.remove( self.children, k );
				break ;
			end
		end
		
		if #self.children < self.max_children and self.nextSpawn < ctime and self:CanSpawn() then
			self:CreateNPC( );
			self.nextSpawn = ctime + self.frequency ;
		end
	end
end

/*
function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "disabled" then
		self.Disabled = tonumber(value) == 1
	elseif key == "active" then
		self.Disabled = tonumber(value) == 0
	end
end

function ENT:AcceptInput(name, activator, caller, arg)
	name = string.lower(name)
	if name == "enable" then
		self.Disabled = false
		return true
	elseif name == "disable" then
		self.Disabled = true
		return true
	elseif name == "toggle" then
		self.Disabled = not self.Disabled
		return true
	end
end
*/