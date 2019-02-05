local color = {}

color.cur = {0,0,0}
color.frame = 0
color.section = 1

color.update = function()
	color.frame = color.frame + 1 
	if color.frame > 480 then 
		color.frame = 0
		color.section = color.section + 1
		if color.section > 4 then 
			color.section = 0 
		end
	end

	if color.section == 1 then 
		color.cur = {color.frame/480,0,0}
	elseif color.section == 2 then 
		color.cur = {1,0,color.frame/480}
	elseif color.section == 3 then 
		color.cur = {1 - (color.frame/480),0,1}
	elseif color.section == 4 then 
		color.cur = {0,0,1 - (color.frame/480)}
	end

	return color.cur 
end

return color