local OBBMax = Vector(10,10,10);
function medit.DrawNodes( )
	local EyePos = EyePos( );
	local cursorPos = LocalPlayer():GetEyeTrace().HitPos;
	
	local minDist = 10000000;
	local cSelected = nil;
	for _, node in pairs( medit.mapnodes )do
		local p = node:GetPos( );
		local dist = p:Distance( cursorPos );
		if dist < minDist then
			cSelected = node;
			minDist = dist;
		end
		if p:Distance( EyePos ) < 2000 then
			node:Draw( );
		end
	end
	
	if cSelected then
		render.DrawWireframeBox( cSelected:GetPos(), Angle(0,0,0), -(cSelected.hull or OBBMax), (cSelected.hull or OBBMax), 
										color_white, false )
	end
end

gmodz.hook.Add( 'PostDrawTranslucentRenderables', function()
	if not medit.editing then return end
	medit.DrawNodes( );
end);