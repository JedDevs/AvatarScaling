local HumanoidDescription = {}
HumanoidDescription.__index = HumanoidDescription

--// Knit Framework
local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

--// Local Variables
local MODIFIABLE_DESCRIPTIONS = {
	"DepthScale", "HeightScale", "ProportionScale", "BodyTypeScale", "WidthScale", "HeadScale"
}
local TYPE_ERROR = "Invalid 'type'"
local SIZE_ERROR = "Invalid 'size'"

local function checkTableNumber(table)
	if type(table) ~= "table" then return false, "wrong type" end
	for _,v in ipairs(table) do
		local vSerilized = tonumber(v)
		if type(vSerilized) ~= "number" or vSerilized > 1 or vSerilized < 0 then return false, SIZE_ERROR end
		v = vSerilized -- incase it's a string
	end

	return true, "valid"
end

function  HumanoidDescription:UpdateDescription()
	self.newDescription = self.humanoid:GetAppliedDescription()
	
	for index, property in ipairs(self.searchTable) do
		local val = self.sizes
		if type(val) == "table" then
			val = val[index]
		end
		self.newDescription[property] = val
	end

	return self.newDescription
end

function HumanoidDescription:RefreshCharacter(player)
	self.character = player.Character or player.CharacterAdded:Wait()
	self.humanoid = self.character:WaitForChild("Humanoid")
end

function HumanoidDescription.new(player: Instance, types: any, sizes: any)
	local sizesSuccess, sizesResult = checkTableNumber(sizes)
	if typeof(sizes) == "table" and not sizesSuccess then return sizesSuccess, sizesResult end
	if typeof(types) == "string" and (string.lower(types) ~= "all" and not table.find(MODIFIABLE_DESCRIPTIONS, string.lower(types))) then return false, TYPE_ERROR end
	local self = {
		player = player,
		character = player.Character or player.CharacterAdded:Wait(),
		_maid = Maid.new(),

		searchTable = {},
		sizes = sizes
	}

	if not player.CharacterAppearanceLoaded then
        player.CharacterAppearanceLoaded:Wait()
    end
	print("Player Character Appearance Loaded")

	self.humanoid = self.character:WaitForChild("Humanoid")
	self.oldDescription = self.humanoid:GetAppliedDescription()

	if typeof(types) == "string" and string.lower(types) == "all" then
		self.searchTable = MODIFIABLE_DESCRIPTIONS
	elseif typeof(types) == "table" then
		self.searchTable = types
	else
		return false, TYPE_ERROR.." and/or "..SIZE_ERROR
	end

	setmetatable(self, HumanoidDescription)

	self:UpdateDescription()
	return true, self
end

function HumanoidDescription:ApplyDescription()
	if not self.newDescription or not self.humanoid then return end
	self.humanoid:ApplyDescription(self:UpdateDescription())
end

function HumanoidDescription:RevertDescription()
	if not self.oldDescription or not self.humanoid then return end
	self.humanoid:ApplyDescription(self.oldDescription)
end

function HumanoidDescription:Destroy()
	self._maid:DoCleaning()
	self._maid = nil
	self = nil
end


return HumanoidDescription
