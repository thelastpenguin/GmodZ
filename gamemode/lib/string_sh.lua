function string.combinations( val1, tbl1 )
	local res = {};
	for k,v in pairs( tbl1 )do
		res[#res+1] = val1..v;
	end
	return res;
end