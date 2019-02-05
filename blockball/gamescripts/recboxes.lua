-- Perfect Rectangle Collision Detection, 
-- with data return, courtesy of Chris Harris, Index

local rec_col = {}

rec_col.newBox = function(x,y,w,h)
	local box = {}
	box.x = x
	box.y = y
	box.w = w
	box.h = h
	return box
end

rec_col.is_colliding = function(object1,object2) -- objects being boxes, and assuming object 1 is the one moving
	local ob_1= object1
	local ob_2 = object2

	local collision_data = false

	local within = {}
	within.x = false
	within.y = false

	if ob_1.x >= ob_2.x and ob_1.x <= (ob_2.x + ob_2.w) then 
		within.x = true
	end 
	if ob_1.y >= ob_2.y and ob_1.y <= (ob_2.y + ob_2.h) then
		within.y = true
	end
	if (ob_1.x + ob_1.w) >= ob_2.x and (ob_1.x + ob_1.w) <= (ob_2.x + ob_2.w) then 
		within.x = true
	end 
	if (ob_1.y + ob_1.h) >= ob_2.y and (ob_1.y + ob_1.h) <= (ob_2.y + ob_2.h) then
		within.y = true
	end
	if within.x == true and within.y == true then 
		collision_data = true
	end

	return collision_data
end

return rec_col