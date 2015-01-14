require 'vector'

-- test convenience functions
local get_filename = function() 
    local fn = debug.getinfo(2,"S").short_src
    local index = string.find(fn, "/[^/]*$")
    return fn:sub(index+1)
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


-- Notes:

--      * isZero(v) = (x,y) == (0,0)
--      * sign(a) = a>=0 ? 1 : -1
--      * ortho(x,y) = (y,-x)
--      * -ortho(x,y) = (-y,x)
--      * dist(v1,v2) = (v2-v1):mod()
--      * v2 = v1:rot(v2/v1)
--      * unpack does not return data


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
        -- note: prevent rounding errors
        compare(b.x, 0)
        compare(b.y, 1)

        local c = VectorFromPolar(10, math.pi)
        -- note: prevent rounding errors
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
        local b = VectorFromPolar(100, math.pi/2):quant()
        compare(a:isEq(b), true)
    end,

    function()
        -- products
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

        local i = 1000 / g
        compare(i.x, 100)
        compare(i.y, 10)
    end,

    function()
        -- clone
        local a = Vector(1,-1)
        local b = a:copy()
        local c = a
        compare(b:isEq(a), true)
        compare(c:isEq(a), true)
        b.y = 10
        compare(b:isEq(a), false)
        compare(c:isEq(a), true)
    end,

    function()
        -- more operations:
        local a = Vector(10,-10)
        local b = a:norm()
        compare(a:mod(), 10 * math.sqrt(2))
        compare(b:mod(), 1)

        local c = a:abs()
        compare(c.x, 10)
        compare(c.y, 10)

        local d = Vector(2.4, 2.5)
        local e = d:floor()
        local f = d:round()
        compare(e.x, 2)
        compare(e.y, 2)
        compare(f.x, 2)
        compare(f.y, 3)

        local g = a:sign()
        compare(g.x, 1)
        compare(g.y, -1)

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
        compare(a:angleTo(b), math.pi/4)

        -- test quantize (checking booleans to avoid the embedded quantize in compare)
        compare(b.x == 0, false)
        compare(b:quant().x == 0, true)

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

        compare(a*b, 39)

        local x,y = a:unpack()
        compare(x, 3)
        compare(y, 4)
    end,

}

-- run them
runTests(tests)
