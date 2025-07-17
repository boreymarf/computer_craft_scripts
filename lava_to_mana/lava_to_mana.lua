local save = require("save")

local FLOWER_WORK_TIME = 30
local COOLDOWN_MULTIPLIER = 20

local names = peripheral.getNames()
local redrouters = {}

local cycle_tasks = {}

local monitor = nil
local total_flowers = 0
local working_flowers = 0
local stats = {
	lava_buckets_used = 0
}

local function update_monitor()
	if monitor == nil then
		return
	end

	monitor.clear()
	monitor.setTextScale(2)
	monitor.setCursorPos(1, 1)
	monitor.write("Working flowers:")
	monitor.setCursorPos(1, 2)
	monitor.write(string.format("%d out of %d", working_flowers, total_flowers))
	monitor.setCursorPos(1, 3)
	monitor.write("Used lava buckets:")
	monitor.setCursorPos(1, 4)
	monitor.write(stats.lava_buckets_used)
end

-- The main cycle
local function collect_cycle(name, redrouter)
	while true do
		redrouter.setOutput("right", true)
		os.sleep(1)
		redrouter.setOutput("right", false)

		working_flowers = working_flowers + 1
		stats.lava_buckets_used = stats.lava_buckets_used + 1
		update_monitor()
		save.save(stats, "stats.txt")
		print("Redrouter", name, "poured lava")

		os.sleep(FLOWER_WORK_TIME + 1)

		working_flowers = working_flowers - 1
		update_monitor()

		local flower_output = redrouter.getAnalogInput("front")
		local flower_cooldown = flower_output * COOLDOWN_MULTIPLIER

		print("Redrouter", name, "is on cooldown:", flower_cooldown, "s")

		os.sleep(flower_cooldown + 1)
	end
end

local data = save.load("stats.txt")
if data ~= nil then
	stats = data
end

-- Setup connections
for _, name in ipairs(names) do
	if peripheral.getType(name) == "redrouter" then
		redrouters[name] = peripheral.wrap(name)
	end
	if peripheral.getType(name) == "monitor" and monitor == nil then
		monitor = peripheral.wrap(name)
	end
end

-- Setup the tasks
for name, redrouter in pairs(redrouters) do
	if redrouter == nil then
		error("Failed to wrap redrouter: ", name)
	else
		print("Found redrouter: ", name)
		total_flowers = total_flowers + 1
	end

	table.insert(cycle_tasks, function()
		collect_cycle(name, redrouter)
	end)
end

-- Start all tasks
parallel.waitForAll(table.unpack(cycle_tasks))
