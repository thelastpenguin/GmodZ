medit.mapnodes = {};
medit.editing = false;


--
-- START EDITING
--
concommand.Add( 'medit_start', function( )
	medit.mapnodes = {};
	
	chat.AddText(Color(0,200,0),'[MEDIT] ', Color(55,255,55),'Starting edit session.')
	net.Start('medit_ui_RequestNodes');
	net.SendToServer( );
	medit.editing = true ;
end);

--
-- NETWORKING 
--
net.Receive( 'medit_SendNode', function()
	local data = net.ReadTable( );
	local n = medit.newNode():LoadFromTable( data );
	medit.mapnodes[ n:GetID() ] = n;
	gmodz.print('[MEDIT] Received node ('..n:GetID()..')');
end);
net.Receive( 'medit_NodeInvalidate', function()
	medit.mapnodes[ net.ReadUInt( 16 ) ] = nil;
end);
--
-- NODE SYSTEM GUI.
--
concommand.Add( '+medit_CreateNode', function()
	if not medit.editing then chat.AddText( Color(255,0,0), '[MEDIT] ', Color(255,155,0), 'You must be editing first! medit_start'); return end
	if not medit.menu then
		local frame = vgui.Create( 'DPanel' );
		frame:MakePopup();
		frame:SetVisible( true );
		frame:SetSize( ScrH()*0.5, ScrH()*0.4);
		frame:SetPos( 0, ScrH()-frame:GetTall())
		medit.menu = frame;
		
		local optionView = vgui.Create( 'DPanel', frame );
		optionView:SetSize( frame:GetWide()*0.8 - 10, frame:GetTall()-45 );
		optionView:SetPos( frame:GetWide()*0.2 + 5, 35 );
		
		-- NODE TYPES
		local typeList = vgui.Create( "DListView", frame)
		typeList:SetMultiSelect( false )
		typeList:AddColumn( "Type" )
		typeList:SetSize( frame:GetWide()*0.2-10, frame:GetTall()-45);
		typeList:SetPos(5,35);
		
		for k,v in pairs( medit.nodetype.GetStored() )do
			local line = typeList:AddLine( v.PrintName );
			line.nType = v;
		end
		
		function typeList:OnClickLine( line, isSelected )
			if not isSelected then return end
			frame:DisplayType( line.nType ); 
		end
		
		
		-- NODE OPTIONS
		function frame:DisplayType( type )
			local settings = type.settings or {};
			optionView:Clear( );
			
			-- PROPERTY LIST.
			local properties = vgui.Create( 'DProperties', optionView );
			properties:SetSize( optionView:GetWide(), optionView:GetTall() - 30 );
			
			local data = {};
			
			for key, setting in pairs( settings )do
				if setting.type == 'BooleanList' then
					local panels = {};
					local pName = setting.PrintName;
					
					for _, value in pairs( setting.options )do
						
						local cRow = properties:CreateRow( pName, value )
						cRow:Setup( "Boolean" )
						cRow:SetValue( false );
						cRow.string = value;
						cRow.val = 0;
						function cRow:DataChanged( val )
							self.val = val;
						end
						
						table.insert( panels, cRow );
					end
					
					data[ key ] = function()
						local res = {};
						for _, row in pairs( panels )do
							if row.val == 1 then
								table.insert( res, row.string );
							end
						end
						return res;
					end
				elseif setting.type == 'Float' then
					local val = setting.default or 0;
					local cRow = properties:CreateRow( setting.group or 'main', setting.PrintName )
					cRow:Setup( "Float", {min = setting.min or 0, max = setting.max or 1000} )
					cRow:SetValue( val );
					function cRow:DataChanged( _val )
						val = _val;
					end
					
					data[key] = function()
						return val;
					end
				elseif setting.type == 'Boolean' then
					local val = setting.default or false;
					local cRow = properties:CreateRow( setting.group or 'main', setting.PrintName )
					cRow:Setup( "Boolean" )
					cRow:SetValue( val );
					function cRow:DataChanged( _val )
						val = _val;
					end
					
					data[key] = function()
						return val == 1;
					end
				elseif setting.type == 'String' then
					local val = setting.default or '';
					local cRow = properties:CreateRow( setting.group or 'main', setting.PrintName )
					cRow:Setup( "Generic" )
					cRow:SetValue( val );
					function cRow:DataChanged( _val )
						val = _val;
					end
					
					data[key] = function()
						return val;
					end
				elseif setting.type == 'VectorColor' then
					local val = setting.default or Vector(1,0,0);
					local cRow = properties:CreateRow( setting.group or 'main', setting.PrintName )
					cRow:Setup( "VectorColor" )
					cRow:SetValue( val );
					function cRow:DataChanged( _val )
						val = _val;
					end
					
					data[key] = function()
						return Color(val.x*255,val.y*255,val.z*255);
					end
				end
			end
			
			local bDone = vgui.Create( 'DButton', optionView );
			bDone:SetText('DONE!');
			bDone:SetSize( 100, 30 );
			bDone:SetPos( optionView:GetWide() - bDone:GetWide(), optionView:GetTall() - bDone:GetTall( ) );
			function bDone:DoClick( )
				local nData = {};
				for k,v in pairs( data )do
					if isfunction( v ) then
						nData[k] = v();
					end
				end
				
				local tr;
				if type.hull then
					local tracedata = {}
					tracedata.start = EyePos( );
					tracedata.endpos = EyePos( ) + ( EyeAngles():Forward() * 10000 )
					tracedata.filter = LocalPlayer( );
					tracedata.mins = -type.hull;
					tracedata.maxs = type.hull;
					tr = util.TraceHull( tracedata );
				else
					tr = LocalPlayer():GetEyeTrace();
				end
				
				local new = medit.newNode( );
				new:SetPos(  tr.HitPos );
				new:SetAngles( tr.HitNormal:Angle() );
				
				new:SetType( type.class );
				new:SetData( nData );
				local data = new:SaveToTable( );
				net.Start( 'medit_ui_CreateNode' );
					net.WriteTable( data );
				net.SendToServer( );
			end
		end
	else
		medit.menu:SetVisible( true );
	end
end);

concommand.Add( '-medit_CreateNode', function( )
	if ValidPanel( medit.menu ) then
		medit.menu:SetVisible( false );
	end
end);

concommand.Add('medit_RemoveNode', function()
	local dist = 10000000;
	local closest = nil;
	local hitpos = LocalPlayer():GetEyeTrace().HitPos;
	for k,v in pairs( medit.mapnodes )do
		local d = v:GetPos():Distance( hitpos );
		if d < dist then
			dist = d;
			closest = v;
		end
	end
	if not closest then return end;
	
	gmodz.print("[MEDIT] Removed Node "..closest:GetID());
	
	net.Start( 'medit_ui_DelNode' );
		net.WriteUInt( closest:GetID(), 16 );
	net.SendToServer( );
end);


concommand.Add('medit_apply',function()
	net.Start( 'medit_ui_ApplyChanges' );
	net.SendToServer( );
end);

concommand.Add('medit_unload', function()
	net.Start('medit_ui_Unload');
	net.SendToServer( );
end);