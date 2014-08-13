
function math.sign(a) return a>=0 and 1 or -1 end

local Vector_proto = {
	copy = function(self) return Vector(self.x,self.y) end,
	norm = function(self) 
		local m = self:mod()
		m = m == 0 and 1 or 1/m
		return m*self
	end,
	mod = function(self)
		return math.sqrt(self*self)
	end,
	angle = function(self)
       return math.atan2(self.y,self.x)
	end,
	abs = function(self)
		return Vector(math.abs(self.x),math.abs(self.y))
	end,
	sign = function(self)
		return Vector(math.sign(self.x),math.abs(self.y))
	end,
	isZero = function(self)
		return self.x == 0 and self.y == 0
	end,
	rot = function(self, angle)
		local c,s = math.cos(angle), math.sin(angle)
		return Vector(self.x*c-self.y*s, self.x*s+self.y*c)
	end,
	floor = function(self)
		return Vector(math.floor(self.x),math.floor(self.y))
	end,
}

local Vector_mt = {
		__index = function(table, key) return Vector_proto[key] end,
		__add = function(lt,rt) return Vector(lt.x+rt.x,lt.y+rt.y) end,
		__sub = function(lt,rt) return Vector(lt.x-rt.x,lt.y-rt.y) end,
		__mul = function(lt,rt)
			if type(lt) == "number" then return Vector(lt*rt.x,lt*rt.y) end
			if type(rt) == "number" then return Vector(lt.x*rt,lt.y*rt) end
			return lt.x*rt.x + lt.y*rt.y
		end,
		__pow = function(lt,rt)
			-- note: there's no easy way to tell the difference between dot product and per-element product
			-- we will use pow for the second one
			return Vector(lt.x*rt.x, lt.y*rt.y)
		end,
	}


function Vector(x,y)
	local vec = { x = x or 0, y = y or 0 }
	setmetatable(vec,Vector_mt)
	return vec
end

function VectorFromAngle(angle)
	return Vector(math.cos(angle),math.sin(angle))
end

function VectorFromPolar(mod, angle)
	return VectorFromAngle(angle)*mod
end