local game = {}
local Math = require'math'
local hc = require'gamescripts/recboxes'
local red = {0.9,0.2,0.15}
local blue = {0.15,0.2,0.9}
local grey = {0.7,0.72,0.78}
local color = require'misc/colors'
local plr = {}
plr.x = 400
plr.y = 300
plr.w = 50
plr.h = 50
plr.movespeed = 5
plr.box = hc.newBox(plr.x+5 , plr.y+5 ,plr.h-10 ,plr.w-10)
plr.color = red
plr.health = 10

game.score = 0
game.keys = {}
game.keys.w = false
game.keys.a = false
game.keys.s = false
game.keys.d = false
game.keys.b = false
game.time = 0.0
game.score = 0

local wall_boxes = {}
local walls = {}
local bullets = {}

local cam_offset = {0,0}
local enemies = {}

game.load = function()
	wall_boxes = {}
	walls = {}
	bullets = {}
	cam_offset = {0,0}
	enemies = {} 
	plr.x = 400
	plr.y = 300
	plr.w = 50
	plr.h = 50
	plr.health = 10
	plr.movespeed = 5
	plr.box = hc.newBox(plr.x+5 , plr.y+5 ,plr.h-10 ,plr.w-10)
	plr.color = red
	game.score = 0
	local wall_left = {}
	wall_left.x = 0 
	wall_left.y = 0
	wall_left.w = 30
	wall_left.h = 600
	wall_left.color = grey
	table.insert(wall_boxes,hc.newBox(0,0,30,600))
	table.insert(walls,wall_left)
	local wall_right = {}
	wall_right.x = 770 
	wall_right.y = 0
	wall_right.w = 30
	wall_right.h = 600
	wall_right.color = grey
	table.insert(wall_boxes,hc.newBox(770,0,30,600))
	table.insert(walls,wall_right)
	local wall_top = {}
	wall_top.x = 0 
	wall_top.y = 0
	wall_top.w = 800
	wall_top.h = 30
	wall_top.color = grey
	table.insert(wall_boxes,hc.newBox(0,0,800,30))
	table.insert(walls,wall_top)
	local wall_bot = {}
	wall_bot.x = 0 
	wall_bot.y = 570
	wall_bot.w = 800
	wall_bot.h = 30
	wall_bot.color = grey
	table.insert(wall_boxes,hc.newBox(0,570,800,30))
	table.insert(walls,wall_bot)
	game.time = 0.0
end

function make_bullet()
	local bullet = {}
	bullet.x = plr.x + (plr.w/2)
	bullet.y = plr.y + (plr.h/2)
	bullet.w = 7
	bullet.h = 7
	bullet.color = {0,1,0}
	bullet.being_removed = false
	bullet.box = hc.newBox(bullet.x,bullet.y,bullet.w,bullet.h)
	local mouse_x = love.mouse.getX()
	local mouse_y = love.mouse.getY()

	local angle = Math.atan2((mouse_y - bullet.y), (mouse_x - bullet.x))
	bullet.velocity = {8 * Math.cos(angle),8 * Math.sin(angle)}
	table.insert(bullets,bullet)
end

function updateBullets()
	for i,v in pairs(bullets) do 
		local b = v
		b.x = b.x + b.velocity[1]
		b.y = b.y + b.velocity[2]
		b.box.x = b.x
		b.box.y = b.y
		for j,c in pairs(wall_boxes) do 
			if hc.is_colliding(b.box,c) == true then 
				bullets[i].being_removed = true
			end
		end
		for j,c in pairs(enemies) do 
			local en = c or nil
			if en ~= nil then 
				if hc.is_colliding(b.box,enemies[j].box) == true then 
					enemies[j].health = enemies[j].health - 1 
					bullets[i].being_removed = true
				end
			end
		end 
	end
	local shift = 0
	for j,c in pairs(bullets) do 
		local ind = j - shift
		if bullets[ind].being_removed == true then 
			table.remove(bullets,ind)
			shift = shift + 1
		end
	end
end

function make_enemy()
	local enemy = {}
	if plr.x > 400 then 
		enemy.x = Math.random(70,430)
	else
		enemy.x = Math.random(430,730)
	end
	enemy.y = Math.random(70,530)
	enemy.w = 40
	enemy.h = 40
	enemy.health = 4
	enemy.movespeed = 4
	local angle = Math.atan2((plr.y - enemy.y), (plr.x - enemy.x))
	enemy.velocity = {enemy.movespeed * Math.cos(angle) ,enemy.movespeed * Math.sin(angle)}
	enemy.box = hc.newBox(enemy.x,enemy.y,enemy.w,enemy.h)
	table.insert(enemies,enemy)
end
local upd_vel = {}
upd_vel.cur = 79 
upd_vel.max = 30
upd_vel.updating = false

function update_enemy()
	upd_vel.cur = upd_vel.cur + 1
	upd_vel.updating = false
	if upd_vel.cur >= upd_vel.max then
		upd_vel.cur = 0
		upd_vel.updating = true
	end 
	for i,v in pairs(enemies) do 
		if upd_vel.updating == true then 
			local angle = Math.atan2((plr.y - v.y), (plr.x - v.x))
			v.velocity = {v.movespeed * Math.cos(angle),v.movespeed * Math.sin(angle)}
			for j,c in pairs(enemies) do 
				if Math.abs((v.x + v.w/2) - (c.x + c.w/2)) <= 60 then 
					if (v.x + v.w/2) - (c.x + c.w/2) < 0 then 
						v.velocity[1] = v.velocity[1] + (v.velocity[1] * 0.5)
					else
						v.velocity[1] = v.velocity[1] - (v.velocity[1] * 0.5)
					end
				end
				if Math.abs((v.y + v.h/2) - (c.y + c.h/2)) <= 60 then 
					if (v.y + v.h/2) - (c.y + c.h/2) < 0 then 
						v.velocity[2] = v.velocity[2] + (v.velocity[2] * 0.5)
					else
						v.velocity[2] = v.velocity[2] - (v.velocity[2] * 0.5)
					end
				end
			end
		end

		v.box.x = v.box.x + v.velocity[1]
		for j,c in pairs(wall_boxes) do 
			if hc.is_colliding(v.box,c) then 
				v.box.x = v.box.x - v.velocity[1]
			end
		end
		v.box.y = v.box.y + v.velocity[2]
		for j,c in pairs(wall_boxes) do 
			if hc.is_colliding(v.box,c) then
				v.box.y = v.box.y - v.velocity[2]
			end
		end
		if hc.is_colliding(plr.box,v) then 
			v.health = 0
			plr.health = plr.health - 1
		end
		v.x = v.box.x
		v.y = v.box.y
	end
end

local can_shoot = {}
can_shoot.cur = 0
can_shoot.rps = 4
can_shoot.max = Math.max(60/can_shoot.rps)

game.won = {}
game.won.status = false
game.won.leave = false

game.update = function(dt)
	if plr.health > 0 then 
	game.time = game.time + dt 
	if game.time >= 120 then 
		plr.health = 0
		game.won.status = true
	end
	if #enemies <= 0 then 
		for i = 1,4 do 
			make_enemy()
		end
	end
	update_enemy()
	local shift = 0
	for i,v in pairs(enemies) do
		if v.health <= 0 then 
			table.remove(enemies,i-shift)
			shift = shift + 1
			game.score = game.score + 10
		end
	end

	local ats = false
	can_shoot.cur = can_shoot.cur + 1
	if can_shoot.cur >= can_shoot.max then 
		ats = true
		can_shoot.cur = 0
	end

	if love.mouse.isDown(1) and ats == true then 
		make_bullet()
	end
	updateBullets()
	if game.keys.w == true then 
		plr.box.y = plr.box.y - plr.movespeed
		local hitting = false
		for i,v in pairs(wall_boxes) do 
			if hc.is_colliding(plr.box,v) == true then 
				hitting = true
				break
			end
		end
		if hitting == true then 
			plr.box.y = plr.box.y + plr.movespeed
		else
			plr.x = plr.box.x - plr.movespeed
			plr.y = plr.box.y - plr.movespeed
		end
	end

	if game.keys.a == true then 
		plr.box.x = plr.box.x - plr.movespeed
		local hitting = false
		for i = 1,#wall_boxes do 
			if hc.is_colliding(plr.box,wall_boxes[i]) == true then 
				hitting = true
				break
			end
		end
		if hitting == true then 
			plr.box.x = plr.box.x + plr.movespeed
		else
			plr.x = plr.box.x - plr.movespeed
			plr.y = plr.box.y - plr.movespeed
		end
	end

	if game.keys.s == true then 
		plr.box.y = plr.box.y + plr.movespeed
		local hitting = false
		for i = 1,#wall_boxes do 
			if hc.is_colliding(plr.box,wall_boxes[i]) == true then 
				hitting = true
				break
			end
		end
		if hitting == true then 
			plr.box.y = plr.box.y - plr.movespeed
		else
			plr.x = plr.box.x - plr.movespeed
			plr.y = plr.box.y - plr.movespeed
		end
	end

	if game.keys.d == true then 
		plr.box.x = plr.box.x + plr.movespeed
		local hitting = false
		for i = 1,#wall_boxes do 
			if hc.is_colliding(plr.box,wall_boxes[i]) == true then 
				hitting = true
				break
			end
		end
		if hitting == true then 
			plr.box.x = plr.box.x - plr.movespeed
		else
			plr.x = plr.box.x - plr.movespeed
			plr.y = plr.box.y - plr.movespeed
		end
	end
	local curcol = color.update()
	for i = 1,#walls do 
		walls[i].color = curcol
	end
	else
		game.won.status = true
	end
end

game.draw = function()
	local xo = cam_offset[1]
	local yo = cam_offset[2]
	for i,v in pairs(walls) do 
		local cw = walls[i]
		love.graphics.setColor(cw.color[1],cw.color[2],cw.color[3])
		love.graphics.rectangle("fill",xo+cw.x,yo+cw.y,cw.w,cw.h)
	end
	love.graphics.setColor(plr.color[1],plr.color[2],plr.color[3])
	love.graphics.rectangle("fill",xo+plr.x,yo+plr.y,plr.w,plr.h)
	love.graphics.setColor(0.8,0.1,0.1)
	love.graphics.rectangle("fill",plr.x,plr.y - 14,plr.w,10)
	love.graphics.setColor(0.1,0.8,0.1)
	love.graphics.rectangle("fill",plr.x + 2,plr.y - 12,(plr.health/10)*(plr.w-4),6)
	for i,v in pairs(enemies) do 
		love.graphics.setColor(0.1,0.8,0.1)
		love.graphics.rectangle("fill",v.x,v.y,v.w,v.h)
		love.graphics.setColor(0.8,0.1,0.1)
		love.graphics.rectangle("fill",v.x,v.y + v.h + 3,v.w,12)
		love.graphics.setColor(0.1,0.8,0.1)
		love.graphics.rectangle("fill",v.x + 2,(v.y + v.h + 5),(v.health/4) * v.w - 4,8)
	end

	for i,v in pairs(bullets) do 
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",xo+bullets[i].x - 1,yo+bullets[i].y - 1,bullets[i].w+2,bullets[i].h+2)
		love.graphics.setColor(0,0.6,0.3)
		love.graphics.rectangle("fill",xo+bullets[i].x,yo+bullets[i].y,bullets[i].w,bullets[i].h)
	end

	if game.keys.b == true then 
		love.graphics.setColor(1,1,1,0.85)
		for i = 1,#wall_boxes do 
			local cb = wall_boxes[i]
			love.graphics.rectangle("line",xo+cb.x,yo+cb.y,cb.w,cb.h)
		end
		love.graphics.rectangle("line",xo+plr.box.x,yo+plr.box.y,plr.box.h,plr.box.w)
	end
end

return game