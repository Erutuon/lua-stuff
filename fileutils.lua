local m = {}

local string = string
local concat = table.concat
function string.pgsub(str, from, to, count)
	from = from:gsub('%p', '%%%0') -- lazy version
	return string.gsub(str, from, to, count)
end

--[[
	Process the contents of a file with a function.
	(Should not be used on binary files; messes up images,
	for instance.)
]]

local sformat = string.format

local function errorf(msg, level, ...)
	error(sformat(msg, ...), level)
end

local function printf(...)
	print(sformat(...))
end

local function typeassert(actualtype, expectedtype, funcname, i)
	if actualtype ~= expectedtype then
		errorf('bad argument #%d to %s (%s expected, got %s)',
			2, i, funcname, expectedtype, actualtype)
	end
end


local function modify (filepath, modify)
	if filepath:find([[%.%.?$]]) then return end
	
	typeassert(type(filepath), 'string', 'modifyfile', 1)
	typeassert(type(modify), 'function', 'modifyfile', 2)
	
	local file = assert(io.open(filepath, 'rb'),
		sformat('Could not open file %s', filepath))
	
	local text = file:read('a')
	if not text then
		printf('Could not read file %s', filepath)
		return
	end
	if text == '' then return end
	file:close()
	
	text = modify(text)
	
	if type(text) ~= 'string' then
		printf('Modify function returned %s rather than a string for %s; file not modified', type(text), filepath)
		return
	end
	
	file = io.open(filepath, 'wb')
	if not file:write(text) then
		printf('Could not write to file %s', filepath)
	end
	if not file:flush() then
		printf('Could not flush changes to file %s', filepath)
	end
	file:close()
	printf('Modified %s', filepath)
end

m.modify = modify

local function get_content (path)
	typeassert(type(path), 'string', 'get_content', 1)
	local file = assert(io.open(path, 'rb')) -- Avoid weird modifications done in Windows text mode.
	text = assert(file:read 'a', sformat('The file %s is empty.', path))
	file:close()
	return text
end

m.get_content = get_content

local mt = {}
setmetatable(m, mt)

-- Automatically create functions for each of the string-matching functions if needed.
function mt.__index (self, key)
	local out
	if key == 'find' or key == 'match' or key == 'gmatch' then
		out = function (path, ...)
			typeassert(type(path), 'string', key, 1)
			text = get_content(path)
			return string[key](text, ...)
		end
	elseif key == 'gsub' or key == 'pgsub' then
		out = function (path, from, to, count)
			typeassert(type(path), 'string', key, 1)
			modify(
				path,
				function (text)
					return string[key](text, from, to, count)
				end)
		end
	end
	self[key] = out
	
	return out
end

m.string_matching_funcs = concat({ 'find', 'match', 'gmatch', 'gsub', 'pgsub' }, ' ')

local function get_length (path)
	local file = assert(io.open(path, 'rb'))
	local length = file:seek 'end'
	file:close()
	return length
end

m.get_length = get_length

return m