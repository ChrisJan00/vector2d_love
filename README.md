vector2d_love
=============
by Christiaan Janssen

A convenience implementation of 2D vectors.  I don't expect this to be useful to
anyone else but me.  Since I use 2D math in many of my projects, it's convenient
to have it in Github, so that I can pull it when I start new projects.


Usage:
------

Including it in your project:

	require "vector" 

Creating:

	vector (rect)	= Vector(x,y)
	vector (polar)	= VectorFromPolar(radius, angle)
	unary_vector 	= VectorFromAngle(angle_rad)


Getting components:

	x 			= vector.x
	y 			= vector.y
	radius 		= vector:mod()
	angle 		= vector:angle()
	

Comparison:

	boolean     = vector:isZero()
    boolean     = vector:isEq(vector2)


Operations (return copy of vector):

	unmodified_copy 		= vector:copy()
	sum_of_vectors 			= vector1 + vector2
	difference 				= vector1 - vector2
	vector_by_scalar 		= vector * k
	scalar_by_vector 		= k * vector
	per_components_division = vector / k
	per_components_divide   = k / vector
	per_component_product 	= vector1 ^ vector2
	normalize 				= vector:norm()
	abs_of_components 		= vector:abs()
	floor_of_components 	= vector:floor()
	round_of_components     = vector:round()
	sign_of_components 		= vector:sign()
	rotate					= vector:rot(angle)
	angle_between_vectors	= vector:angleTo(vector_2)
	mirror					= -vector
	orthogonal(1)			= vector:ortho()
	orthogonal(2)			= -vector:ortho()
	limit_components        = vector:clamp(vector_of_min, vector_of_max)
	quantized_components    = vector:quant()


Operations (return number(s)):

	dot_product 			= vector1 * vector2
	x,y                     = vector:unpack()
	

Attach user data:
    
    The basic creation operation accepts one extra parameter "data", which is
    expected to be a table.  The table is appended to the vector.  Operations
    that return new vectors do NOT pass this data around.
    
    Example:
    local v2 = Vector(10,11,{foo="one", bar=-1})
    returns a vector { x = 10, y = 11, foo = "one", bar = -1 }


Notes:

	 * isZero(v) = (x,y) == (0,0)
	 * sign(a) = a>=0 ? 1 : -1
	 * ortho(x,y) = (y,-x)
	 * -ortho(x,y) = (-y,x)
	 * dist(v1,v2) = (v2-v1):mod()
	 * v2 = v1:rot(v2/v1)
	 * unpack does not return data
	 * call math.setQuantStep(step) to change v:quant() step


-- Christiaan Janssen, January 2015
