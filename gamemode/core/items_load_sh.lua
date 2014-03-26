gmodz.item = {};

--
-- ITEM SYSTEM CORE
--

local items = {};
function gmodz.item.GetStored( )
	return items;	
end

function gmodz.item.GetMeta( class )
	return items[ class ];
end
gmodz.item.Get = gmodz.item.GetMeta;

function gmodz.item.register( class, table )
	table.class = class;
	items[ class ] = table;
end


--
-- ITEM FLAG SYSTEM
--
ITEMFLAG_ADMINONLY = bit.lshift(1,0);
ITEMFLAG_BASECLASS = bit.lshift(1,1);
ITEMFLAG_LOOTABLE = bit.lshift(1,2);

do
	local band = bit.band ;
	function gmodz.item._util_hasflag( meta, flag )
		return band( meta.flags or 0, flag ) > 0 ;
	end
end

--
-- INHERITANCE LINKER.
--
do
	local noCopy = {
		baseLinked = true,
		base = true,
		basemt = true,
		class = true
	}
	local cLinked ;
	local function linkItem( item )
		if( item.baseLinked )then return end
		cLinked = cLinked + 1;
		
		item.baseLinked = true;
		item.children = {};
		
		if( item.base and items[ item.base ] )then
			local base = items[ item.base ];
			item.basemt = base;
			
			linkItem( base ); -- recurse.
			
			base.children[item.class] = item;
			
			for k,v in pairs( base )do
				if item[ k ] == nil and not noCopy[ k ] then
					item[ k ] = v;
				end
			end
			
		end
	end
	
	-- UTILS FOR PRINTING GENERATED TREE
	local function printItem( prefix, item )
		print( prefix..' - '..item.PrintName .. ' ('..item.class..')' );
		local pnext = prefix..'  ';
		for k,v in pairs( item.children )do
			printItem( pnext, v );
		end
	end
	
	local function printItemStruct( )
		printItem( '', items['base'] );
	end
	
	-- FUNCTION CALL TO LINK NODES
	function gmodz.runLinker( )
		gmodz.print('[ITEMLOADER] Running linker...' );
		cLinked = 0;
		for _, item in pairs( items )do 
			linkItem( item );
		end
		printItemStruct( );
		
		gmodz.hook.Call( 'ItemsLinked', items );
		
		gmodz.print('[ITEMLOADER] '..cLinked..' items linked.' );
	end
end

--
-- CRAFTING SYSTEM
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


-- 
-- LASTLY LOAD AND PARSE ITEMS.
--
gmodz.hook.Add( 'LoadComplete', function()
	local fol = GM.FolderName .. '/gmodz_items/';
	local files = file.Find( fol .. "*.lua", "LUA");
	for _, f in SortedPairs( files, true )do
		local p = fol .. f;
		gmodz.include_sh( p );
	end

	gmodz.runLinker( );

	gmodz.hook.Call( 'PostItemsLoaded' );
	gmodz.hook.DeleteAll( 'PostItemsLoaded' ) -- this only gets called once.
	for k,v in pairs( items )do
		gmodz.hook.Call( 'ItemLoaded', v );
	end
end);

-- POST PROCESSING - HANDLE LOOTING PROBABILITIES.