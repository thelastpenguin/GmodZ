util.AddNetworkString( 'gmodz_inv_useitem');
net.Receive( 'gmodz_inv_useitem', function( len, pl )
	local invid = net.ReadUInt( 32 );
	local slotid = net.ReadUInt( 16 );
	
	local inv = gmodz.inventory.get( invid );
	if not inv then
		pl:ChatPrint('Inventory ID: '..invid..' does not exist.' );
		return ;
	end
	local stack = inv:GetSlot( slotid );
	if not stack then
		pl:ChatPrint('Inventory slot index '..slotid..' is empty!' );
		return ;
	end
	if not stack.meta.OnUse then
		pl:ChatPrint('Item Meta does not have an \'On Use\' handler defined.');
		return ;
	end
	
	stack:SetCount( stack:GetCount() - 1 );
	if stack:GetCount() == 0 then
		inv:SetSlot( slotid, nil );
	else
		inv:SyncSlot( slotid );
	end
	
	stack.meta:OnUse( pl, stack, inv );
	
	
	
end);
util.AddNetworkString( 'gmodz_inv_dropitem' )
net.Receive( 'gmodz_inv_dropitem', function( len, pl )
	local invid = net.ReadUInt( 32 );
	local slotid = net.ReadUInt( 16 );
	local qty = net.ReadUInt( 8 );
	
	local inv = gmodz.inventory.get( invid );
	if not inv then
		pl:ChatPrint('Inventory ID: '..invid..' does not exist.' );
		return ;
	end
	local stack = inv:GetSlot( slotid );
	if not stack then
		pl:ChatPrint('Inventory slot index '..slotid..' is empty!' );
		return ;
	end
	if qty > stack:GetCount() then
		pl:ChatPrint('Inventory slot does not contain enough items!');
		return ;
	end
	if not stack.meta.DoDrop then
		pl:ChatPrint('Item Meta does not have a \'Do Drop\' handler defined.');
		return ;
	end
	
	stack:SetCount( stack:GetCount() - qty );
	if stack:GetCount() == 0 then
		inv:SetSlot( slotid, nil );
		if pl.activeslot == stack then
			pl:StripWeapons( );
		end
	else
		inv:SyncSlot( slotid );
	end
	
	local dropStack = stack:Copy();
	dropStack:SetCount( qty );
	
	local ent = gmodz.itemstack.CreateEntity( dropStack );
	
	local tracedata = {
			start = pl:EyePos(),
			endpos = pl:EyePos()+pl:EyeAngles():Forward()*10000+Vector(0,0,-10000),
			filter = {pl}
		}
	
	local tres = util.TraceEntity( tracedata, ent );
	ent:SetPos( tres.HitPos );
	
end);