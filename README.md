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

	vector 		= Vector(x,y)
	vector 		= VectorFromAngle(angle_rad)
	vector 		= VectorFromPolar(radius, angle)

Getting components:

	x 			= vector.x
	y 			= vector.y
	radius 		= vector:mod()
	angle 		= vector:angle()
	bool		= vector:isZero()

	(note: isZero returns true when both components are 0)

Operations:

	sum_of_vectors 			= vector1 + vector2
	difference 				= vector1 - vector2
	vector_by_scalar 		= vector * scalar
	scalar_by_vector 		= scalar * vector
	dot_product 			= vector1 * vector2
	per_component_product 	= vector1 ^ vector2
	
Single operand operations (returns copy, does not modify original):

	unmodified_copy 		= vector:copy()
	normalize 				= vector:norm()
	abs_of_components 		= vector:abs()
	floor_of_components 	= vector:floor()
	sign_of_components 		= vector:sign()
	rotate					= vector:rot(angle)

	(note: sign returns 1 if component >= 0, -1 if component < 0 )

-- Christiaan Janssen, August 2014
