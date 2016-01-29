-- Test suite for the vector library

-- zlib license
-- Copyright (c) 2014-2015 Christiaan Janssen

-- This software is provided 'as-is', without any express or implied
-- warranty. In no event will the authors be held liable for any damages
-- arising from the use of this software.

-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:

-- 1. The origin of this software must not be misrepresented; you must not
--    claim that you wrote the original software. If you use this software
--    in a product, an acknowledgement in the product documentation would be
--    appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be
--    misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

require 'vector'

-- test convenience functions
local get_filename = function()
    local fn = debug.getinfo(2,"S").short_src
    local index = string.find(fn, "/[^/]*$")
    if index then
        return fn:sub(index+1)
    end
    return fn
end

local filename = get_filename()

function compare(result, expected)
    if result == expected then return end
    if type(result) == "number" and type(expected) == "number" and
        math.quantize(result) == math.quantize(expected) then
        return true
    end

    local linenumber = debug.getinfo(2,"l").currentline
    print("FAIL")
    print(filename..":"..linenumber)
    print("result:\n"..tostring(result))
    print("expected:\n"..tostring(expected))
    error()
end

function runTests(tests)
    local passedCount = 0
    for i=1,#tests do
        io.write("....test "..i.." ..")
        local passed,errmsg = pcall(tests[i])
        if passed then
            print("OK")
            passedCount = passedCount + 1
        elseif errmsg then
                print("FAIL")
                print(errmsg)
        end
    end

    print("\nPassed "..passedCount.." / "..#tests.." tests")
end

tests = {
    function()
        -- convenience math functions

        -- sign
        compare(math.sign(10), 1)
        compare(math.sign(0), 1)
        compare(math.sign(-10),-1)


        -- round
        compare(math.round(9.5), 10)
        compare(math.round(9.7), 10)
        compare(math.round(10.2), 10)
        compare(math.round(10), 10)
        compare(math.round(10.5), 11)
        compare(math.round(-11.7), -12)

        -- clamp
        compare(math.clamp(2,-1,5), 2)
        compare(math.clamp(2,2,5), 2)
        compare(math.clamp(2,4,5), 4)
        compare(math.clamp(2,5,5), 5)
        compare(math.clamp(2,10,5), 5)
    end,

    function()
        -- create vectors
        local a = Vector(10,20)
        compare(a.x, 10)
        compare(a.y, 20)

        local b = VectorFromAngle(math.pi*0.5)
        compare(b.x, 0)
        compare(b.y, 1)

        local c = VectorFromPolar(10, math.pi)
        compare(c.x, -10)
        compare(c.y, 0)
    end,

    function()
        -- vector with data
        local a = Vector(1,2,{txt = "test"})
        compare(a.txt, "test")

        local b = a * 10
        compare(b.x, 10)
        compare(b.txt, nil)

        local c = Vector(1,2,"test")
        compare(c.txt, nil)
        compare(#c, 0)
    end,

    function()
        -- Getting components:
        local a = Vector(30,40)
        compare(a.x, 30)
        compare(a.y, 40)
        compare(a:mod(), 50)
        compare(Vector(5,5):angle(), math.pi/4)
    end,

    function()
        -- Comparisons:
        compare(Vector():isZero(), true)
        compare(Vector(1,1):isZero(), false)

        -- this test relies on the implementation of "quant" to avoid rounding errors
        local a = Vector(0,100)
        local b = Vector(0,100)
        compare(a:isEq(b), true)
        local c = VectorFromPolar(100, math.pi/2):quant()
        compare(a:isEq(c), true)
    end,

    function()
        -- product by scalar
        local a = Vector(1,2)
        compare(a.x,1)
        compare(a.y,2)

        local b = a * 2
        compare(b.x, 2)
        compare(b.y, 4)

        local c = 0.5 * a
        compare(c.x, 0.5)
        compare(c.y, 1)

        -- sum
        local d = a + Vector(2,1)
        compare(d.x, 3)
        compare(d.y, 3)

        -- difference
        local e = a - Vector(1,1)
        compare(e.x, 0)
        compare(e.y, 1)

        -- per-component product
        local f = a^b
        compare(f.x, 2)
        compare(f.y, 8)

        -- division by scalar
        local g = Vector(10,100)
        local h = g / 2
        compare(h.x, 5)
        compare(h.y, 50)

        -- divide scalar by vector
        local i = 1000 / g
        compare(i.x, 100)
        compare(i.y, 10)

        -- modulo
        local j = Vector(30, 45)
        local k = j % Vector(12, 16)
        local l = j % 18
        compare(k.x, 6)
        compare(k.y, 13)
        compare(l.x, 12)
        compare(l.y, 9)
    end,

    function()
        -- clone
        local a = Vector(1,-1)
        local b = a:copy()
        local c = a
        compare(b:isEq(a), true)
        compare(c:isEq(a), true)

        -- make sure that the clone is not a reference
        b.y = 10
        compare(b:isEq(a), false)
        compare(c:isEq(a), true)
    end,

    function()
        -- more operations

        -- normalize
        local a = Vector(10,-10)
        local b = a:norm()
        compare(a:mod(), 10 * math.sqrt(2))
        compare(b:mod(), 1)

        -- absolute value
        local c = a:abs()
        compare(c.x, 10)
        compare(c.y, 10)

        -- floor and round
        local d = Vector(2.4, 2.5)
        local e = d:floor()
        local f = d:round()
        compare(e.x, 2)
        compare(e.y, 2)
        compare(f.x, 2)
        compare(f.y, 3)

        -- get the sign of the components
        local g = a:sign()
        compare(g.x, 1)
        compare(g.y, -1)

        -- mirror (vector in the opposite direction)
        local h = -a
        compare(h.x, -10)
        compare(h.y, 10)
    end,

    function()
        -- rotation
        local a = Vector(10,10)
        local b = a:rot(math.pi/4)
        compare(b:mod(),a:mod())
        compare(b:angle(),math.pi/2)
        compare(a:angleBetween(b), math.pi/4)

        -- test quantize (checking booleans to avoid the embedded quantize in compare)
        compare(b.x == 0, false)
        compare(b:quant().x == 0, true)

        -- orthogonal vectors
        local c = a:ortho()
        local d = -a:ortho()
        compare(c.x, 10)
        compare(c.y, -10)
        compare(d.x, -10)
        compare(d.y, 10)
    end,

    function()
        -- clamp
        local min = Vector(0, 100)
        local max = Vector(10, 110)

        local a = Vector(-1, -1):clamp(min, max)
        compare(a.x, 0)
        compare(a.y, 100)

        local b = Vector(5,5):clamp(min, max)
        compare(b.x, 5)
        compare(b.y, 100)

        local c = Vector(50,50):clamp(min, max)
        compare(c.x, 10)
        compare(c.y, 100)

        local d = Vector(105,105):clamp(min, max)
        compare(d.x, 10)
        compare(d.y, 105)

        local e = Vector(200,200):clamp(min, max)
        compare(e.x, 10)
        compare(e.y, 110)
    end,

    function()
        local a = Vector(3,4)
        local b = Vector(5,6)

        -- dot product
        compare(a*b, 39)

        -- unpack
        local x,y = a:unpack()
        compare(x, 3)
        compare(y, 4)
    end,

    function()
        -- some examples of vector use
        local pos1 = Vector(10, 0)
        local pos2 = Vector(20, 10)

        -- distance
        local dist = (pos1 - pos2):mod()
        compare(dist, 10*math.sqrt(2))

        -- angle from point to point
        local ang = (pos2 - pos1):angle()
        compare(ang, math.pi/4)

        -- linear movement
        local speed = 10 * math.sqrt(2)
        local angle = -math.pi/4
        local timestep = 0.1
        local newPos = pos1 + timestep * VectorFromPolar(speed,angle)
        compare(newPos.x, 11)
        compare(newPos.y, -1)

        -- field of view
        local fov_angle = math.pi/3
        local relative_angle_of_pos2 = (newPos - pos1):angleBetween(pos2 - pos1)
        local is_in_sight = relative_angle_of_pos2 < fov_angle
        compare(is_in_sight, false)

    end,

}

-- run them
runTests(tests)
