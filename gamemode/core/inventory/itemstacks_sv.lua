local gmodz = gmodz;

function gmodz.itemstack.CreateEntity( stack )
	local ent = ents.Create( 'gmodz_itemstack' );
	ent:SetStack( stack );
	ent:Initialize( );
	return ent;
end