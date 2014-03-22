function gmodz.Memoize(fn)
    fn = fn or function(x) return nil end
    return setmetatable({},
      {
       __index = function(t, k)
                   local val = fn(k)
                   t[k] = val
                   return val
                 end,
       __call  = function(t, k)
                   return t[k]
                 end
      })
end


local function pack( ... )
    return { ... }
end

function gmodz.MemoizeEx( fn )
    local function fnKey( ... )
        local arg = pack( ... );
        local key = ""
        for i = 1, table.getn( arg ) do
            key = key .. "[" .. tostring( arg[ i ] ) .. "]"
        end
        return key 
    end

    local object = {
        __call  = function( targetTable, ... )
            local key = fnKey( ... )
            local values = targetTable.__memoized[ key ]

            if ( values == nil ) then
                values = pack( fn( ... ) )
                targetTable.__memoized[ key ] = values
            end

            if ( table.getn( values ) > 0 ) then
                return unpack( values )
            end

            return nil
        end,
        __forget = function( self ) self.__memoized = {} end,
        __memoized = {},
        __mode = "v",
    }

    return setmetatable( object, object )
end