local time
local game
local font
local gh
local displaying-- Game or menu, display handler
local paused
function love.load()
	time = 0.0
	game = require'gamescripts/game'
	game.load()
	font = {}
	font.big = love.graphics.newFont("fonts/FSEX300.ttf",36)
	font.med = love.graphics.newFont("fonts/FSEX300.ttf",24)
	font.smal = love.graphics.newFont("fonts/FSEX300.ttf",16)
	love.graphics.setFont(font.big)
	gh = require 'gamescripts/garbagehelper'
	paused = false
	displaying = "game"
	math.randomseed(os.time())
end

function love.keypressed(key)
	if key == "w" then 
		game.keys.w = true
	end
	if key == "a" then 
		game.keys.a = true
	end
	if key == "s" then 
		game.keys.s = true
	end
	if key == "d" then 
		game.keys.d = true
	end
	if key == "b" then 
		game.keys.b = true
	end
	if key == "p" and displaying == "game" then 
		if paused == false then 
			paused = true
		else
			paused = false
		end
	end
end

function love.keyreleased(key)
	if key == "w" then 
		game.keys.w = false
	end

	if key == "a" then 
		game.keys.a = false
	end
	if key == "s" then 
		game.keys.s = false
	end
	if key == "d" then 
		game.keys.d = false
	end
	if key == "b" then 
		game.keys.b = false
	end
end

function love.update(dt)
	time = time + dt
	if paused ~= true then 
		game.update(dt)
	end
	gh.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0.65,0.65,0.65)
	if displaying == "game" then 
		game.draw()
		love.graphics.setColor(1,1,1)
		love.graphics.print("TIME:"..math.floor(time),10,525)
		love.graphics.setColor(1,1,1)
		love.graphics.print("FPS:"..math.ceil(love.timer.getFPS()),10,560)
		if paused == true then 
			love.graphics.print("PAUSED",350,30)
		end
		if game.won.status == true then 
			love.graphics.setColor(0,0,0,0.65)
			love.graphics.rectangle("fill",0,0,800,600)
			love.graphics.setColor(1,1,1)
			love.graphics.print("END. SCORE:"..game.score,350 - (game.score * 0.6),225)
		end
	end
end