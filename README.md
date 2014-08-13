vector_love
===========
by Christiaan Janssen

A convenience implementation of 2D vectors.  I don't expect this to be useful to
anyone else but me.  Since I use 2D math in many of my projects, it's convenient
to have it in Github, so that I can pull it when I start new projects.


Usage:
------

Including it in your project:

	require "vector" 

Creating:

	vector 			= Vector(x,y)
	vector 			= VectorFromPolar(radius, angle)
	unary_vector 	= VectorFromAngle(angle_rad)


Getting components:

	x 			= vector.x
	y 			= vector.y
	radius 		= vector:mod()
	angle 		= vector:angle()
	boolean		= vector:isZero()


Operations (return copy of vector):

	unmodified_copy 		= vector:copy()
	sum_of_vectors 			= vector1 + vector2
	difference 				= vector1 - vector2
	vector_by_scalar 		= vector * k
	scalar_by_vector 		= k * vector
	per_component_product 	= vector1 ^ vector2
	normalize 				= vector:norm()
	abs_of_components 		= vector:abs()
	floor_of_components 	= vector:floor()
	sign_of_components 		= vector:sign()
	rotate					= vector:rot(angle)
	mirror					= -vector
	orthogonal(1)			= vector:ortho()
	orthogonal(2)			= -vector:ortho()


Operations (return number):

	dot_product 			= vector1 * vector2
	angle_between_vectors	= vector_to / vector_from


Notes:

	 * isZero(v) = (x,y) == (0,0)
	 * sign(a) = a>=0 ? 1 : -1
	 * ortho(x,y) = (y,-x)
	 * -ortho(x,y) = (-y,x)
	 * dist(v1,v2) = (v2-v1):mod()
	 * v2 = v1:rot(v2/v1)


-- Christiaan Janssen, August 2014
