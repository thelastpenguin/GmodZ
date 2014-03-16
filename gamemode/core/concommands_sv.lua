concommand.Add('gmodz_holster', function( pl )
	pl.holstered = pl:GetActiveWeapon( );
	pl:SetActiveWeapon( NULL );
end);

concommand.Add('gmodz_unholster',function( pl )
	pl:SetActiveWeapon( pl.holstered or NULL );
end);


concommand.Add('gmodz_a_give', function( pl, cmd, args )
	if not pl:IsSuperAdmin() then return end
	
	local inv = pl:GetInv('inv');
	if not inv then return end;
	
	local stack = gmodz.itemstack.new( args[1] );
	if not stack.meta then pl:ChatPrint("INVALID ITEM CLASS. "); return end
	stack:SetCount( tonumber( args[2] or '1' ) or 1 );
	
	inv:AddStack( stack );
end );