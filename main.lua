Input = require'libraries/input/Input'
function love.load()
	local object_files = {}
	recursiveEnumerate("objects", object_files)
	requireFiles(object_files)
	hyperCircle = HyperCircle(400,300,50,10, 120)
	input = Input()
  input:bind('mouse1', 'test')
end

function requireFiles(files)
	for _,file in ipairs(files) do 
		local file = file:sub(1, -5)
		local last_forward_slash_index = file:find("/[^/]*$")
		local class_name = file:sub(last_forward_slash_index+1, #file)
		_G[class_name] = require(file)
	end
end


function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder.. '/' .. item -- bsp folder = objects, item = test.lua => objects/test.lua
		if love.filesystem.getInfo(file) then
			table.insert(file_list,file)
		elseif love.filesystem.isDirectory(file) then
			recursiveEnumerate(file,file_list)
		end
	end
end

function love.update(dt)
		if input:pressed('test') then print('pressed') end
		if input:released('test') then print('released') end
		if input:down('test') then print('released') end

		hyperCircle:update(dt)
end

function love.draw()
		hyperCircle:draw()
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	local const_dt = 1/60
	local accumulator = 0.0
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		--normal 
		if love.timer then dt = love.timer.step() end
	
		accumulator = accumulator +dt
		-- Call update and draw
		while accumulator>= const_dt do
			if love.update then love.update(const_dt) end -- will pass 0 if love.timer is disabled
			accumulator = accumulator-const_dt
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			if love.draw then love.draw() end
 
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
end
