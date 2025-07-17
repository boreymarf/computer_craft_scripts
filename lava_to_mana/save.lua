-- A simple library that allows saving and loading data from a file

local function save(table, name)
	local file = fs.open(name, "w")
	file.write(textutils.serialize(table))
	file.close()
end

local function load(name)
	if not fs.exists(name) then -- First check if file exists
		return nil
	end

	local file, err = fs.open(name, "r")
	if not file then
		print("Error opening file:", err)
		return nil
	end

	local file = fs.open(name, "r")
	local data = file.readAll()
	file.close()
	return textutils.unserialize(data)
end

return { save = save, load = load }
