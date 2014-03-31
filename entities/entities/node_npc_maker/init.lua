ENT.Type = "point"

function ENT:Initialize()
	gmodz.print('[NPC MAKER] Spawned.');
	self.nextTick, self.nextSpawn = 0, 0 ;
end
function ENT:SetNode( node )
	self:SetPos( node:GetPos() );
	
	
	self.data = node:GetData( );
	
	self.npc_class = self.data.npc_class ;
	if not self.npc_class then self:Remove() end
	
	self.max_children = math.Round( tonumber( self.data.max_children ) );
	self.frequency = tonumber( self.data.spawn_rate );
	
	self.children = {};
end

function ENT:CreateNPC( )
	print("Spawning O.o");
	local n = ents.Create( self.npc_class[math.random(1,#self.npc_class)]);
	if not IsValid( n ) then return end
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

function ENT:FindNearestPlayer( )
	local p, d = nil, 2500;
	local mpos = self:GetPos();
	for k,v in pairs( player.GetAll() )do
		if mpos:Distance( v:GetPos() ) < d then
			p = v;
		end
	end
	return p;
end



function ENT:GetLiveChildren( )
	for k,v in pairs( self.children )do 
		if not IsValid( v ) then
			table.remove( self.children, k );
			self.nextTick = CurTime() + self.frequency ;
			return self:GetLiveChildren( );
		end
	end
	return self.children ;
end

function ENT:SlowThink( )
	local ctime = CurTime( );
	local pClosest = self:FindNearestPlayer( );
	
	if IsValid( pClosest ) then
		if pClosest:GetPos():Distance( self:GetPos() ) < 500 then return end -- too close.
		
		if #self.children < self.max_children then
			self.nextTick = CurTime() + self.frequency ;
			self:CreateNPC( );
		end
		
		local cldrn = self:GetLiveChildren();
	else
		-- REMOVE CHILDREN OUT OF RANGE
		for k,v in pairs( self.children )do
			if IsValid( v )then
				v:Remove();
			end
		end
	end
	
end

local isnumber = _G.isnumber ;
function ENT:Think()
	local ctime = CurTime();
	if ctime > self.nextTick then
		self.nextTick = ctime + 1;
		self:SlowThink( );
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