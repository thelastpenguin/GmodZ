local medit = medit;


local node_mt = {};
node_mt.__index = node_mt;

-- SET NODE TYPE
function node_mt:SetType( id )
	local meta = medit.nodetype.GetMeta( id );
	self.meta = meta;
end
function node_mt:GetType( )
	return self.meta;
end

-- ASSIGN A UNIQUE ID
function node_mt:AssignID( )
	local mapnodes = medit.mapnodes;
	local id = 1;
	while( true )do
		if not mapnodes[ id ] then break end
		id = id + 1;
	end
	
	self.id = id;
	mapnodes[ id ] = self;
	
	return id;
end
function node_mt:GetID()
	return self.id or self:AssignID( );
end


-- NODE DATA
function node_mt:SetData( tbl )
	self.data = tbl;
end
function node_mt:GetData( tbl )
	return self.data;	
end

-- NODE POSITION
function node_mt:SetPos( vec )
	self.pos = vec;
end
function node_mt:GetPos( )
	return self.pos;
end
function node_mt:SetAngles( ang )
	self.ang = ang;
end
function node_mt:GetAngles( )
	return self.ang;
end

-- SAVE / LOAD
function node_mt:SaveToTable( )
	return {
			id = self:GetID(),
			data = self:GetData(),
			type = self:GetType().class,
			pos = self:GetPos( ),
			ang = self:GetAngles( )
		};
end
function node_mt:LoadFromTable( tbl )
	self.id = tbl.id;
	self:SetType( tbl.type );
	self:SetData( tbl.data );
	self:SetPos( tbl.pos );
	self:SetAngles( tbl.ang );
	
	return self;
end

function node_mt:Draw( )
	local mt = self.meta;
	if mt.Draw then
		mt:Draw( self );
	end
end


function medit.newNode( )
	local n = {};
	setmetatable( n, node_mt );
	return n;
end 