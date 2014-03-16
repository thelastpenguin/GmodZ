gmodz.item = {};

local items = {};
function gmodz.item.GetStored( )
	return items;	
end

function gmodz.item.GetMeta( class )
	return items[ class ];
end

function gmodz.item.register( class, table )
	table.class = class;
	items[ class ] = table;
end

function gmodz.item.GetChildren( bClass )
	local cldrn = {};
	for k,v in pairs( items )do
		if v.base == bClass then
			cldrn[ #cldrn + 1 ] = v;
		end
	end	
	return cldrn;
end

do
	local noCopy = {
		baseLinked = true,
		base = true,
		class = true	
	}
	local function linkItem( item )
		if( item.baseLinked )then return end
		
		item.baseLinked = true;
		
		if( item.base and items[ item.base ] )then
			print('linking...');
			local base = items[ item.base ];
			linkItem( base );
			
			for k,v in pairs( base )do
				if not item[ k ] and not noCopy[ k ] then
					item[ k ] = v;
				end
			end
			
		end
	end
	
	function gmodz.runLinker( )
		for _, item in pairs( items )do 
			linkItem( item );
		end
	end
end

--
-- NOW LETS MAKE RECIPES
--
do -- give it it's own registry space.
	gmodz.crafting = {};
	
	
	local recipes = {};
	
	local recipe_mt = {};
	recipe_mt.__index = recipe_mt ;

	function recipe_mt:AddProduct( stack )
		table.insert( self.products, stack );
	end
	function recipe_mt:AddProductEx( item, count, data )
		local stack = gmodz.itemstack.new( item );
		stack:SetCount( count );
		stack:SetData( data );
		if not stack.meta then error("Item "..item..' does not exist!' ); end
		self:AddProduct( stack );
	end
	function recipe_mt:AddMaterial( stack )
		table.insert( self.materials, stack );
	end
	function recipe_mt:AddMaterialEx( item, count, data )
		local stack = gmodz.itemstack.new( item );
		stack:SetCount( count );
		stack:SetData( data );
		if not stack.meta then error("Item "..item..' does not exist!' ); end
		self:AddMaterial( stack );
	end
	function recipe_mt:SetTitle( str )
		self.title = str;
	end
	function recipe_mt:GetTitle( str )
		return self.title;
	end
	
	function recipe_mt:CanMake( inv ) -- takes an inventory and tells if we can make it.
		if not inv then return false end -- aaaaah.
		
		local canMake = true;
		for k,v in pairs( self.materials )do
			if not inv:HaveMaterial( v ) then
				gmodz.print("[RECIPE] "..self:GetTitle().." CAN'T BE MADE. NOT ENOUGH "..v.meta.PrintName );
				canMake = false;
				break ;
			end
		end
		
		return canMake;
	end
	function recipe_mt:Craft( inv )
		for k,v in pairs( self.materials )do
			inv:DeductStack( v );
		end
		
		for k,v in pairs( self.products )do
			inv:AddStack( v );
		end
	end

	function gmodz.crafting.new( )
		return setmetatable( { materials = {}, products = {} }, recipe_mt );
	end
	
	function gmodz.crafting.register( id, tbl )
		tbl.id = id;
		if not tbl.title then
			local p1 = tbl.products[1];
			tbl.title = p1.meta.PrintName;
			if p1:GetCount( ) > 1 then
				tbl.title = p1:GetCount()..'x '..tbl.title;
			end
		end
		recipes[ tbl.id ] = tbl;
	end
	
	function gmodz.crafting.GetAll( )
		return recipes;
	end
	function gmodz.crafting.GetRecipe( id )
		return recipes[ id ];
	end
	
	function gmodz.crafting.GetMakeable( inv )
		local res = {};
		inv = inv or LocalPlayer():GetInv( 'inv' );
		for _, recipe in pairs( recipes )do
			if recipe:CanMake( inv ) then
				res[#res+1] = recipe;
			end
		end
		return res;
	end
	
end


-- LOAD ITEMS
local fol = GM.FolderName .. '/gmodz_items/';
local files = file.Find( fol .. "*.lua", "LUA");
for _, f in SortedPairs( files, true )do
	local p = fol .. f;
	gmodz.include_sh( p );
end

gmodz.runLinker( );

gmodz.hook.Call( 'PostItemsLoaded' );
gmodz.hook.DeleteAll( 'PostItemsLoaded' ) -- this only gets called once...