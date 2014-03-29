gmodz.ScrScale = ScrW()/1600;

surface.CreateFont( "GmodZ_Font64", {
	font = "Michroma",
	size = 64*gmodz.ScrScale,
	weight = 500
} )


surface.CreateFont( "GmodZ_Font48", {
	font = "Michroma",
	size = 48*gmodz.ScrScale,
	weight = 500
} )
surface.CreateFont( "GmodZ_Font3D48", {
	font = "Michroma",
	size = 48,
	weight = 500
} )

surface.CreateFont( "GmodZ_Font32", {
	font = "Michroma",
	size = 32*gmodz.ScrScale,
	weight = 1000,
	antialias = false
} )
surface.CreateFont( "GmodZ_Font3D32", {
	font = "Michroma",
	size = 32,
	weight = 1000,
	antialias = false
} )


surface.CreateFont( "GmodZ_Font28", {
	font = "Michroma",
	size = 28*gmodz.ScrScale,
	weight = 500
} )
surface.CreateFont( "GmodZ_Font28", {
	font = "Michroma",
	size = 28*gmodz.ScrScale,
	weight = 500
} )

surface.CreateFont( "GmodZ_Font3D24", {
	font = "Michroma",
	size = 24,
	weight = 1000
} )

surface.CreateFont( "GmodZ_Font24_OUTLINE", {
	font = "Michroma",
	size = 24,
	weight = 500,
	outline = true
} )

surface.CreateFont( "GmodZ_Font22", {
	font = "Michroma",
	size = 22*gmodz.ScrScale,
	weight = 500
} )
surface.CreateFont( "GmodZ_Font3D22", {
	font = "Michroma",
	size = 22,
	weight = 500
} )



surface.CreateFont( "GmodZ_Font18", {
	font = "Michroma",
	size = 18*gmodz.ScrScale,
	weight = 500
} )
surface.CreateFont( "GmodZ_Font3D18", {
	font = "Michroma",
	size = 18,
	weight = 500
} )
surface.CreateFont( "GmodZ_Font3D18_OUTLINED", {
	font = "Michroma",
	size = 18,
	weight = 200,
	outline = true
} )

surface.CreateFont( "GmodZ_Font12", {
	font = "Roboto",
	size = 12*gmodz.ScrScale,
	weight = 500
} )
surface.CreateFont( "GmodZ_Font3D12", {
	font = "Roboto",
	size = 12,
	weight = 300
} )


surface.CreateFont( "GmodZ_3DH1", {
	font = "Press Style",
	size = 64,
	weight = 500
} )


surface.CreateFont( "GmodZ_KG_64", {
	font = "Press Style",
	size = 64*gmodz.ScrScale,
	weight = 0
} )

surface.CreateFont( "GmodZ_KG_3D32", {
	font = "Press Style",
	size = 32,
	weight = 0
} )
surface.CreateFont( "GmodZ_KG_32", {
	font = "Press Style",
	size = 32*gmodz.ScrScale,
	weight = 0
} )

surface.CreateFont( "GmodZ_KG_3D38", {
	font = "Press Style",
	size = 38,
	weight = 0
} )
surface.CreateFont( "GmodZ_KG_3D48", {
	font = "Press Style",
	size = 48,
	weight = 0
} )
surface.CreateFont( "GmodZ_KG_48", {
	font = "Press Style",
	size = 48*gmodz.ScrScale,
	weight = 0
} )
 
surface.CreateFont( "GmodZ_ItemNameTag", {
	font = "Press Style",
	size = 40*gmodz.ScrScale,
	weight = 0
} )



surface.CreateFont( "GmodZ_Font3D12_OUTLINED", {
	font = "Roboto",
	size = 12,
	weight = 300,
	outline = true
} )
surface.CreateFont( "GmodZ_Font3D18_OUTLINED", {
	font = "Roboto",
	size = 12,
	weight = 300,
	outline = true
} )


surface.CreateFont( "GmodZ_GRUNGE_128", {
	font = "BAD GRUNGE",
	size = 128*gmodz.ScrScale,
	weight = 0
})
surface.CreateFont( "GmodZ_GRUNGE_64", {
	font = "Press Style",
	size = 64*gmodz.ScrScale,
	weight = 0
})



gmodz.font = {};
do
	local heights = {};
	function gmodz.font.LineHeight( name )
		local h = heights[ name ];
		if h then return h end
		
		surface.SetFont( name );
		local w, h = surface.GetTextSize( 'abcdefghijklmnonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' );
		heights[ name ] = h;
		return h;
	end
end